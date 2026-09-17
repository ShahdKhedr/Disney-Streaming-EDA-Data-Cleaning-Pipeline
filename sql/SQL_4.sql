-- Counts the total number of shows per country and sorts them in descending order.
SELECT country , COUNT(show_id) AS TOTAL_SHOWS
FROM disney_plus_titles_cleaned
GROUP BY country
ORDER BY COUNT(show_id) DESC

-- Counts the total number of shows where the country is marked as unknown.
SELECT country , COUNT(show_id) AS TOTAL_SHOWS
FROM disney_plus_titles_cleaned
WHERE country='Unknown Country'
GROUP BY country

-- Counts the total number of shows directed by each director and sorts them in descending order.
SELECT director ,COUNT(show_id) AS TOTAL_SHOWS
FROM disney_plus_titles_cleaned
GROUP BY director
ORDER BY  TOTAL_SHOWS DESC

-- Splits cast members and counts the total shows per individual actor.
SELECT     TRIM(value) AS individual_actor, COUNT(show_id) AS TOTAL_SHOWS
FROM 
disney_plus_titles_cleaned
CROSS APPLY STRING_SPLIT(cast, ',')
GROUP BY TRIM(value)
ORDER BY 
TOTAL_SHOWS DESC;

-- Counts shows by country and primary genre, excluding unknown countries.
SELECT country , primary_genre , COUNT(show_id) AS TOTAL_SHOWS
FROM disney_plus_titles_cleaned
WHERE country NOT IN ('Unknown Country')
GROUP BY country  , primary_genre 
ORDER BY TOTAL_SHOWS DESC

-- Counts recurring collaborations between individual directors and actors.
SELECT    director, TRIM(value) AS individual_actor, COUNT(show_id) AS TOTAL_SHOWS
FROM disney_plus_titles_cleaned
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE  director <> 'Unknown Director' AND TRIM(value) <> 'Unknown Cast'
GROUP BY  director,  TRIM(value)
ORDER BY TOTAL_SHOWS DESC;

-- Counts shows by country and release year, excluding unknown countries.
SELECT country , release_year , COUNT(show_id) AS TOTAL_SHOWS
FROM disney_plus_titles_cleaned
WHERE country NOT IN ('Unknown Country')
GROUP BY country ,  release_year
ORDER BY TOTAL_SHOWS DESC , release_year DESC