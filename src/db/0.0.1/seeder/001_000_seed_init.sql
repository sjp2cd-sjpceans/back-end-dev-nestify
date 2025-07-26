START TRANSACTION;


INSERT INTO country (id, name, zip_code, time_zone, currency_code)
VALUES
  (1,'United States','10001','America/New_York','USD'),
  (2,'Philippines','1000','Asia/Manila','PHP'),
  (3,'Canada','A1A1A1','America/Toronto','CAD'),
  (4,'Australia','2000','Australia/Sydney','AUD'),
  (5,'UK','EC1A1BB','Europe/London','GBP'),
  (6,'Germany','10115','Europe/Berlin','EUR'),
  (7,'Japan','100-0001','Asia/Tokyo','JPY'),
  (8,'Singapore','018989','Asia/Singapore','SGD'),
  (9,'India','110001','Asia/Kolkata','INR'),
  (10,'France','75001','Europe/Paris','EUR')
ON DUPLICATE KEY UPDATE
  name=VALUES(name), zip_code=VALUES(zip_code),
  time_zone=VALUES(time_zone), currency_code=VALUES(currency_code);


INSERT INTO city (id, name)
VALUES
  (1,'New York'),(2,'Manila'),(3,'Toronto'),
  (4,'Sydney'),(5,'London'),(6,'Berlin'),
  (7,'Tokyo'),(8,'Singapore'),(9,'Mumbai'),
  (10,'Paris')
ON DUPLICATE KEY UPDATE name=VALUES(name);


INSERT INTO map_coordinate (id, latitude, longitude)
VALUES
  (1,40.712776,-74.005974),(2,14.599512,120.984222),
  (3,43.653225,-79.383186),(4,-33.868820,151.209290),
  (5,51.507351,-0.127758),(6,52.520008,13.404954),
  (7,35.689487,139.691711),(8,1.352083,103.819836),
  (9,19.075983,72.877655),(10,48.856613,2.352222)
ON DUPLICATE KEY UPDATE
  latitude=VALUES(latitude), longitude=VALUES(longitude);


INSERT INTO address (id, unit_number, street, city_id, country_id, map_coordinate_id)
VALUES
  (1,'101','5th Avenue',1,1,1),(2,'202','Roxas Blvd',2,2,2),
  (3,'303','Queen St',3,3,3),(4,'404','George St',4,4,4),
  (5,'505','Baker St',5,5,5),(6,'606','Unter den Linden',6,6,6),
  (7,'707','Shinjuku',7,7,7),(8,'808','Orchard Rd',8,8,8),
  (9,'909','Marine Drive',9,9,9),(10,'100','Champs-Élysées',10,10,10)
ON DUPLICATE KEY UPDATE
  unit_number=VALUES(unit_number), street=VALUES(street),
  city_id=VALUES(city_id), country_id=VALUES(country_id),
  map_coordinate_id=VALUES(map_coordinate_id);


INSERT INTO property_type (id, name, description)
VALUES
  (1,'Villa','Luxury standalone villa'),
  (2,'Loft','Open-plan city loft'),
  (3,'Land','Vacant land parcel'),
  (4,'Condo','High-rise condominium'),
  (5,'Cottage','Cozy countryside cottage'),
  (6,'House','Suburban family home'),
  (7,'Studio','Compact urban studio'),
  (8,'Cabin','Rustic mountain cabin'),
  (9,'Penthouse','Top-floor luxury unit'),
  (10,'Townhouse','Multi-level attached home')
ON DUPLICATE KEY UPDATE
  name=VALUES(name), description=VALUES(description);


