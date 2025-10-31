# Netflix Movies and TV Shows Data Analysis using MySQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using MySQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
select type, count(*) as number_of_movies
from netflix
group by type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
select type, rating, common_rating from(
select type, rating, count(*) as common_rating,
row_number() over (partition by type order by count(*) desc) as rnk
from netfilix
group by type, rating) as rank_tb
where rnk = 1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * 
FROM netflix
WHERE release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select case when country is null then 'No_name'
else substring_index(country,',',1)  end as new_country,
count(show_id) as total_shows
from netflix
group by 1
order by 2 desc
limit 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
select * from netflix
where type = 'Movie'
and duration = (select max(duration) from netflix);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *, STR_TO_DATE(date_added, '%M %d, %Y') AS converted_date 
from netflix
where STR_TO_DATE(date_added, '%M %d, %Y') >=  DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select * from netflix
where director like '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
select * from netflix
where SUBSTRING_INDEX(duration," ",1) >= 5 and type = 'TV Show';
```

**Objective:** Identify TV shows with more than 5 seasons.



### 9.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
select  EXTRACT(year FROM STR_TO_DATE(date_added, '%M %d, %Y')) as YEAR_COL,
round(avg(count(*)) over (partition by EXTRACT(year FROM STR_TO_DATE(date_added, '%M %d, %Y'))
order by EXTRACT(year FROM STR_TO_DATE(date_added, '%M %d, %Y')) desc ),0) as avg_content
from netflix
where country like '%india%'
group by  1
order by 2 desc
limit 5;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 10. List All Movies that are Documentaries

```sql
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.

### 11. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select type, count(*)  as number_of_movies from netflix
where cast like '%Salman Khan%' and release_year
group by type;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.


### 13. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
with mycte as (
select *,
case 
    when description like '%kill%' or '%violence%'
    then 'Bad_Content'
	else 'Good_Content' end as Content_Category
from netflix)
select Content_Category, count(*) as number_of_movies from mycte
group by 1;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.


Thank you for your support, and I look forward to connecting with you!
