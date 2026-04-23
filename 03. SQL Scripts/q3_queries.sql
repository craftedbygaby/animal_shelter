USE pet_shelter;

# What is the average age of adoption per animal type?
# Hypothesis: Cats and dogs will be adopted at a younger age on average than other animal types, as younger animals are generally more desirable to adopters.
# Conclusion: TBD

SELECT * FROM outcome;

# checking the average age of adoption
SELECT AVG(DATEDIFF(at.date_outcome, at.date_birth)) / 365 AS avg_age_yo,
	a.pet_type
FROM adoption_table at
INNER JOIN outcome o ON at.outcome_id = o.outcome_id
INNER JOIN animal_type a ON at.type_id = a.type_id
WHERE o.outcome_type = 'Adoption'
GROUP BY a.pet_type;

# checking the average age overall
SELECT AVG(DATEDIFF(at.date_outcome, at.date_birth)) / 365 AS avg_age_yo,
	a.pet_type
FROM adoption_table at
INNER JOIN outcome o ON at.outcome_id = o.outcome_id
INNER JOIN animal_type a ON at.type_id = a.type_id
GROUP BY a.pet_type;

# checking the average age on any outcome, except adoption
SELECT AVG(DATEDIFF(at.date_outcome, at.date_birth)) / 365 AS avg_age_yo,
	a.pet_type
FROM adoption_table at
INNER JOIN outcome o ON at.outcome_id = o.outcome_id
INNER JOIN animal_type a ON at.type_id = a.type_id
WHERE o.outcome_type != 'Adoption'
GROUP BY a.pet_type;
