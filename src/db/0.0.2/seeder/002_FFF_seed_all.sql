SET FOREIGN_KEY_CHECKS = 0;
START TRANSACTION;

INSERT INTO lookup_property_type (id, name) VALUES
 (1,'Apartment'),
 (2,'Condo'),
 (3,'Townhouse'),
 (4,'Villa'),
 (5,'Studio'),
 (6,'Loft'),
 (7,'Duplex'),
 (8,'Penthouse'),
 (9,'Cottage'),
 (10,'Bungalow')
ON DUPLICATE KEY UPDATE name=VALUES(name);


INSERT INTO lookup_appointment_type (id, name) VALUES
 (1,'Initial Viewing'),
 (2,'Follow‑up Tour'),
 (3,'Virtual Tour'),
 (4,'Open House'),
 (5,'Inspection'),
 (6,'Appraisal'),
 (7,'Final Walkthrough'),
 (8,'Contract Signing'),
 (9,'Financing Discussion'),
 (10,'Closing Meeting')
ON DUPLICATE KEY UPDATE name=VALUES(name);

INSERT INTO lookup_notification_type (id, name) VALUES
 (1,'Email'),
 (2,'SMS'),
 (3,'Push'),
 (4,'In‑App'),
 (5,'Reminder'),
 (6,'Alert'),
 (7,'Newsletter'),
 (8,'Promotion'),
 (9,'Warning'),
 (10,'System')
ON DUPLICATE KEY UPDATE name=VALUES(name);

INSERT INTO actor_role (id, name) VALUES
 (1,'agent'),
 (2,'client'),
 (3,'owner'),
 (4,'renter'),
 (5,'inspector'),
 (6,'appraiser'),
 (7,'lender'),
 (8,'buyer'),
 (9,'seller'),
 (10,'manager')
ON DUPLICATE KEY UPDATE name=VALUES(name);

INSERT INTO property_ownership_role (id, name) VALUES
 (1,'Owner'),
 (2,'Co‑Owner'),
 (3,'Tenant'),
 (4,'Landlord'),
 (5,'Developer'),
 (6,'Investor'),
 (7,'Beneficiary'),
 (8,'Trustee'),
 (9,'Mortgagee'),
 (10,'Lessor')
ON DUPLICATE KEY UPDATE name=VALUES(name);

INSERT INTO lookup_status (id, name) VALUES
 (1,'Available'),
 (2,'Pending'),
 (3,'Under Contract'),
 (4,'Sold'),
 (5,'Off Market'),
 (6,'Rented'),
 (7,'Maintenance'),
 (8,'Upcoming'),
 (9,'Archived'),
 (10,'Draft')
ON DUPLICATE KEY UPDATE name=VALUES(name);

INSERT INTO lookup_document_type (id, name) VALUES
 (1,'Deed'),
 (2,'Title'),
 (3,'Contract'),
 (4,'Blueprint'),
 (5,'Survey'),
 (6,'Inspection Report'),
 (7,'Appraisal'),
 (8,'Insurance'),
 (9,'Tax Record'),
 (10,'Lease Agreement')
ON DUPLICATE KEY UPDATE name=VALUES(name);

INSERT INTO country (id, name, code, currency_symbol) VALUES
 (1,'United States','USA','$'),
 (2,'Philippines','PHL','₱'),
 (3,'Canada','CAN','C$'),
 (4,'United Kingdom','GBR','£'),
 (5,'Australia','AUS','A$'),
 (6,'Japan','JPN','¥'),
 (7,'South Korea','KOR','₩'),
 (8,'Germany','DEU','€'),
 (9,'France','FRA','€'),
 (10,'Brazil','BRA','R$')
ON DUPLICATE KEY UPDATE
 name=VALUES(name),
 code=VALUES(code),
 currency_symbol=VALUES(currency_symbol);

INSERT INTO address (id, unit_number, street, city, country_id, zip_code) VALUES
 (1,'Apt 101','123 Elm St','Los Angeles',1,'90001'),
 (2,NULL,'456 Mabini St','Manila',2,'1004'),
 (3,'Unit 5','789 Maple Ave','Toronto',3,'M4B1B3'),
 (4,NULL,'10 Downing St','London',4,'SW1A2AA'),
 (5,'Suite 300','1 Martin Pl','Sydney',5,'2000'),
 (6,NULL,'2‑1‑1 Otemachi','Tokyo',6,'100‑0004'),
 (7,'5F','123 Gangnam‑daero','Seoul',7,'06181'),
 (8,NULL,'Unter den Linden','Berlin',8,'10117'),
 (9,NULL,'Champs‑Élysées','Paris',9,'75008'),
 (10,NULL,'Avenida Paulista','São Paulo',10,'01310‑100')
