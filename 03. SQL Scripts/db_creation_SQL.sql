USE pet_shelter;

DROP TABLE IF EXISTS `adoption_table`;
DROP TABLE IF EXISTS `animal_type`;
DROP TABLE IF EXISTS `color`;
DROP TABLE IF EXISTS `breed`;
DROP TABLE IF EXISTS `outcome`;

CREATE TABLE IF NOT EXISTS `animal_type` (
	`type_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`pet_type` VARCHAR(255),
	PRIMARY KEY(`type_id`)
);

CREATE TABLE IF NOT EXISTS `color` (
	`color_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`color` VARCHAR(255),
	PRIMARY KEY(`color_id`)
);

CREATE TABLE IF NOT EXISTS `breed` (
	`breed_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`breed_name` VARCHAR(255),
	PRIMARY KEY(`breed_id`)
);

CREATE TABLE IF NOT EXISTS `outcome` (
	`outcome_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`outcome_type` VARCHAR(255),
	PRIMARY KEY(`outcome_id`)
);

CREATE TABLE IF NOT EXISTS `adoption_table` (
	`transaction_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT, ###
	`animal_id` VARCHAR(10) NOT NULL,
	`outcome_id` INTEGER UNSIGNED NOT NULL,
	`type_id` INTEGER UNSIGNED NOT NULL,
	`age_outcome` VARCHAR(255),
	`breed_id` INTEGER UNSIGNED NOT NULL,
	`color_id` INTEGER UNSIGNED NOT NULL,
	`date_outcome` DATE,
	`date_birth` DATE,
	PRIMARY KEY(`transaction_id`),
	FOREIGN KEY(`outcome_id`) REFERENCES `outcome`(`outcome_id`),
	FOREIGN KEY(`type_id`) REFERENCES `animal_type`(`type_id`),
	FOREIGN KEY(`breed_id`) REFERENCES `breed`(`breed_id`),
	FOREIGN KEY(`color_id`) REFERENCES `color`(`color_id`)
);