INSERT INTO sales_office (id, name, address_id, city, country, zip_code, email, phone)
VALUES
  (1,'NY Downtown Office',1,'New York','USA','10001','ny-office@example.com','212-000-1111'),
  (2,'MNL Main Office',2,'Manila','PH','1000','mnl-office@example.com','02-000-2222'),
  (3,'TOR Central',3,'Toronto','CA','A1A 1A1','tor-office@example.com','416-000-3333'),
  (4,'SYD Harbour',4,'Sydney','AU','2000','syd-office@example.com','02-000-4444'),
  (5,'LON West End',5,'London','UK','EC1A1BB','lon-office@example.com','020-000-5555'),
  (6,'BER Mitte',6,'Berlin','DE','10115','ber-office@example.com','030-000-6666'),
  (7,'TYO Shibuya',7,'Tokyo','JP','100-0001','tyo-office@example.com','03-000-7777'),
  (8,'SGP Orchard',8,'Singapore','SG','018989','sgp-office@example.com','65-0000-8888'),
  (9,'MUM South',9,'Mumbai','IN','400001','mum-office@example.com','022-000-9999'),
  (10,'PAR Champs',10,'Paris','FR','75001','par-office@example.com','01-000-1010')
ON DUPLICATE KEY UPDATE
  name=VALUES(name), address_id=VALUES(address_id),
  city=VALUES(city), country=VALUES(country),
  zip_code=VALUES(zip_code), email=VALUES(email), phone=VALUES(phone);


INSERT INTO agent (id, first_name, last_name, email, phone, license_number, sales_office_id)
VALUES
  (1,  'Tony',    'Stark',      'tony.stark@starkindustries.com',     '555-IRON1',  'LIC-IM1001', 1),
  (2,  'Bruce',   'Wayne',      'bruce.wayne@wayneenterprises.com',   '555-BAT2',   'LIC-BM2002', 2),
  (3,  'Peter',   'Parker',     'peter.parker@dailybugle.com',        '555-SPD3',   'LIC-SM3003', 2),
  (4,  'Clark',   'Kent',       'clark.kent@dailyplanet.com',         '555-SMN4',   'LIC-SM4004', 3),
  (5,  'Diana',   'Prince',     'diana.prince@themyscira.gov',       '555-WW505',  'LIC-WW5005', 4),
  (6,  'Bruce',   'Banner',     'bruce.banner@avengers.org',          '555-HUL6',   'LIC-HK6006', 5),
  (7,  'Barry',   'Allen',      'barry.allen@ccpd.gov',               '555-FLS7',   'LIC-FL7007', 6),
  (8,  'Arthur',  'Curry',      'arthur.curry@atlantis.gov',          '555-AQM8',   'LIC-AM8008', 7),
  (9,  'Natasha', 'Romanoff',   'natasha.romanoff@shield.gov',        '555-BW909',  'LIC-BW9009', 8),
  (10, 'Hal',     'Jordan',     'hal.jordan@guardian-corps.com',      '555-GL010',  'LIC-GL1010', 9)
ON DUPLICATE KEY UPDATE
  first_name      = VALUES(first_name),
  last_name       = VALUES(last_name),
  email           = VALUES(email),
  phone           = VALUES(phone),
  license_number  = VALUES(license_number),
  sales_office_id = VALUES(sales_office_id);

-- INSERT INTO agent (id, first_name, last_name, email, phone, license_number, sales_office_id)
-- VALUES
--   (1,'Alice','Johnson','alice.j@example.com','555-1234','LIC-1001',1),
--   (2,'Bob','Santos','bob.s@example.ph','0917-123-4567','LIC-2002',2),
--   (3,'Carol','Tan','carol.t@example.ph','0917-222-3333','LIC-3003',2),
--   (4,'David','Lee','david.l@example.com','555-2345','LIC-4004',3),
--   (5,'Eve','Wong','eve.w@example.com','555-3456','LIC-5005',4),
--   (6,'Frank','Ng','frank.n@example.com','555-4567','LIC-6006',5),
--   (7,'Grace','Kim','grace.k@example.com','555-5678','LIC-7007',6),
--   (8,'Hank','Yu','hank.y@example.com','555-6789','LIC-8008',7),
--   (9,'Ivy','Patel','ivy.p@example.com','555-7890','LIC-9009',8),
--   (10,'Jack','Nguyen','jack.n@example.com','555-8901','LIC-1010',9)
-- ON DUPLICATE KEY UPDATE
--   first_name=VALUES(first_name), last_name=VALUES(last_name),
--   email=VALUES(email), phone=VALUES(phone),
--   license_number=VALUES(license_number), sales_office_id=VALUES(sales_office_id);


