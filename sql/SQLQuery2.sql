-- ---------------------------------------------------------
-- PART 1: Key Performance Indicators (KPI Cards)
-- ---------------------------------------------------------

-- KPI 1: Movies to TV Shows Ratio (نسبة الأفلام إلى المسلسلات)
SELECT 
    ROUND(1.0 * COUNT(CASE WHEN type = 'Movie' THEN 1 END) / NULLIF(COUNT(CASE WHEN type = 'TV Show' THEN 1 END), 0), 2) AS movies_to_tv_ratio
FROM disney_plus_titles_cleaned;


-- KPI 2: Genre Diversity (عدد التصنيفات الفنية الفريدة)
SELECT 
    COUNT(DISTINCT primary_genre) AS unique_genres_count
FROM disney_plus_titles_cleaned
WHERE primary_genre IS NOT NULL;


-- KPI 3: Average Movie Duration in Minutes (متوسط مدة الفيلم بالدقائق)
SELECT 
    ROUND(AVG(CAST(duration_num AS FLOAT)), 1) AS avg_movie_duration_minutes
FROM disney_plus_titles_cleaned
WHERE type = 'Movie' AND duration_num IS NOT NULL;


-- KPI 4: Dominant Genre (أكثر تصنيف فني هيمنة على المكتبة)
SELECT TOP 1
    primary_genre AS dominant_genre,
    COUNT(show_id) AS total_titles
FROM disney_plus_titles_cleaned
WHERE primary_genre IS NOT NULL
GROUP BY primary_genre
ORDER BY total_titles DESC;


-- KPI 5: Family & Animation Content Percentage (نسبة المحتوى العائلي والرسوم المتحركة)
SELECT 
    ROUND(100.0 * COUNT(CASE WHEN primary_genre IN ('Family', 'Animation') 
                              OR listed_in LIKE '%Family%' 
                              OR listed_in LIKE '%Animation%' THEN 1 END) / COUNT(show_id), 2) AS family_animation_pct
FROM disney_plus_titles_cleaned;


-- KPI 6: Average Sub-Genres per Title (متوسط عدد التصنيفات الفرعية لكل عمل)
SELECT 
    ROUND(AVG(LEN(listed_in) - LEN(REPLACE(listed_in, ',', '')) + 1.0), 2) AS avg_sub_genres_per_title
FROM disney_plus_titles_cleaned
WHERE listed_in IS NOT NULL;


-- ---------------------------------------------------------
-- PART 2: Business Questions Analysis
-- ---------------------------------------------------------

-- Q1: Movies vs. TV Shows Distribution (النسبة بين الأفلام والمسلسلات)
SELECT 
    type,
    COUNT(show_id) AS total_titles,
    ROUND(100.0 * COUNT(show_id) / (SELECT COUNT(*) FROM disney_plus_titles_cleaned), 2) AS percentage
FROM disney_plus_titles_cleaned
GROUP BY type;


-- Q2: Top 10 Primary Genres (التصنيفات الفنية الرئيسية الأكثر تكراراً)
SELECT TOP 10
    primary_genre,
    COUNT(show_id) AS total_titles
FROM disney_plus_titles_cleaned
WHERE primary_genre IS NOT NULL
GROUP BY primary_genre
ORDER BY total_titles DESC;


-- Q3: Primary Genre Breakdown by Content Type (مقارنة التصنيفات بين الأفلام والمسلسلات)
SELECT 
    primary_genre,
    COUNT(CASE WHEN type = 'Movie' THEN 1 END) AS movie_count,
    COUNT(CASE WHEN type = 'TV Show' THEN 1 END) AS tv_show_count,
    COUNT(show_id) AS total_titles
FROM disney_plus_titles_cleaned
WHERE primary_genre IS NOT NULL
GROUP BY primary_genre
ORDER BY total_titles DESC;


-- Q4: Average Movie Duration by Genre (متوسط مدة الأفلام بالدقائق حسب التصنيف)
SELECT 
    primary_genre,
    ROUND(AVG(CAST(duration_num AS FLOAT)), 1) AS avg_duration_minutes,
    MAX(duration_num) AS max_duration_minutes,
    MIN(duration_num) AS min_duration_minutes
FROM disney_plus_titles_cleaned
WHERE type = 'Movie' AND duration_num IS NOT NULL AND primary_genre IS NOT NULL
GROUP BY primary_genre
ORDER BY avg_duration_minutes DESC;


-- Q5: Average Sub-Genres Count by Content Type (متوسط عدد التصنيفات لكل عمل حسب النوع)
SELECT 
    type,
    ROUND(AVG(LEN(listed_in) - LEN(REPLACE(listed_in, ',', '')) + 1.0), 2) AS avg_sub_genres
FROM disney_plus_titles_cleaned
WHERE listed_in IS NOT NULL
GROUP BY type;


-- Q6: Co-occurring Genres Frequency (أكثر التصنيفات المزدوجة ظهوراً معاً في listed_in)
SELECT TOP 10
    listed_in AS genre_combination,
    COUNT(show_id) AS titles_count
FROM disney_plus_titles_cleaned
WHERE listed_in IS NOT NULL
GROUP BY listed_in
ORDER BY titles_count DESC;


-- Q7: Genre Expansion Over Years (توسع وتطور التصنيفات الفنية عبر السنوات)
SELECT 
    year_added,
    primary_genre,
    COUNT(show_id) AS titles_added
FROM disney_plus_titles_cleaned
WHERE year_added IS NOT NULL AND primary_genre IS NOT NULL
GROUP BY year_added, primary_genre
ORDER BY year_added ASC, titles_added DESC;