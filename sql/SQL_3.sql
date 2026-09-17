-- Counts the total number of shows for each rating and sorts them in descending order.
SELECT rating ,  COUNT (show_id) AS TOTAL_SHOWS
FROM disney_plus_titles_cleaned
GROUP BY rating
order by TOTAL_SHOWS desc

-- Counts the total number of shows classified under kids' ratings ('TV-Y', 'TV-Y7', 'G').
SELECT COUNT(show_id) AS TOTAL_SHOWS
FROM disney_plus_titles_cleaned
WHERE rating IN ('TV-Y' , 'TV-Y7' , 'G')

-- Counts the total number of shows classified under mature/teen ratings ('PG-13', 'TV-14').
SELECT COUNT(show_id) AS TOTAL_SHOWS
FROM disney_plus_titles_cleaned
WHERE rating IN ('PG-13' , 'TV-14')

-- Groups and counts the total shows by both rating and content type (Movie vs TV Show).
SELECT rating , type , COUNT(show_id) AS TOTAL_SHOWS
FROM disney_plus_titles_cleaned
GROUP BY rating , type
ORDER BY  type ,COUNT(show_id) DESC

-- Calculates the average duration grouped by rating and duration unit (Min or Season).
SELECT rating, duration_unit, AVG(duration_num) AS AVG_DURATION
FROM disney_plus_titles_cleaned
WHERE duration_unit IN ('Min', 'Season')
GROUP BY rating, duration_unit
ORDER BY duration_unit, AVG_DURATION DESC;

-- Counts the total number of mature/teen shows added each year.
SELECT year_added , COUNT(show_id) AS TOTAL_SHOWS
FROM disney_plus_titles_cleaned
WHERE rating IN ('TV-14', 'PG-13')
GROUP BY year_added

-- Counts and groups total shows by both rating and primary genre, sorted from highest to lowest.
SELECT rating, primary_genre ,COUNT(show_id) AS TOTAL_SHOWES
FROM disney_plus_titles_cleaned
GROUP BY rating , primary_genre
ORDER BY TOTAL_SHOWES DESC