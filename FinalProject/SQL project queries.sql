-- SET search_path = s23_group9;
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
SELECT dr.category AS age_group, sm.percent AS social_media_percent, dr.percent AS depression_rate
FROM depression_rates dr JOIN social_media_usage sm ON dr.category = sm.id_age_group
WHERE sm.id_sm_platform = 'TikTok';
