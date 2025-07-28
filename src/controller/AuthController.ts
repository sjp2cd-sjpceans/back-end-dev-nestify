import { Request, Response } from 'express';
import bcrypt from 'bcrypt';
import pool from '@dev_nestify/db/connection';
import { signToken } from '@dev_nestify/auth/jwtMiddleware';

export class AuthController {
  static async login(req: Request, res: Response) {
    try {
      const { usernameOrEmail, password } = req.body;
      
      if (!usernameOrEmail || !password) {
        return res.status(400).json({ error: 'Username/email and password are required' });
      }

      const conn = await pool.getConnection();
      
      try {
        // Query user by either username or email
        const [users] = await conn.query(
          `SELECT ua.id, ua.username, ua.password_hash, ua.actor_profile_id, 
                  ap.first_name, ap.last_name, ap.email, ar.name as role
           FROM user_account ua
           JOIN actor_profile ap ON ua.actor_profile_id = ap.id
           JOIN actor_role ar ON ap.actor_role_id = ar.id
           WHERE ua.username = ? OR ap.email = ?`,
          [usernameOrEmail, usernameOrEmail]
        );

        if (!Array.isArray(users) || users.length === 0) {
          return res.status(401).json({ error: 'Invalid username/email or password' });
        }

        const user = users[0] as any;

        const isPasswordValid = await bcrypt.compare(password, user.password_hash);
        if (!isPasswordValid) {
          return res.status(401).json({ error: 'Invalid username/email or password' });
        }

        const token = signToken(user.username);

        return res.status(200).json({
          token,
          user: {
            id: user.id,
            email: user.email,
            firstName: user.first_name,
            lastName: user.last_name,
            role: user.role.toLowerCase()
          }
        });
      } finally {
        conn.release();
      }
    } catch (error) {
      console.error('Login error:', error);
      return res.status(500).json({ error: 'Internal server error' });
    }
  }

  // Register a new user
  static async register(req: Request, res: Response) {
    try {
      const { firstName, lastName, email, password, role } = req.body;
      
      if (!firstName || !lastName || !email || !password || !role) {
        return res.status(400).json({ error: 'All fields are required' });
      }

      const conn = await pool.getConnection();
      
      try {
        await conn.beginTransaction();
        
        const [existingUsers] = await conn.query(
          'SELECT id FROM actor_profile WHERE email = ?',
          [email]
        );
        
        if (Array.isArray(existingUsers) && existingUsers.length > 0) {
          return res.status(409).json({ error: 'Email already in use' });
        }
        
        const [roles] = await conn.query(
          'SELECT id FROM actor_role WHERE name = ?',
          [role]
        );
        
        if (!Array.isArray(roles) || roles.length === 0) {
          return res.status(400).json({ error: 'Invalid role' });
        }
        
        const roleId = (roles[0] as any).id;
        
        const [profileResult] = await conn.query(
          `INSERT INTO actor_profile 
           (first_name, middle_name, last_name, email, actor_role_id) 
           VALUES (?, NULL, ?, ?, ?)`,
          [firstName, lastName, email, roleId]
        );
        
        const profileId = (profileResult as any).insertId;
        
        // Create username from email
        const username = email.split('@')[0];
        
        const saltRounds = 12;
        const passwordHash = await bcrypt.hash(password, saltRounds);
        
        const [userResult] = await conn.query(
          `INSERT INTO user_account 
           (actor_profile_id, username, password_hash, is_verified) 
           VALUES (?, ?, ?, 1)`,
          [profileId, username, passwordHash]
        );
        
        const userId = (userResult as any).insertId;
        
        // If role is client, insert into actor_client
        if (role.toLowerCase() === 'client') {
          await conn.query(
            'INSERT INTO actor_client (actor_profile_id) VALUES (?)',
            [profileId]
          );
        }
        
        // If role is agent, insert into actor_agent
        if (role.toLowerCase() === 'agent') {
          // Generate a license number
          const licenseNumber = `LIC-${Math.floor(1000 + Math.random() * 9000)}`;
          
          await conn.query(
            'INSERT INTO actor_agent (actor_profile_id, license_number, performance_rating) VALUES (?, ?, 0.00)',
            [profileId, licenseNumber]
          );
        }
        
        await conn.commit();
        
        const token = signToken(username);
        
        // Return user info and token
        return res.status(201).json({
          token,
          user: {
            id: userId,
            email,
            firstName,
            lastName,
            role: role.toLowerCase()
          }
        });
      } catch (error) {
        await conn.rollback();
        throw error;
      } finally {
        conn.release();
      }
    } catch (error) {
      console.error('Registration error:', error);
      return res.status(500).json({ error: 'Internal server error' });
    }
  }

  // Verify token is valid
  static async verify(req: Request, res: Response) {
    return res.status(200).json({ valid: true });
  }

  // Get current user profile
  static async me(req: Request & { user?: { userName: string } }, res: Response) {
    try {
      if (!req.user?.userName) {
        return res.status(401).json({ error: 'Unauthorized' });
      }

      const userName = req.user.userName;
      
      const conn = await pool.getConnection();
      
      try {
        // Query user by username
        const [users] = await conn.query(
          `SELECT ua.id, ua.username, ap.first_name, ap.last_name, ap.email, ar.name as role
           FROM user_account ua
           JOIN actor_profile ap ON ua.actor_profile_id = ap.id
           JOIN actor_role ar ON ap.actor_role_id = ar.id
           WHERE ua.username = ?`,
          [userName]
        );

        // Check if user exists
        if (!Array.isArray(users) || users.length === 0) {
          return res.status(404).json({ error: 'User not found' });
        }

        const user = users[0] as any;

        // Return user info
        return res.status(200).json({
          id: user.id,
          email: user.email,
          firstName: user.first_name,
          lastName: user.last_name,
          role: user.role.toLowerCase()
        });
      } finally {
        conn.release();
      }
    } catch (error) {
      console.error('Get profile error:', error);
      return res.status(500).json({ error: 'Internal server error' });
    }
  }
} 