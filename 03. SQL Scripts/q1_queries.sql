-- Check the raw color values
USE final_clean;

SELECT DISTINCT c.color
FROM adoption_table AS a
JOIN color AS c ON a.color_id = c.color_id
JOIN animal_type AS t ON a.type_id = t.type_id
WHERE t.pet_type = 'Cat'
ORDER BY c.color;

--  Count cats by color
SELECT c.color, COUNT(*) AS total_cats
FROM adoption_table AS a
JOIN color AS c ON a.color_id = c.color_id
JOIN animal_type AS t ON a.type_id = t.type_id
WHERE t.pet_type = 'Cat'
GROUP BY c.color
ORDER BY total_cats DESC;


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

-- Black cats vs other cats
SELECT
    CASE
        WHEN LOWER(c.color) LIKE '%black%' THEN 'Black'
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