ON DUPLICATE KEY UPDATE
 unit_number=VALUES(unit_number),
 street=VALUES(street),
 city=VALUES(city),
 country_id=VALUES(country_id),
 zip_code=VALUES(zip_code);

INSERT INTO map_coordinate (id, latitude, longitude, address_id) VALUES
 (1,34.052235,-118.243683,1),
 (2,14.599512,120.984222,2),
 (3,43.653908,-79.384293,3),
 (4,51.503364,-0.127625,4),
 (5,-33.868820,151.209290,5),
 (6,35.689487,139.691711,6),
 (7,37.497942,127.027621,7),
 (8,52.517036,13.388860,8),
 (9,48.856613,2.352222,9),
 (10,-23.561414,-46.655881,10)
ON DUPLICATE KEY UPDATE
 latitude=VALUES(latitude),
 longitude=VALUES(longitude),
 address_id=VALUES(address_id);

INSERT INTO actor_profile
 (id, actor_role_id, first_name, middle_name, last_name, suffix, email, phone, description, address_id)
VALUES
 (1,1,'Tony',NULL,'Stark',NULL,'tony.stark@starkindustries.com','555-IRON2','Genius inventor turned hero',1),
 (2,1,'Steve',NULL,'Rogers','Sr.','steve.rogers@avengers.com','555-CAP1','Super soldier',2),
 (3,1,'Natasha',NULL,'Romanoff',NULL,'natasha.romanoff@shield.gov','555-BLCK','Expert spy',3),
 (4,1,'Bruce',NULL,'Wayne',NULL,'bruce.wayne@wayneenterprises.com','555-BATS','Billionaire vigilante',4),
 (5,1,'Diana',NULL,'Prince',NULL,'diana.prince@themiscira.org','555-WOND','Amazonian warrior',5),
 (6,2,'Jin','Seo','Yoon',NULL,'jin.yoon@kpopdemon.com','0917-000001','Lead Demon Hunter',6),
 (7,2,'Min','Ji','Park',NULL,'min.park@kpopdemon.com','0917-000002','Support Demon Hunter',7),
 (8,2,'Ha','Neul','Kim','Jr.','haneul.kim@kpopdemon.com','0917-000003','Mystic archer',8),
 (9,2,'Hyun','Woo','Lee',NULL,'hyun.lee@kpopdemon.com','0917-000004','Tech specialist',9),
 (10,2,'Ara',NULL,'Choi',NULL,'ara.choi@kpopdemon.com','0917-000005','Healer',10)
ON DUPLICATE KEY UPDATE
 actor_role_id=VALUES(actor_role_id),
 first_name=VALUES(first_name),
 middle_name=VALUES(middle_name),
 last_name=VALUES(last_name),
 suffix=VALUES(suffix),
 email=VALUES(email),
 phone=VALUES(phone),
 description=VALUES(description),
 address_id=VALUES(address_id);

--
-- REM: user_account seeder is found at the seed_user_account.ts
--

INSERT INTO actor_client (actor_profile_id) VALUES
 (3),(5),(6),(7),(8),(9),(10),(2),(4),(1)
ON DUPLICATE KEY UPDATE actor_profile_id=VALUES(actor_profile_id);

INSERT INTO user_client (id, user_id, actor_client_id) VALUES
 (1,3,3),
 (2,5,5),
 (3,6,6),
 (4,7,7),
 (5,8,8),
 (6,9,9),
 (7,10,10),
 (8,2,2),
 (9,4,4),
 (10,1,1)
ON DUPLICATE KEY UPDATE
 user_id=VALUES(user_id),
 actor_client_id=VALUES(actor_client_id);

INSERT INTO actor_sales_office (id, name, actor_profile_id) VALUES
 (1,'Stark Tower Realty',1),
 (2,'Avengers HQ Realty',2),
 (3,'Shield Estate Co.',3),
 (4,'Wayne Manor Realty',4),
 (5,'Themyscira Realty',5),
 (6,'KPop Demon HQ',6),
 (7,'Demon Hunter Ops',7),
 (8,'Mystic Archers Realty',8),
 (9,'Tech Support Realty',9),
 (10,'Healing Hands Realty',10)
