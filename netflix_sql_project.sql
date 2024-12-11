
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);
SELECT * FROM netflix;

-- Count the Number of Movies vs TV Shows

select 
type,
count(*) as total_content
from netflix
group by type

-- Find the Most Common Rating for Movies and TV Shows
with ratingcounts as (
select
   type,
   rating,
   count (*) as rating_count
   from netflix
   group by type,rating
   ),

Rankedratings  as (
select
     type,
     rating,
     rating_count,
     rank() over(partition by type order by rating_count desc) as rank 
	 from ratingcounts
     )
  select
  type,
  rating as most_frequent_rating 
  from Rankedratings
  where rank=1

  

 --List All Movies Released in a Specific Year(eg:2020)
 select * from netflix
 where type='Movie'
 AND
 release_year=2020

 -- Find the Top 5 Countries with the Most Content on Netflix
select
UNNEST(string_to_array(country,','))as country,
count (*) as total_content
from netflix
group by 1 
order by total_content desc
limit 5

--Identify the Longest Movie

select * from netflix
where
   type='Movie'
   AND
    duration=(select max(duration)from netflix)

--Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT * FROM NETFLIX
where director like '%Rajiv Chilaka%'

--List All TV Shows with More Than 5 Seasons

select * from netflix
where type='TV Show'
and SPLIT_PART(duration, ' ',1)::int > 5

 --Count the Number of Content Items in Each Genre
 select 
 unnest(string_to_array(listed_in, ',')) as genre,
 count(show_id) as total_content
 from netflix
 group by 1;

 --Find each year and the average numbers of content release in India on netflix.
 select
 country,
 release_year,
 count(show_id) as total_release,
 ROUND(
 (count(show_id)::numeric/
 (select count (*) from netflix where country='India'))*100,2) as avg_release
 from netflix
 where country='India'
 group by country,release_year
 order by avg_release desc
 limit 5;
 
 --List All Movies that are Documentaries
select * from netflix
where
listed_in ILIKE '%documentaries%'

--Find All Content Without a Director
select * from netflix
where director is null

--Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
select * from netflix
where
 casts ILIKE '%SALMAN KHAN%'
 AND 
 release_year>extract( year from current_date)-10
--Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
select 
UNNEST(STRING_TO_ARRAY(casts,','))as actors,
count(*) as total_content
from netflix
where country ILIKE '%India%'
group by actors
order by total_content desc
limit 10

--Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
with new_table as 
(
select
*,
 CASE
   WHEN
   description ILIKE '%kill%%' 
   or 
   description ILIKE '%Violence%' then 'Bad_content'
   ELSE 'Good_conent'
 end category
from netflix
)
 select category,
 count(*)as total_content
from new_table
group by category
 