-- INSERT INTO agent_account (id, agent_id, user_name, password, is_verify, is_online, is_busy)
-- VALUES
--   (1,1,'alicej','$2b$12$abcdef...',TRUE,FALSE,FALSE),
--   (2,2,'bobs','$2b$12$ghijkl...',TRUE,FALSE,FALSE),
--   (3,3,'carolt','$2b$12$mnopqr...',FALSE,FALSE,FALSE),
--   (4,4,'davidl','$2b$12$stuvwx...',TRUE,TRUE,FALSE),
--   (5,5,'evew','$2b$12$yzabcd...',TRUE,FALSE,TRUE),
--   (6,6,'frankn','$2b$12$efghij...',FALSE,FALSE,FALSE),
--   (7,7,'gracek','$2b$12$klmnop...',TRUE,FALSE,FALSE),
--   (8,8,'hanky','$2b$12$qrsuvw...',TRUE,FALSE,FALSE),
--   (9,9,'ivyp','$2b$12$xyzabc...',FALSE,FALSE,FALSE),
--   (10,10,'jackn','$2b$12$cdefgh...',TRUE,TRUE,TRUE)
-- ON DUPLICATE KEY UPDATE
--   agent_id=VALUES(agent_id), user_name=VALUES(user_name),
--   password=VALUES(password), is_verify=VALUES(is_verify),
--   is_online=VALUES(is_online), is_busy=VALUES(is_busy);


INSERT INTO owner (id, first_name, last_name, email, phone, address_id)
VALUES
  (1,'Oscar','Wilde','oscar.w@example.com','555-1010',1),
  (2,'Paul','Revere','paul.r@example.com','555-2020',2),
  (3,'Quincy','Adams','quincy.a@example.com','555-3030',3),
  (4,'Rachel','Green','rachel.g@example.com','555-4040',4),
  (5,'Steve','Jobs','steve.j@example.com','555-5050',5),
  (6,'Tina','Fey','tina.f@example.com','555-6060',6),
  (7,'Uma','Thurman','uma.t@example.com','555-7070',7),
  (8,'Victor','Hugo','victor.h@example.com','555-8080',8),
  (9,'Wendy','Darling','wendy.d@example.com','555-9090',9),
  (10,'Xander','Cage','xander.c@example.com','555-0001',10)
ON DUPLICATE KEY UPDATE
  first_name=VALUES(first_name), last_name=VALUES(last_name),
  email=VALUES(email), phone=VALUES(phone), address_id=VALUES(address_id);

INSERT INTO client (id, first_name, last_name, email, phone, address_id)
VALUES
  (1,  'Jinu',        '',            'jinu@example.com',           '0917-000-0001', 1),
  (2,  'Ahn',         'Hyo-seop',    'ahn.hyoseop@example.com',    '0917-000-0002', 2),
  (3,  'Gwi-Ma',      '',            'gwima@example.com',          '0917-000-0003', 3),
  (4,  'Lee',         'Byung-hun',   'lee.byunghun@example.com',   '0917-000-0004', 4),
  (5,  'Rumi',        '',            'rumi@example.com',           '0917-000-0005', 5),
  (6,  'Arden',       'Cho',         'arden.cho@example.com',      '0917-000-0006', 6),
  (7,  'Zoey',        '',            'zoey@example.com',           '0917-000-0007', 7),
  (8,  'Ji-young',    'Yoo',         'jiyoung.yoo@example.com',    '0917-000-0008', 8),
  (9,  'Baby',        'Saja',        'babysaja@example.com',       '0917-000-0009', 9),
  (10, 'Danny',       'Chung',       'dannychung@example.com',     '0917-000-0010', 10)
ON DUPLICATE KEY UPDATE
  first_name  = VALUES(first_name),
  last_name   = VALUES(last_name),
  email       = VALUES(email),
  phone       = VALUES(phone),
  address_id  = VALUES(address_id);