ON DUPLICATE KEY UPDATE
 name=VALUES(name),
 actor_profile_id=VALUES(actor_profile_id);

INSERT INTO actor_agent
 (actor_profile_id, actor_sales_office_id, license_number, performance_rating)
VALUES
 (1,1,'LIC-1001',4.85),
 (2,2,'LIC-1002',4.90),
 (3,3,'LIC-1003',4.75),
 (4,4,'LIC-1004',4.80),
 (5,5,'LIC-1005',4.95),
 (6,6,'LIC-2001',4.70),
 (7,7,'LIC-2002',4.65),
 (8,8,'LIC-2003',4.60),
 (9,9,'LIC-2004',4.55),
 (10,10,'LIC-2005',4.50)
ON DUPLICATE KEY UPDATE
 actor_sales_office_id=VALUES(actor_sales_office_id),
 license_number=VALUES(license_number),
 performance_rating=VALUES(performance_rating);

INSERT INTO user_agent (id, user_id, actor_agent_id) VALUES
 (1,1,1),
 (2,2,2),
 (3,3,3),
 (4,4,4),
 (5,5,5),
 (6,6,6),
 (7,7,7),
 (8,8,8),
 (9,9,9),
 (10,10,10)
ON DUPLICATE KEY UPDATE
 user_id=VALUES(user_id),
 actor_agent_id=VALUES(actor_agent_id);

INSERT INTO actor_property_owner
 (actor_profile_id, property_ownership_role_id, ownership_percentage)
VALUES
 (1,1,100.00),
 (2,2,50.00),
 (3,3,10.00),
 (4,4,100.00),
 (5,5,75.00),
 (6,6,30.00),
 (7,7,20.00),
 (8,8,40.00),
 (9,9,60.00),
 (10,10,25.00)
ON DUPLICATE KEY UPDATE
 property_ownership_role_id=VALUES(property_ownership_role_id),
 ownership_percentage=VALUES(ownership_percentage);

INSERT INTO user_property_owner (id, user_id, actor_property_owner_id) VALUES
 (1,1,1),
 (2,2,2),
 (3,3,3),
 (4,4,4),
 (5,5,5),
 (6,6,6),
 (7,7,7),
 (8,8,8),
 (9,9,9),
 (10,10,10)
ON DUPLICATE KEY UPDATE
 user_id=VALUES(user_id),
 actor_property_owner_id=VALUES(actor_property_owner_id);

INSERT INTO actor_property_interest (id, actor_profile_id, property_id, interest_level) VALUES
 (1,3,1,'high'),
 (2,5,2,'medium'),
 (3,6,3,'high'),
 (4,7,4,'low'),
 (5,8,5,'medium'),
 (6,9,6,'high'),
 (7,10,7,'low'),
 (8,2,8,'high'),
 (9,4,9,'medium'),
 (10,1,10,'high')
ON DUPLICATE KEY UPDATE
 actor_profile_id=VALUES(actor_profile_id),
 property_id=VALUES(property_id),
 interest_level=VALUES(interest_level);

INSERT INTO property
 (id,name,description,address_id,property_type_id,size,price,status_id,had_discount,discount_price,
  actor_property_owner_id,actor_sales_office_id,actor_agent_id)
VALUES
 (1,'Stark Penthouse','Lux penthouse in LA',1,8,3500.00,2500000.00,1,TRUE,2400000.00,1,1,1),
 (2,'Mabini Condo','City condo in Manila',2,2,1200.00,300000.00,1,FALSE,NULL,2,2,2),
 (3,'Toronto Townhouse','Family townhouse',3,3,1800.00,650000.00,2,FALSE,NULL,3,3,3),
 (4,'Wayne Villa','Estate near Gotham',4,4,5000.00,5000000.00,3,TRUE,4800000.00,4,4,4),
 (5,'Paradise Island Cottage','Beachfront cottage',5,9,900.00,750000.00,1,FALSE,NULL,5,5,5),
 (6,'Seoul Loft','Modern loft',7,6,800.00,200000.00,1,TRUE,190000.00,7,7,7),
 (7,'Demon HQ Studio','Underground studio',6,5,600.00,150000.00,4,FALSE,NULL,6,6,6),
 (8,'Gotham Duplex','Spacious duplex',9,7,2200.00,850000.00,1,FALSE,NULL,9,9,9),
 (9,'Metropolis Bungalow','Classic bungalow',10,10,1300.00,450000.00,2,TRUE,430000.00,10,10,10),
 (10,'Central Park Apartment','City center apt',8,1,950.00,1200000.00,1,FALSE,NULL,2,8,2)
