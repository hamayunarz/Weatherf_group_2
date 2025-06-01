/* # JOINS - Exercises */
/* JOINS with Tables: 'life_expectancy' and 'regions'  */

/* Q1. Please calculate the average life expectancy for each country.
 * 	 		Include the names of the region and of the country.
 * 			Include information what are the first and last year considered.
 */ 
SELECT c.country,r.region, c.avg_life_expectancy, c.first_year, c.last_year FROM countries c
JOIN regions r ON c.country = r.country;


/* Q2. Please calculate the average life expectancy per region. 
 * 			Include the number of countries that were considered, the years for period_start and period_end 
 * 			in your output.
 * 			Which region has the highest? 
 * 			
 * 			Note: We compressed a lot of countries and different years.
 */ 

SELECT * FROM countries c 

SELECT r.region,COUNT(DISTINCT c.country) AS num_countries, MIN(c.first_year) AS period_start, MAX(c.last_year) AS period_end, AVG(c.avg_life_expectancy) AS avg_life_expectancy
FROM countries c JOIN regions r ON c.country = r.country GROUP BY r.region ORDER BY avg_life_expectancy DESC;

/* Q3. What was the average life expectancy per region in year 2024
 */ 
SELECT r.region, AVG(l.life_expectancy) AS avg_life_expectancy FROM life_expectancy l JOIN regions r ON l.country = r.country WHERE l.year = 2024  GROUP BY r.region



/* Q4. Present the global development of the average life expectancy over time.
 */ 
SELECT year, AVG(life_expectancy) AS global_avg_life_expectancy FROM life_expectancy GROUP BY YEAR ORDER BY year;


/* BONUS: Should be done with JOIN only, without Window functions (not covered yet)
 * Show country and life expectancy this and last year, add column showing the change in %
 */







-- what if we need it per region
