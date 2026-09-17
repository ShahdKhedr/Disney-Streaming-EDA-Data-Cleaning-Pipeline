-- ---------------------------------------------------------
-- PART 1: Key Performance Indicators (KPI Cards)
-- ---------------------------------------------------------

-- KPI 1: Total Titles (إجمالي عدد العناوين)
SELECT 
    COUNT(show_id) AS total_titles
FROM disney_plus_titles_cleaned;


-- KPI 2: Average Monthly Additions (متوسط عدد العناوين المضافة شهرياً)
SELECT 
    ROUND(CAST(COUNT(show_id) AS FLOAT) / COUNT(DISTINCT FORMAT(date_added, 'yyyy-MM')), 2) AS avg_monthly_additions
FROM disney_plus_titles_cleaned
WHERE date_added IS NOT NULL;


-- KPI 3: Average Content Gap (متوسط الفجوة الزمنية بين الإصدار والإضافة)
SELECT 
    ROUND(AVG(CAST((year_added - release_year) AS FLOAT)), 2) AS avg_content_gap_years
FROM disney_plus_titles_cleaned
WHERE year_added IS NOT NULL AND release_year IS NOT NULL;


-- KPI 4: Top Active Month (أكثر شهر نشاطاً في الإضافة)
SELECT TOP 1
    DATENAME(MONTH, DATEADD(MONTH, month_added, -1)) AS top_active_month_name,
    COUNT(show_id) AS total_titles_added
FROM disney_plus_titles_cleaned
WHERE month_added IS NOT NULL
GROUP BY month_added
ORDER BY total_titles_added DESC;


-- KPI 5: Modern Content Percentage (نسبة المحتوى الحديث - أُصدر خلال سنتين أو أقل قبل إضافته)
SELECT 
    ROUND(100.0 * COUNT(CASE WHEN (year_added - release_year) <= 2 THEN 1 END) / COUNT(show_id), 2) AS modern_content_pct
FROM disney_plus_titles_cleaned
WHERE year_added IS NOT NULL AND release_year IS NOT NULL;


-- KPI 6: Year-over-Year (YoY) Growth Rate % (نسبة النمو السنوي)
WITH YearlyCounts AS (
    SELECT 
        year_added,
        COUNT(show_id) AS titles_count,
        LAG(COUNT(show_id)) OVER (ORDER BY year_added) AS prev_year_count
    FROM disney_plus_titles_cleaned
    WHERE year_added IS NOT NULL
    GROUP BY year_added
)
SELECT 
    year_added,
    titles_count,
    prev_year_count,
    ROUND(100.0 * (titles_count - prev_year_count) / NULLIF(prev_year_count, 0), 2) AS yoy_growth_pct
FROM YearlyCounts
ORDER BY year_added ASC;


-- ---------------------------------------------------------
-- PART 2: Business Questions Analysis
-- ---------------------------------------------------------

-- Q1: Annual Trend of Content Added (الاتجاه العام للإضافة سنويًا)
SELECT 
    year_added,
    COUNT(show_id) AS total_titles_added
FROM disney_plus_titles_cleaned
WHERE year_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added ASC;


-- Q2: Monthly Addition Rates by Content Type (الأشهر الأعلى إضافة مقسمة حسب النوع)
SELECT 
    month_added,
    DATENAME(MONTH, DATEADD(MONTH, month_added, -1)) AS month_name,
    type,
    COUNT(show_id) AS total_titles
FROM disney_plus_titles_cleaned
WHERE month_added IS NOT NULL
GROUP BY month_added, type
ORDER BY month_added ASC, type;


-- Q3: Preferred Day of the Week for Releases (اليوم الأفضل في الأسبوع للإضافة)
SELECT 
    day_name_added,
    COUNT(show_id) AS total_titles
FROM disney_plus_titles_cleaned
WHERE day_name_added IS NOT NULL
GROUP BY day_name_added
ORDER BY total_titles DESC;


-- Q4: Content Gap Distribution (توزيع الفجوة الزمنية بين الإصدار والإضافة)
SELECT 
    (year_added - release_year) AS content_gap_years,
    COUNT(show_id) AS number_of_titles
FROM disney_plus_titles_cleaned
WHERE year_added IS NOT NULL AND release_year IS NOT NULL
GROUP BY (year_added - release_year)
ORDER BY content_gap_years ASC;


-- Q5: Speed of Adding Modern vs Classic Content (سرعة إضافة المحتوى الحديث مقارنة بالكلاسيكي)
SELECT 
    release_year,
    year_added,
    COUNT(show_id) AS titles_count,
    ROUND(AVG(CAST((year_added - release_year) AS FLOAT)), 1) AS avg_gap
FROM disney_plus_titles_cleaned
WHERE year_added IS NOT NULL AND release_year IS NOT NULL
GROUP BY release_year, year_added
ORDER BY release_year DESC;


-- Q6: Proportion of Movies vs TV Shows Added Annually (نسبة الأفلام للمسلسلات سنويًا)
SELECT 
    year_added,
    COUNT(CASE WHEN type = 'Movie' THEN 1 END) AS total_movies,
    COUNT(CASE WHEN type = 'TV Show' THEN 1 END) AS total_tv_shows,
    ROUND(100.0 * COUNT(CASE WHEN type = 'Movie' THEN 1 END) / COUNT(show_id), 2) AS movie_pct,
    ROUND(100.0 * COUNT(CASE WHEN type = 'TV Show' THEN 1 END) / COUNT(show_id), 2) AS tv_show_pct
FROM disney_plus_titles_cleaned
WHERE year_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added ASC;


-- Q7: Content Spike Year (أعلى سنة شهدت ضخ محتوى دفعة واحدة)
SELECT TOP 1
    year_added,
    COUNT(show_id) AS total_titles_added
FROM disney_plus_titles_cleaned
WHERE year_added IS NOT NULL
GROUP BY year_added
ORDER BY total_titles_added DESC;