USE pet_shelter;

SELECT * FROM raw_data
LIMIT 5;

# DELETE TABLE IF EXISTS animal_type;

# pop of animal_type table
INSERT INTO animal_type (pet_type)
SELECT DISTINCT 
	animal_type
FROM raw_data;

# checking is pop was done
SELECT * FROM animal_type;

# pop of outcome table
INSERT INTO outcome (outcome_type)
SELECT DISTINCT 
	outcome_type
FROM raw_data;

# checking is pop was done
SELECT * FROM outcome;

# pop of breed table
INSERT INTO breed (breed_name)
SELECT DISTINCT 
	breed
FROM raw_data;

# checking is pop was done
SELECT * FROM breed;

# pop of color table
INSERT INTO color (color)
SELECT DISTINCT 
	color
FROM raw_data;

# checking is pop was done
SELECT * FROM color;

SELECT * FROM raw_data
LIMIT 5;

# pop of adoption_table
INSERT INTO adoption_table (animal_id, outcome_id, type_id, age_outcome, breed_id, color_id, date_outcome, date_birth)
SELECT
    r.animal_id,
    o.outcome_id,
    at.type_id,
    r.age_upon_outcome,
    b.breed_id,
    c.color_id,
    STR_TO_DATE(LEFT(r.datetime, 10), '%Y-%m-%d'),
    STR_TO_DATE(r.date_of_birth, '%Y-%m-%d')
FROM raw_data r
JOIN outcome o ON r.outcome_type = o.outcome_type
JOIN animal_type at ON r.animal_type = at.pet_type
JOIN breed b ON r.breed = b.breed_name
JOIN color c ON r.color = c.color;

# checking if pop was done
SELECT * FROM adoption_table;