ON DUPLICATE KEY UPDATE
 name=VALUES(name),
 description=VALUES(description),
 address_id=VALUES(address_id),
 property_type_id=VALUES(property_type_id),
 size=VALUES(size),
 price=VALUES(price),
 status_id=VALUES(status_id),
 had_discount=VALUES(had_discount),
 discount_price=VALUES(discount_price),
 actor_property_owner_id=VALUES(actor_property_owner_id),
 actor_sales_office_id=VALUES(actor_sales_office_id),
 actor_agent_id=VALUES(actor_agent_id);

INSERT INTO property_document
 (id, property_id, document_name, lookup_type_id, document_size, is_active, document_url)
VALUES
 (1,1,'Stark Deed.pdf',1,204800,TRUE,'/docs/stark_deed.pdf'),
 (2,2,'Mabini Title.pdf',2,102400,TRUE,'/docs/mabini_title.pdf'),
 (3,3,'Toronto Contract.pdf',3,512000,TRUE,'/docs/toronto_contract.pdf'),
 (4,4,'Wayne Blueprint.pdf',4,256000,TRUE,'/docs/wayne_blueprint.pdf'),
 (5,5,'Paradise Survey.pdf',5,128000,TRUE,'/docs/paradise_survey.pdf'),
 (6,6,'Seoul Inspection.pdf',6,300000,TRUE,'/docs/seoul_inspection.pdf'),
 (7,7,'HQ Appraisal.pdf',7,180000,TRUE,'/docs/hq_appraisal.pdf'),
 (8,8,'Gotham Insurance.pdf',8,220000,TRUE,'/docs/gotham_insurance.pdf'),
 (9,9,'Metro TaxRecord.pdf',9,150000,TRUE,'/docs/metro_tax.pdf'),
 (10,10,'CentralPark Lease.pdf',10,175000,TRUE,'/docs/centralpark_lease.pdf')
ON DUPLICATE KEY UPDATE
 property_id=VALUES(property_id),
 document_name=VALUES(document_name),
 lookup_type_id=VALUES(lookup_type_id),
 document_size=VALUES(document_size),
 is_active=VALUES(is_active),
 document_url=VALUES(document_url);

INSERT INTO image (id, url, alt_text, is_active, format) VALUES
 (1,'/asset/img/stark1.jpg','Stark Penthouse',TRUE,'jpg'),
 (2,'/asset/img/mabini1.jpg','Mabini Condo',TRUE,'jpg'),
 (3,'/asset/img/toronto1.jpg','Toronto Townhouse',TRUE,'jpg'),
 (4,'/asset/img/wayne1.jpg','Wayne Villa',TRUE,'jpg'),
 (5,'/asset/img/paradise1.jpg','Paradise Cottage',TRUE,'jpg'),
 (6,'/asset/img/seoul1.jpg','Seoul Loft',TRUE,'jpg'),
 (7,'/asset/img/hq1.jpg','Demon HQ Studio',TRUE,'jpg'),
 (8,'/asset/img/gotham1.jpg','Gotham Duplex',TRUE,'jpg'),
 (9,'/asset/img/metro1.jpg','Metro Bungalow',TRUE,'jpg'),
 (10,'/asset/img/central1.jpg','Central Park Apt',TRUE,'jpg')
ON DUPLICATE KEY UPDATE
 url=VALUES(url),
 alt_text=VALUES(alt_text),
 is_active=VALUES(is_active),
 format=VALUES(format);

INSERT INTO image_actor_profile (id, image_id, actor_profile_id, is_primary) VALUES
 (1,1,1,TRUE),
 (2,2,2,TRUE),
 (3,3,3,TRUE),
 (4,4,4,TRUE),
 (5,5,5,TRUE),
 (6,6,6,TRUE),
 (7,7,7,TRUE),
 (8,8,8,TRUE),
 (9,9,9,TRUE),
 (10,10,10,TRUE)
ON DUPLICATE KEY UPDATE
 image_id=VALUES(image_id),
 actor_profile_id=VALUES(actor_profile_id),
 is_primary=VALUES(is_primary);