-- INSERT INTO client (id, first_name, last_name, email, phone, address_id)
-- VALUES
--   (1,'Alice','Smith','alice.s@example.com','555-1111',1),
--   (2,'Bob','Brown','bob.b@example.com','555-2222',2),
--   (3,'Cara','White','cara.w@example.com','555-3333',3),
--   (4,'Derek','Black','derek.b@example.com','555-4444',4),
--   (5,'Ella','Gray','ella.g@example.com','555-5555',5),
--   (6,'Fred','Blue','fred.b@example.com','555-6666',6),
--   (7,'Gina','Yellow','gina.y@example.com','555-7777',7),
--   (8,'Harry','Orange','harry.o@example.com','555-8888',8),
--   (9,'Iris','Purple','iris.p@example.com','555-9999',9),
--   (10,'Jack','Silver','jack.s@example.com','555-0000',10)
-- ON DUPLICATE KEY UPDATE
--   first_name=VALUES(first_name), last_name=VALUES(last_name),
--   email=VALUES(email), phone=VALUES(phone), address_id=VALUES(address_id);


-- INSERT INTO client_account (id, client_id, user_name, password, is_verify, is_online, is_busy)
-- VALUES
--   (1,1,'alices','$2b$12$aaaaaa...',TRUE,FALSE,FALSE),
--   (2,2,'bobb','$2b$12$bbbbbb...',TRUE,FALSE,FALSE),
--   (3,3,'caraw','$2b$12$cccccc...',FALSE,FALSE,FALSE),
--   (4,4,'derekb','$2b$12$dddddd...',TRUE,TRUE,FALSE),
--   (5,5,'ellag','$2b$12$eeeeee...',TRUE,FALSE,TRUE),
--   (6,6,'fredb','$2b$12$ffffff...',FALSE,FALSE,FALSE),
--   (7,7,'ginay','$2b$12$gggggg...',TRUE,FALSE,FALSE),
--   (8,8,'harryo','$2b$12$hhhhhh...',TRUE,FALSE,FALSE),
--   (9,9,'irisp','$2b$12$iiiiii...',FALSE,FALSE,FALSE),
--   (10,10,'jacks','$2b$12$jjjjjj...',TRUE,TRUE,TRUE)
-- ON DUPLICATE KEY UPDATE
--   client_id=VALUES(client_id), user_name=VALUES(user_name),
--   password=VALUES(password), is_verify=VALUES(is_verify),
--   is_online=VALUES(is_online), is_busy=VALUES(is_busy);


INSERT INTO property (id, name, description, address_id, price, status, had_discount, discount_price, listed_date, property_type_id, agent_id, sales_office_id)
VALUES
  (1,'Oakwood Villa','Spacious 4BR villa with pool',1,450000.00,'available',TRUE,425000.00,'2025-01-15',1,1,1),
  (2,'Downtown Loft','Modern 1BR loft near metro',2,250000.00,'available',FALSE,NULL,'2025-02-01',2,2,1),
  (3,'Lakeview Cottage','Cozy 2BR cottage by the lake',3,310000.00,'pending',TRUE,290000.00,'2025-03-10',1,3,2),
  (4,'Sunset Condo','3BR condo with city skyline view',4,380000.00,'available',FALSE,NULL,'2025-04-05',4,4,2),
  (5,'Green Acres','5-acre land parcel',5,150000.00,'available',TRUE,140000.00,'2025-05-20',3, NULL, NULL),
  (6,'Beachfront Home','4BR home on the beach',6,600000.00,'sold',FALSE,NULL,'2025-06-12',1,5,3),
  (7,'Mountain Cabin','Rustic 3BR cabin in woods',7,275000.00,'available',TRUE,260000.00,'2025-07-01',8,6,2),
  (8,'Urban Studio','Compact studio near downtown',8,180000.00,'pending',FALSE,NULL,'2025-07-10',7,7,1),
  (9,'Suburban House','4BR family home in suburb',9,320000.00,'available',TRUE,300000.00,'2025-07-15',6,8,3),
  (10,'Riverside Flat','2BR flat with river view',10,290000.00,'available',FALSE,NULL,'2025-07-20',9,9,2)
