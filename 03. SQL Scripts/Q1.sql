USE final_clean;
-- 1) Check raw color values for cats
SELECT DISTINCT c.color
FROM adoption_table AS a
JOIN color AS c ON a.color_id = c.color_id
JOIN animal_type AS t ON a.type_id = t.type_id
WHERE t.pet_type = 'Cat'
ORDER BY c.color;



-- Count pure black cats
SELECT c.color, COUNT(*) AS total_cats
FROM adoption_table AS a
JOIN color AS c ON a.color_id = c.color_id
JOIN animal_type AS t ON a.type_id = t.type_id
WHERE t.pet_type = 'Cat'
  AND c.color = 'Black'
GROUP BY c.color
ORDER BY total_cats DESC;

-- Adoption rate for pure black cats
SELECT
    c.color,
    COUNT(*) AS total_cats,
    SUM(CASE WHEN o.outcome_type = 'Adoption' THEN 1 ELSE 0 END) AS adopted_cats,
    ROUND(
        SUM(CASE WHEN o.outcome_type = 'Adoption' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS adoption_rate_pct
FROM adoption_table AS a
JOIN color AS c ON a.color_id = c.color_id
JOIN animal_type AS t ON a.type_id = t.type_id
JOIN outcome AS o ON a.outcome_id = o.outcome_id
WHERE t.pet_type = 'Cat'
  AND c.color = 'Black'
GROUP BY c.color
ORDER BY adoption_rate_pct DESC;

-- Pure black cats vs other cats
SELECT
    CASE
        WHEN c.color = 'Black' THEN 'Black'
        ELSE 'Other'
    END AS color_group,
    COUNT(*) AS total_cats,
    SUM(CASE WHEN o.outcome_type = 'Adoption' THEN 1 ELSE 0 END) AS adopted_cats,
    ROUND(
        SUM(CASE WHEN o.outcome_type = 'Adoption' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS adoption_rate_pct
FROM adoption_table AS a
JOIN color AS c ON a.color_id = c.color_id
JOIN animal_type AS t ON a.type_id = t.type_id
JOIN outcome AS o ON a.outcome_id = o.outcome_id
WHERE t.pet_type = 'Cat'
GROUP BY color_group;


-- adopted black cats divided by all cats.


SELECT
    ROUND(
        SUM(CASE
            WHEN c.color = 'Black' AND o.outcome_type = 'Adoption' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS black_cat_adoption_rate_of_all_cats
FROM adoption_table AS a
JOIN color AS c ON a.color_id = c.color_id
JOIN animal_type AS t ON a.type_id = t.type_id
JOIN outcome AS o ON a.outcome_id = o.outcome_id
WHERE t.pet_type = 'Cat';

-- adoption rate by color
SELECT
    c.color,
    COUNT(*) AS total_cats,
    SUM(CASE WHEN o.outcome_type = 'Adoption' THEN 1 ELSE 0 END) AS adopted_cats,
    ROUND(
        SUM(CASE WHEN o.outcome_type = 'Adoption' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS adoption_rate_pct
FROM adoption_table AS a
JOIN color AS c ON a.color_id = c.color_id
JOIN animal_type AS t ON a.type_id = t.type_id
JOIN outcome AS o ON a.outcome_id = o.outcome_id
WHERE t.pet_type = 'Cat'
GROUP BY c.color
ORDER BY adoption_rate_pct DESC;

-- 

-- find the cat colors with the highest adoption rate.
SELECT
    c.color,
    COUNT(*) AS total_cats,
    SUM(CASE WHEN o.outcome_type = 'Adoption' THEN 1 ELSE 0 END) AS adopted_cats,
    ROUND(
        SUM(CASE WHEN o.outcome_type = 'Adoption' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS adoption_rate_pct
FROM adoption_table AS a
JOIN color AS c ON a.color_id = c.color_id
JOIN animal_type AS t ON a.type_id = t.type_id
JOIN outcome AS o ON a.outcome_id = o.outcome_id
WHERE t.pet_type = 'Cat'
GROUP BY c.color
ORDER BY adoption_rate_pct DESC;