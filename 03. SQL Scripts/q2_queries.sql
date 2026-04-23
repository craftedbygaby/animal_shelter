USE pet_shelter;

# Which animals are being adopted the least?Hypothesis: Less common animal types (birds, livestock, other) will have significantly lower adoption rates than dogs and cats.
# Sub-question: What is the total number and percentage of animals adopted across all types?
# Conclusion: TBD

SELECT * FROM adoption_table;
SELECT * FROM color;
SELECT * FROM outcome;
SELECT * FROM animal_type;



-- ADOPTION TYPEs
SELECT at.pet_type,
       COUNT(*) AS total_records,
       SUM(CASE WHEN o.outcome_type = 'Adoption' THEN 1 ELSE 0 END) AS adopted_count,
       ROUND(
           100.0 * SUM(CASE WHEN o.outcome_type = 'Adoption' THEN 1 ELSE 0 END) / COUNT(*),
           2
       ) AS adoption_rate_pct
FROM adoption_table ad
JOIN animal_type at
  ON ad.type_id = at.type_id
JOIN outcome o
  ON ad.outcome_id = o.outcome_id
GROUP BY at.pet_type
ORDER BY adopted_count ASC;

-- TOTAL ADOPTED ANIMALS AND PERCENTAGE
SELECT COUNT(*) AS total_animals,
       SUM(CASE WHEN o.outcome_type = 'Adoption' THEN 1 ELSE 0 END) AS total_adopted,
       ROUND(
           100.0 * SUM(CASE WHEN o.outcome_type = 'Adoption' THEN 1 ELSE 0 END) / COUNT(*),
           2
       ) AS adoption_percentage
FROM adoption_table ad
JOIN outcome o
  ON ad.outcome_id = o.outcome_id;

-- TOTAL 
SELECT at.pet_type,
       COUNT(*) AS adopted_count
FROM adoption_table ad
JOIN animal_type at
  ON ad.type_id = at.type_id
JOIN outcome o
  ON ad.outcome_id = o.outcome_id
WHERE o.outcome_type = 'Adoption'
GROUP BY at.pet_type
ORDER BY adopted_count ASC;