ON DUPLICATE KEY UPDATE
  name=VALUES(name), description=VALUES(description),
  address_id=VALUES(address_id), price=VALUES(price),
  status=VALUES(status), had_discount=VALUES(had_discount),
  discount_price=VALUES(discount_price), listed_date=VALUES(listed_date),
  property_type_id=VALUES(property_type_id), agent_id=VALUES(agent_id),
  sales_office_id=VALUES(sales_office_id);


INSERT INTO property_owner (id, owner_id, ownership_role, ownership_percentage, property_id)
VALUES
  (1,1,'primary',100.00,1),(2,2,'co-owner',50.00,2),
  (3,3,'primary',100.00,3),(4,4,'co-owner',30.00,4),
  (5,5,'primary',100.00,5),(6,6,'co-owner',20.00,6),
  (7,7,'primary',100.00,7),(8,8,'co-owner',40.00,8),
  (9,9,'primary',100.00,9),(10,10,'co-owner',25.00,10)
ON DUPLICATE KEY UPDATE
  owner_id=VALUES(owner_id), ownership_role=VALUES(ownership_role),
  ownership_percentage=VALUES(ownership_percentage), property_id=VALUES(property_id);


INSERT INTO client_property_interest (id, client_id, property_id, interest_level)
VALUES
  (1,1,1,'high'),(2,2,2,'medium'),
  (3,3,3,'low'),(4,4,4,'high'),
  (5,5,5,'medium'),(6,6,6,'low'),
  (7,7,7,'high'),(8,8,8,'medium'),
  (9,9,9,'low'),(10,10,10,'high')
ON DUPLICATE KEY UPDATE
  client_id=VALUES(client_id), property_id=VALUES(property_id),
  interest_level=VALUES(interest_level);


INSERT INTO appointment (id, agent_id, client_id, appointment_type, scheduled_at, status, property_id, notes)
VALUES
  (1,1,1,'viewing','2025-08-01 10:00','scheduled',1,'Please ring bell'),
  (2,2,2,'inspection','2025-08-02 14:00','scheduled',2,'Bring helmet'),
  (3,3,3,'viewing','2025-08-03 09:00','completed',3,'Client was late'),
  (4,4,4,'meeting','2025-08-04 16:00','cancelled',4,'Rescheduled'),
  (5,5,5,'viewing','2025-08-05 11:00','scheduled',5,'N/A'),
  (6,6,6,'inspection','2025-08-06 13:00','scheduled',6,'Hard hat'),
  (7,7,7,'viewing','2025-08-07 15:00','completed',7,'Went well'),
  (8,8,8,'meeting','2025-08-08 12:00','scheduled',8,'Lunch provided'),
  (9,9,9,'viewing','2025-08-09 10:30','scheduled',9,'Gate code 1234'),
  (10,10,10,'inspection','2025-08-10 14:30','scheduled',10,'Wear boots')
ON DUPLICATE KEY UPDATE
  agent_id=VALUES(agent_id), client_id=VALUES(client_id),
  appointment_type=VALUES(appointment_type), scheduled_at=VALUES(scheduled_at),
  status=VALUES(status), property_id=VALUES(property_id), notes=VALUES(notes);


INSERT INTO `transaction` (id, agent_id, client_id, transaction_type, property_id, amount, status, notes)
VALUES
  (1,1,1,'sale',1,425000.00,'completed','Down payment'),
  (2,2,2,'rent',2,2500.00,'pending','Monthly rent'),
  (3,3,3,'sale',3,290000.00,'completed','Full payment'),
  (4,4,4,'rent',4,3800.00,'pending','Security deposit'),
  (5,5,5,'sale',5,140000.00,'completed','Mortgage'),
  (6,6,6,'sale',6,600000.00,'completed','Cash'),
  (7,7,7,'rent',7,2750.00,'pending','Lease'),
  (8,8,8,'sale',8,180000.00,'completed','Equity'),
  (9,9,9,'rent',9,3200.00,'pending','Installment'),
  (10,10,10,'sale',10,290000.00,'completed','Wire transfer')
