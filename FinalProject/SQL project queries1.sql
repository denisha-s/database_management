SET search_path = dsaviela;
--create tables and copy over from data set

--DEPRESSION DATASET
DROP TABLE IF EXISTS depression_rates;

CREATE TABLE depression_rates (
    category TEXT PRIMARY KEY,
    type TEXT,
    percent NUMERIC(3,1)
);

\copy depression_rates FROM 'depression_dataset.csv' WITH (FORMAT csv, HEADER true);

-- sanity check
\d depression_rates
SELECT * FROM depression_rates;

-- SOCIAL MEDIA DATASET
DROP TABLE IF EXISTS social_media_usage;

CREATE TABLE social_media_usage (
    id_age_group TEXT,
    id_sm_platform TEXT,
    percent NUMERIC(3,1),
    PRIMARY KEY (id_age_group, id_sm_platform)
);

\copy social_media_usage FROM 'social_media_gamers.csv' WITH (FORMAT csv, HEADER true);

-- sanity check
\d social_media_usage
SELECT * FROM social_media_usage;

-- COMBINE DATASETS

--Finding the most popular social media patform per age group 
SELECT id_age_group, id_sm_platform, percent
FROM social_media_usage
WHERE percent in (SELECT DISTINCT MAX(percent)
                    FROM social_media_usage
                    GROUP BY id_age_group);

-- Compare percentage of usage for tik tok specifically
SELECT id_age_group, id_sm_platform, percent
FROM social_media_usage
WHERE id_sm_platform = 'TikTok';

-- Compare percentage of usage for instagram specifically
SELECT id_age_group, id_sm_platform, percent
FROM social_media_usage
WHERE id_sm_platform = 'Instagram';

-- get depression data for specific age groups
SELECT category, percent
FROM depression_rates
WHERE category IN ('16-29', '30-49', '50+');


SELECT dr.category AS age_group, sm.percent AS social_media_percent, dr.percent AS depression_rate
FROM depression_rates dr JOIN social_media_usage sm ON dr.category = sm.id_age_group
WHERE sm.id_sm_platform = 'TikTok';

SELECT dr.category AS age_group, sm.percent AS social_media_percent, dr.percent AS depression_rate
FROM depression_rates dr JOIN social_media_usage sm ON dr.category = sm.id_age_group
WHERE sm.id_sm_platform = 'Instagram';

SELECT dr.category AS age_group, sm.percent AS social_media_percent, dr.percent AS depression_rate
FROM depression_rates dr JOIN social_media_usage sm ON dr.category = sm.id_age_group
WHERE sm.id_sm_platform = 'YouTube';


CREATE INDEX platform_idx ON social_media_usage(id_sm_platform);