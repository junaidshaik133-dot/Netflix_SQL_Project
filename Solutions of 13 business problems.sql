-- Netflix Data Analysis using SQL
-- Business Problems and Solutions

-- 1. Count the Number of Movies vs TV Shows

select type, count(*) as number_of_movies
from netflix
group by type;




-- 2. Find the Most Common Rating for Movies and TV Shows


select type, rating, common_rating from(
select type, rating, count(*) as common_rating,
row_number() over (partition by type order by count(*) desc) as rnk
from netfilix
group by type, rating) as rank_tb
where rnk = 1;



-- 3. List All Movies Released in a Specific Year (e.g., 2020)


SELECT * 
FROM netflix
WHERE release_year = 2020;


-- 4. Find the Top 5 Countries with the Most Content on Netflix

select case when country is null then 'No_name'
else substring_index(country,',',1)  end as new_country,
count(show_id) as total_shows
from netflix
group by 1
order by 2 desc
limit 5;


-- 5. Identify the Longest Movie

select * from netflix
where type = 'Movie'
and duration = (select max(duration) from netflix);



-- 6. Find Content Added in the Last 5 Years

SELECT *, STR_TO_DATE(date_added, '%M %d, %Y') AS converted_date 
from netflix
where STR_TO_DATE(date_added, '%M %d, %Y') >=  DATE_SUB(CURDATE(), INTERVAL 5 YEAR);


-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

select * from netflix
where director like '%Rajiv Chilaka%';



-- 8. List All TV Shows with More Than 5 Seasons

select * from netflix
where SUBSTRING_INDEX(duration," ",1) >= 5 and type = 'TV Show';




-- 9.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

select  EXTRACT(year FROM STR_TO_DATE(date_added, '%M %d, %Y')) as YEAR_COL,
round(avg(count(*)) over (partition by EXTRACT(year FROM STR_TO_DATE(date_added, '%M %d, %Y'))
order by EXTRACT(year FROM STR_TO_DATE(date_added, '%M %d, %Y')) desc ),0) as avg_content
from netflix
where country like '%india%'
group by  1
order by 2 desc
limit 5;


-- 10. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';



-- 11. Find All Content Without a Director

SELECT * 
FROM netflix
WHERE director IS NULL;



-- 12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

select type, count(*)  as number_of_movies from netflix
where cast like '%Salman Khan%' and release_year
group by type;



-- 13. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords


with mycte as (
select *,
case 
    when description like '%kill%' or '%violence%'
    then 'Bad_Content'
	else 'Good_Content' end as Content_Category
from netflix)
select Content_Category, count(*) as number_of_movies from mycte
group by 1;