ON DUPLICATE KEY UPDATE
  agent_id=VALUES(agent_id), client_id=VALUES(client_id),
  transaction_type=VALUES(transaction_type), property_id=VALUES(property_id),
  amount=VALUES(amount), status=VALUES(status), notes=VALUES(notes);


INSERT INTO notification (id, agent_id, client_id, message, category, priority, had_read)
VALUES
  (1,1,1,'Appointment tomorrow','appointment',1,FALSE),
  (2,2,2,'Payment received','transaction',2,FALSE),
  (3,3,3,'Price drop','property',3,FALSE),
  (4,4,4,'New message','chat',1,FALSE),
  (5,5,5,'Appointment cancelled','appointment',2,FALSE),
  (6,6,6,'Transaction delayed','transaction',3,FALSE),
  (7,7,7,'New property listed','property',1,FALSE),
  (8,8,8,'System update','system',2,FALSE),
  (9,9,9,'Review request','feedback',3,FALSE),
  (10,10,10,'Promotion','marketing',1,FALSE)
ON DUPLICATE KEY UPDATE
  agent_id=VALUES(agent_id), client_id=VALUES(client_id),
  message=VALUES(message), category=VALUES(category),
  priority=VALUES(priority), had_read=VALUES(had_read);


INSERT INTO notification_transaction (id, notification_id, transaction_id)
VALUES
  (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),
  (6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10)
ON DUPLICATE KEY UPDATE
  notification_id=VALUES(notification_id),
  transaction_id=VALUES(transaction_id);


INSERT INTO notification_appointment (id, notification_id, appointment_id)
VALUES
  (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),
  (6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10)
ON DUPLICATE KEY UPDATE
  notification_id=VALUES(notification_id),
  appointment_id=VALUES(appointment_id);


INSERT INTO image (id, url, is_primary)
VALUES
  (1,'http://localhost:3000/assets/property/1_oak.jpg',TRUE),
  (2,'http://localhost:3000/assets/property/2_loft.jpg',TRUE),
  (3,'http://localhost:3000/assets/property/3_lake.jpg',TRUE),
  (4,'http://localhost:3000/assets/property/4_sunset.jpg',TRUE),
  (5,'http://localhost:3000/assets/property/5_green.jpg',TRUE),
  (6,'http://localhost:3000/assets/property/6_beach.jpg',TRUE),
  (7,'http://localhost:3000/assets/property/7_mtn.jpg',TRUE),
  (8,'http://localhost:3000/assets/property/8_studio.jpg',TRUE),
  (9,'http://localhost:3000/assets/property/9_suburb.jpg',TRUE),
  (10,'http://localhost:3000/assets/property/10_river.jpg',TRUE)
ON DUPLICATE KEY UPDATE
  url=VALUES(url), is_primary=VALUES(is_primary);


INSERT INTO image_property (id, property_id, image_id)
VALUES
  (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),
  (6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10)
ON DUPLICATE KEY UPDATE
  property_id=VALUES(property_id), image_id=VALUES(image_id);


INSERT INTO image_property_owner (id, property_owner_id, image_id)
VALUES
  (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),
  (6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10)
ON DUPLICATE KEY UPDATE
  property_owner_id=VALUES(property_owner_id), image_id=VALUES(image_id);


INSERT INTO image_agent (id, agent_id, image_id)
VALUES
  (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),
  (6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10)
ON DUPLICATE KEY UPDATE agent_id=VALUES(agent_id), image_id=VALUES(image_id);


INSERT INTO image_client (id, client_id, image_id)
VALUES
  (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),
  (6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10)
ON DUPLICATE KEY UPDATE client_id=VALUES(client_id), image_id=VALUES(image_id);


INSERT INTO image_sales_office (id, sales_office_id, image_id)
VALUES
  (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),
  (6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10)
ON DUPLICATE KEY UPDATE sales_office_id=VALUES(sales_office_id), image_id=VALUES(image_id);

COMMIT;
