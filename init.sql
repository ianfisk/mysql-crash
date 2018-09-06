CREATE DATABASE pets;
USE pets;

CREATE TABLE owners (
    owner_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(10) NOT NULL,
    PRIMARY KEY (owner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin;

CREATE TABLE pets (
    pet_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(10) NOT NULL,
    owner_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (pet_id),
    FOREIGN KEY (owner_id) REFERENCES owners(owner_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin;

CREATE TABLE vaccinations (
    vaccination_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    vaccine_name VARCHAR(10) NOT NULL,
    vaccination_date DATE NOT NULL,
    pet_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (vaccination_id),
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin;

/* Insert some data (this isn't necessary to reproduce the crash, but it's fun) */
INSERT INTO owners (name) VALUES ('Ian');
INSERT INTO pets (name, owner_id) VALUES ('Remy', LAST_INSERT_ID());
INSERT INTO vaccinations (vaccine_name, vaccination_date, pet_id) SELECT 'rabies', CURDATE(), pet_id FROM pets WHERE name = 'Remy';

INSERT INTO pets (name, owner_id) SELECT 'Bozo', owner_id FROM owners WHERE name = 'Ian';
INSERT INTO vaccinations (vaccine_name, vaccination_date, pet_id) SELECT 'rabies', CURDATE(), pet_id FROM pets WHERE name = 'Bozo';
INSERT INTO vaccinations (vaccine_name, vaccination_date, pet_id) SELECT 'leukemia', CURDATE(), pet_id FROM pets WHERE name = 'Bozo';

INSERT INTO owners (name) VALUES ('Cameron');
INSERT INTO pets (name, owner_id) VALUES ('Mojo', LAST_INSERT_ID());
INSERT INTO vaccinations (vaccine_name, vaccination_date, pet_id) SELECT 'rabies', CURDATE(), pet_id FROM pets WHERE name = 'Mojo';
INSERT INTO vaccinations (vaccine_name, vaccination_date, pet_id) SELECT 'leukemia', CURDATE(), pet_id FROM pets WHERE name = 'Mojo';

/* See all the data */
SELECT * FROM owners INNER JOIN pets on pets.owner_id = owners.owner_id INNER JOIN vaccinations on vaccinations.pet_id = pets.pet_id;