INSERT INTO image_property (id, image_id, property_id, is_primary) VALUES
 (1,1,1,TRUE),
 (2,2,2,TRUE),
 (3,3,3,TRUE),
 (4,4,4,TRUE),
 (5,5,5,TRUE),
 (6,6,6,TRUE),
 (7,7,7,TRUE),
 (8,8,8,TRUE),
 (9,9,9,TRUE),
 (10,10,10,TRUE)
ON DUPLICATE KEY UPDATE
 image_id=VALUES(image_id),
 property_id=VALUES(property_id),
 is_primary=VALUES(is_primary);

INSERT INTO user_appointment
 (id,user_client_id,user_agent_id,property_id,lookup_type_id,scheduled_at,status_id,notes)
VALUES
 (1,1,1,1,1,'2025-08-01 10:00:00',1,'First visit'),
 (2,2,2,2,2,'2025-08-02 11:00:00',1,'Follow up'),
 (3,3,3,3,3,'2025-08-03 12:00:00',2,'Virtual tour'),
 (4,4,4,4,4,'2025-08-04 13:00:00',2,'Open house'),
 (5,5,5,5,5,'2025-08-05 14:00:00',3,'Inspection'),
 (6,6,6,6,6,'2025-08-06 15:00:00',3,'Appraisal'),
 (7,7,7,7,7,'2025-08-07 16:00:00',4,'Walkthrough'),
 (8,8,8,8,8,'2025-08-08 17:00:00',4,'Signing'),
 (9,9,9,9,9,'2025-08-09 18:00:00',5,'Financing'),
 (10,10,10,10,10,'2025-08-10 19:00:00',5,'Closing')
ON DUPLICATE KEY UPDATE
 user_client_id=VALUES(user_client_id),
 user_agent_id=VALUES(user_agent_id),
 property_id=VALUES(property_id),
 lookup_type_id=VALUES(lookup_type_id),
 scheduled_at=VALUES(scheduled_at),
 status_id=VALUES(status_id),
 notes=VALUES(notes);

INSERT INTO user_notification
 (id,user_id,lookup_notification_type_id,content,is_read)
VALUES
 (1,1,1,'Your appointment is confirmed',FALSE),
 (2,2,2,'New property matches your search',FALSE),
 (3,3,3,'Price drop alert',FALSE),
 (4,4,4,'Monthly newsletter',FALSE),
 (5,5,5,'Reminder: inspection tomorrow',FALSE),
 (6,6,6,'System maintenance notice',FALSE),
 (7,7,7,'Promotion: reduced fees',FALSE),
 (8,8,8,'Warning: document expired',FALSE),
 (9,9,9,'Alert: contract signed',FALSE),
 (10,10,10,'Your review has new reply',FALSE)
ON DUPLICATE KEY UPDATE
 lookup_notification_type_id=VALUES(lookup_notification_type_id),
 content=VALUES(content),
 is_read=VALUES(is_read);

INSERT INTO user_rating (id, reviewer_id, object_type, object_id, score) VALUES
 (1,1,'actor',2,5),
 (2,2,'actor',3,4),
 (3,3,'actor',1,5),
 (4,4,'property',1,4),
 (5,5,'property',2,5),
 (6,6,'property',3,3),
 (7,7,'actor',4,4),
 (8,8,'actor',5,5),
 (9,9,'property',4,2),
 (10,10,'property',5,5)
ON DUPLICATE KEY UPDATE
 reviewer_id=VALUES(reviewer_id),
 object_type=VALUES(object_type),
 object_id=VALUES(object_id),
 score=VALUES(score);

INSERT INTO user_comment (id, commenter_id, object_type, object_id, text) VALUES
 (1,1,'actor',2,'Great communication!'),
 (2,2,'actor',3,'Very professional.'),
 (3,3,'actor',1,'Highly recommended.'),
 (4,4,'property',1,'Beautiful place.'),
 (5,5,'property',2,'Amazing view!'),
 (6,6,'property',3,'Good value.'),
 (7,7,'actor',4,'Loved working together.'),
 (8,8,'actor',5,'Fantastic service.'),
 (9,9,'property',4,'Needs minor repairs.'),
 (10,10,'property',5,'Perfect location.')
ON DUPLICATE KEY UPDATE
 commenter_id=VALUES(commenter_id),
 object_type=VALUES(object_type),
 object_id=VALUES(object_id),
 text=VALUES(text);

COMMIT;
SET FOREIGN_KEY_CHECKS = 1;