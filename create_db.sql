-- Create database for project
CREATE DATABASE `hawmps_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

-- Create users table
CREATE TABLE hawmps_db.users (
	id BIGINT UNSIGNED auto_increment NOT NULL,
	username varchar(100) NOT NULL,
	pass_hash varchar(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user` (`username`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci;


-- Create crew table
CREATE TABLE `hawmps_db`.`crew` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `full_name` varchar(100) GENERATED ALWAYS AS (concat(`first_name`,_utf8mb4' ',`last_name`)) VIRTUAL,
  `gender` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `crew_last_name_IDX` (`last_name`,`first_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create roles table
CREATE TABLE `hawmps_db`.`roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create crew_roles table
CREATE TABLE `hawmps_db`.`crew_roles` (
  `crew_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `role_data` json DEFAULT NULL,
  PRIMARY KEY (`crew_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Add roles data
INSERT INTO `hawmps_db`.`roles` (role_name)
VALUES
	('Director'),
	('Writer'),
	('Cast'),
	('Producer'),
	('Music'),
	('Cinematographer'),
	('Film Editor'),
	('Production Designer'),
	('Art Director'),
	('Costume Designer'),
	('Production Manager'),
	('Assistant Director'),
	('Art Department'),
	('Sound Department'),
	('Special Effects'),
	('Stunts'),
	('Camera and Electrical'),
	('Casting'),
	('Additional Crew');

    -- Add crew data
    INSERT INTO `hawmps_db`.`crew` (first_name,last_name,gender)
    VALUES
        ('Joe','Camp','Male'),
        ('William','Bickley','Male'),
        ('Michael','Warren','Male'),
        ('James','Hampton','Male'),
        ('Christopher','Connelly','Male'),
        ('Slim','Pickens','Male'),
        ('Denver','Pyle','Male'),
        ('Gino','Conforti','Male'),
        ('Mimi','Maynard','Female'),
        ('Lee','de Broux','Male'),
        ('Herb','Vigran','Male'),
        ('Jesse','Davis','Male'),
        ('Frank','Inn','Male'),
        ('Larry','Swartz','Male'),
        ('Mike','Travis','Male'),
        ('Tiny','Wells','Male'),
        ('Dick','Drake','Male'),
        ('Henry','Kendrick','Male'),
        ('Don','Starr','Male'),
        ('Cynthia','Smith','Female'),
        ('Roy','Gunsberg','Male'),
        ('Rex','Janssen','Male'),
        ('Catherine','Hearne','Female'),
        ('Larry','Strawbridge','Male'),
        ('James','Weir','Male'),
        ('Alvin','Wright','Male'),
        ('Lee','Tiplitsky','Male'),
        ('Perry','Martin','Male'),
        ('Valentine',null,'Female'),
        ('Richard','Lundin','Male'),
        ('Charles','Starkey','Male'),
        ('Benjoe',null,'Male'),
        ('Jack','Elam','Male'),
        ('Tiffany',null,'Female'),
        ('Steven','Brown','Male'),
        ('Glenn','Amon','Male'),
        ('H.T.','Ardinger','Male'),
        ('Erwine','Hearne','Male'),
        ('Ben','Vaughn','Male'),
        ('Euel','Box','Male'),
        ('Don','Reddy','Male'),
        ('Leon','Seith','Male'),
        ('Harland','Wright','Male'),
        ('Ned','Parsons','Male'),
        ('Tom','Bronson','Male'),
        ('Terence','Donnelly','Male'),
        ('A.Z.','Smith','Male'),
        ('Jonathan','Sanger','Male'),
        ('David','Coleman','Male'),
        ('Allan','Gordon','Male'),
        ('Wayne','Kerner','Male'),
        ('Bruce','Shearin','Male'),
        ('Jack','Bennett','Male'),
        ('George','Fisher','Male'),
        ('Neil','Summers','Male'),
        ('Denny','Arnold','Male'),
        ('John','Hudkins','Male'),
        ('John','Reynolds','Male'),
        ('Philip','Sloan','Male'),
        ('Jack','Young','Male'),
        ('Jane','Badgers','Female');

    -- Add crew_roles data
    INSERT INTO `hawmps_db`.`crew_roles` (crew_id,role_id,role_data)
    VALUES
        (1,1,null),
        (2,2,null),
        (1,2,null),
        (3,2,null),
        (4,3,'{"CharacterName": "Howard Clemmons"}'),
        (5,3,'{"CharacterName": "Uriah Tibbs"}'),
        (6,3,'{"CharacterName": "Sergeant Naman Tucker"}'),
        (7,3,'{"CharacterName": "Col. Seymour Hawkins"}'),
        (8,3,'{"CharacterName": "Hi Jolly","Aka": "Gene Conforti"}'),
        (9,3,'{"CharacterName": "Jennifer Hawkins"}'),
        (10,3,'{"CharacterName": "Fitzgerald"}'),
        (11,3,'{"CharacterName": "Smitty"}'),
        (12,3,'{"CharacterName": "Mariachi Singer"}'),
        (13,3,'{"CharacterName": "Cook"}'),
        (14,3,'{"CharacterName": "Cpl. LeRoy"}'),
        (15,3,'{"CharacterName": "Logan"}'),
        (16,3,'{"CharacterName": "Higgins"}'),
        (17,3,'{"CharacterName": "Drake"}'),
        (18,3,'{"CharacterName": "Col. Zachary"}'),
        (19,3,'{"CharacterName": "Major Maney"}'),
        (20,3,'{"CharacterName": "Granddaughter"}'),
        (21,3,'{"CharacterName": "Old Man"}'),
        (22,3,'{"CharacterName": "Grandson"}'),
        (23,3,'{"CharacterName": "Zelda"}'),
        (24,3,'{"CharacterName": "Mayor","Aka": "Lawrence W. Strawbridge"}'),
        (25,3,'{"CharacterName": "Private"}'),
        (26,3,'{"CharacterName": "Crazy Feathers"}'),
        (27,3,'{"CharacterName": "Drunk"}'),
        (28,3,'{"CharacterName": "Frontiersman"}'),
        (29,3,'{"CharacterName": "She-baby Camel"}'),
        (30,3,'{"CharacterName": "Stage Driver"}'),
        (31,3,'{"CharacterName": "Man"}'),
        (32,3,'{"CharacterName": "Benji"}'),
        (33,3,'{"CharacterName": "Bad Jack Cutter"}'),
        (34,3,'{"CharacterName": "White dog"}'),
        (35,3,'{"CharacterName": "Bad Guy 1","Credited": false}'),
        (1,3,'{"CharacterName": "Telegraph Boy", "Aka": "Joey Camp"}'),
        (36,4,'{"RoleInfo": "associate producer"}'),
        (37,4,'{"RoleInfo": "associate producer"}'),
        (38,4,'{"RoleInfo": "associate producer","Credited": false}'),
        (39,4,'{"RoleInfo": "co-producer"}'),
        (1,4,'{"RoleInfo": "producer"}'),
        (40,5,null),
        (41,6,null),
        (42,7,null),
        (43,8,'{"Aka": "Harlan Wright"}'),
        (44,9,null),
        (45,10,null),
        (46,11,'{"RoleInfo": "unit production manager"}'),
        (47,11,'{"RoleInfo": "production manager"}'),
        (48,12,'{"RoleInfo": "second assistant director","Aka": "Jon Sanger"}'),
        (46,12,'{"RoleInfo": "first assistant director"}'),
        (49,13,'{"RoleInfo": "property master"}'),
        (50,13,'{"RoleInfo": "property master"}'),
        (51,13,'{"RoleInfo": "painter"}'),
        (52,14,'{"RoleInfo": "sound"}'),
        (53,15,'{"RoleInfo": "special effects"}'),
        (54,16,'{"RoleInfo": "stunts"}'),
        (55,16,'{"RoleInfo": "stunts"}'),
        (56,16,'{"RoleInfo": "stunts","Credited": false}'),
        (57,16,'{"RoleInfo": "stunts","Credited": false}'),
        (58,17,'{"RoleInfo": "lighting technician"}'),
        (59,17,'{"RoleInfo": "dolly grip"}'),
        (60,18,'{"RoleInfo": "extras casting","Credited": false}'),
        (61,19,'{"RoleInfo": "press"}');
