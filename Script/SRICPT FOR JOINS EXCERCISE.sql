SELECT *
FROM specs

SELECT *
FROM revenue

SELECT *
FROM rating

SELECT *
FROM distributors



--Question 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT s.film_title
	,	s.release_year
	,	r.worldwide_gross
FROM specs AS s
	INNER JOIN revenue AS r 
		ON s.movie_id = r.movie_id
ORDER BY r.worldwide_gross ASC
LIMIT 1;
		--Movie name		release year		World wide gross
--Answer. semi-tough		1977				37187139

--Question 2. What year has the highest average imdb rating?

SELECT s.release_year AS release_year
	, 	AVG(r.imdb_rating) AS average_rating
FROM specs AS s
	INNER JOIN rating AS r 
		ON s.movie_id = r.movie_id
GROUP BY release_year
ORDER BY average_rating DESC
LIMIT 1;

--Answer. 1991

--Question 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT s.film_title
	,	 r.worldwide_gross
	,	 d.company_name
FROM specs AS s
	INNER JOIN revenue AS r 
		ON s.movie_id = r.movie_id
	INNER JOIN distributors AS d ON s.domestic_distributor_id = d.distributor_id
WHERE s.mpaa_rating = 'G'
ORDER BY r.worldwide_gross DESC
LIMIT 1;

--Answer. Toy Story 4 and distributed by WALT DISNEY

--Question 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT d.company_name
	,	 COUNT(s.movie_id) AS movie_count 
	,	 d.distributor_id
FROM distributors AS d
	LEFT JOIN specs AS s 
		ON d.distributor_id = s.domestic_distributor_id
GROUP BY d.distributor_id, d.company_name
ORDER BY movie_count DESC

--Answer: RUN QUERY TO SEE THE ANSWER

--Question 5. Write a query that returns the five distributors with the highest average movie budget.

SELECT d.company_name
	,	 ROUND(AVG(r.film_budget),2) AS average_budget
FROM specs as s
	INNER JOIN distributors AS d 
		ON s.domestic_distributor_id = d.distributor_id
	INNER JOIN revenue AS r ON s.movie_id = r.movie_id
GROUP BY d.company_name
ORDER BY average_budget DESC
LIMIT 5;

--Answer. run query to see result

--Question 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT s.film_title
	, 	d.company_name
	,	r.imdb_rating
FROM specs as s
	INNER JOIN distributors as d
		ON s.domestic_distributor_id = d.distributor_id
	INNER JOIN rating AS r
		USING (movie_id)
WHERE d.headquarters NOT LIKE '%CA'
ORDER BY r.imdb_rating DESC

--Answer: 2 movies without having headquarter

--Question 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

I used the same approach:

SELECT 
	CASE WHEN length_in_min >=0 AND length_in_min <=120 THEN 'Under 2 Hours' 
	ELSE 'Over 2 Hours'
	END AS length_range, 
	ROUND(AVG(r.imdb_rating),2) as avg_rating
FROM specs as s
LEFT JOIN rating as r
USING(movie_id)
GROUP BY length_range
ORDER BY avg_rating DESC;

--Answer: over 2 hrs =7.26 and and under 2 hours =6.92