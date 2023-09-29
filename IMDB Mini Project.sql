
USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
-- Segment 1:
show tables;


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) row_schema from director_mapping;
select count(*) row_schema from genre;
select count(*) row_schema from movie;
select count(*) row_schema from names;
select count(*) row_schema from ratings;
select count(*) row_schema from role_mapping;
-- ----OR--------
select table_name,table_rows
from information_schema.tables
where table_schema='imdb';


-- Q2. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
select * from movie;
select year,count(id) as no_of_movies from movie group by year;

-- month
select month(date_published) as month,count(id) as no_of_movies from movie
group by month(date_published) order by month(date_published);
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
  
-- Q3. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select count(id) no_of_movie,year from movie 
where country='India' or country='USA' group by year having year=2019;

-- Q4. Find the unique list of the genres present in the data set?
select distinct genre from genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q5.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre, Count(mov.id) AS number_of_movies FROM movie AS mov INNER JOIN genre AS gen
on gen.movie_id = mov.id GROUP BY genre;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q6. How many movies belong to only one genre?
-- Type your code below:
select movie_id,count(genre) 
from genre
group by movie_id
having count(genre)=1
order by movie_id;



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q7.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
select avg(duration) as avg_duration, genre from movie m join genre g
on g.movie_id=m.id group by genre ORDER BY avg_duration DESC;

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q8.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select * from ratings;
select min(avg_rating),min(total_votes),min(median_rating),max(avg_rating),max(total_votes),max(median_rating)
from ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q9. Which are the top 10 movies based on average rating?
select * from ratings;
select m.title,r.avg_rating from movie m join ratings r
on m.id=r.movie_id order by r.avg_rating desc limit 10;

/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q10. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
select * from ratings;
select median_rating,count(movie_id)as movie_count
from ratings
group by median_rating
order by movie_count desc;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q11. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company, Count(movie_id) AS movie_count FROM ratings AS rat 
INNER JOIN movie AS mov ON mov.id = rat.movie_id
WHERE avg_rating > 8
GROUP BY production_company;

-- Q11. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:
+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select genre,count(genre) movie_count from genre g 
join ratings r on r.movie_id=g.movie_id
inner join movie m on g.movie_id=m.id
where m.country="USA" and r.total_votes>1000 and m.year=2017 and month(date_published)=3 
group by genre;

-- Lets try to analyse with a unique problem statement.
-- Q12. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select m.title,r.avg_rating,g.genre
from genre g
join ratings r
on r.movie_id=g.movie_id
join movie m
on r.movie_id=m.id
where m.title like "The%" and r.avg_rating>8;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q13. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select count(r.movie_id),r.median_rating
from ratings r
join movie m
on r.movie_id=m.id
where median_rating=8 and date_published between '2018-04-01' and '2019-04-01'
group by median_rating;


-- Q14. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
select * from movie;
select * from ratings;

SELECT country, sum(total_votes) as total_votes FROM movie AS mov
INNER JOIN ratings as rat ON mov.id=rat.movie_id
WHERE country = 'germany' or country = 'italy'
GROUP BY country;

-- Q15. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select * from names;
show tables;
select
	  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_null, 
	  SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_null, 
	  SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS dob_null, 
	  SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS knownfor_movie_null 
from names;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q16. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
   nam.name AS actor_name,
       Count(movie_id) AS movie_count
FROM role_mapping AS rm
       INNER JOIN movie AS mov
             ON mov.id = rm.movie_id
       INNER JOIN ratings AS rat USING(movie_id)
       INNER JOIN names AS nam
             ON nam.id = rm.name_id
WHERE rat.median_rating >= 8
	  AND category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q17. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
   production_company,
   Sum(total_votes) AS vote_count,
   Rank() OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM movie AS mov
INNER JOIN ratings AS rat
	  ON rat.movie_id = mov.id
GROUP BY production_company LIMIT 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q18. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_summary AS (
    SELECT n.name AS actor_name,
           SUM(total_votes) AS total_votes,
           COUNT(r.movie_id) AS movie_count,
           ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating
    FROM movie AS m
    INNER JOIN ratings AS r ON m.id = r.movie_id
    INNER JOIN role_mapping AS rm ON m.id = rm.movie_id
    INNER JOIN names AS n ON rm.name_id = n.id
    WHERE category = 'actor' AND country = 'india'
    GROUP BY n.name
    HAVING movie_count >= 5
)
SELECT *
FROM (SELECT *,DENSE_RANK() OVER (ORDER BY actor_avg_rating DESC) AS actor_dense_rank FROM actor_summary) ranked_actors
WHERE actor_dense_rank between 1 and 3;
-- Top actor is Vijay Sethupathi



-- Q19.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_detail AS (
    SELECT
        n.name AS actress_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(r.movie_id) AS movie_count,
        ROUND(SUM(avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating
    FROM movie AS m
    INNER JOIN ratings AS r ON m.id = r.movie_id
    INNER JOIN role_mapping AS rm ON m.id = rm.movie_id
    INNER JOIN names AS n ON rm.name_id = n.id
    WHERE UPPER(category) = 'ACTRESS'
        AND UPPER(country) = 'INDIA'
        AND UPPER(languages) LIKE '%HINDI%'
    GROUP BY n.name
    HAVING COUNT(r.movie_id) >= 3
)
SELECT
    actress_name, total_votes, movie_count, actress_avg_rating,
    RANK() OVER (ORDER BY actress_avg_rating DESC) AS actress_rank
FROM actress_detail
LIMIT 5;
/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q20. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT title,
		CASE WHEN avg_rating > 8 THEN 'Superhit movies'
			 WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
             WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
			 WHEN avg_rating < 5 THEN 'Flop movies'
		END AS avg_rating_category
FROM movie AS m
INNER JOIN genre AS g
ON m.id=g.movie_id
INNER JOIN ratings as r
ON m.id=r.movie_id
WHERE genre='thriller';

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q21. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;
-- Round is good to have and not a must have; Same thing applies to sorting


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q22.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company,
		COUNT(m.id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
FROM movie AS m 
INNER JOIN ratings AS r 
ON m.id=r.movie_id
WHERE median_rating>=8 AND production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY production_company
LIMIT 2;
-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language






