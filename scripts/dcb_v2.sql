
SELECT * FROM app_store_apps;
SELECT * FROM play_store_apps;


DROP TABLE IF EXISTS match;
CREATE TEMP TABLE match AS
WITH app_store_apps AS (SELECT name, rating, review_count
				  FROM app_store_apps
				  WHERE price = '0.00')
				  AND review_count::numeric > 100000
				  AND rating > 4
	 			  AND primary_genre ILIKE 'Games')  AS asa,
	play_store_apps AS (SELECT, name, rating, review_count
				   FROM play_store_apps
				   WHERE (price, '$')::numeric = '0.00'
				   AND rating > 4
	 			   AND primary_genre ILIKE 'Games')  AS asa,
	match AS (SELECT name
				FROM app_store
				INTERSECT
				SELECT name
				FROM play_store)
				 
SELECT DISTINCT(name)
FROM match
INNER JOIN app_store_apps as apple USING(name)
INNER JOIN play_store_apps as play USING(name);
				   
						
SELECT name,category,price, rating, review_count
FROM (SELECT DISTINCT name, category, price,rating,review_count
	  FROM play_store_apps
	  WHERE rating > 4
		AND price::money < 1:: money
		AND review_count > 100000
		AND category ILIKE 'Game') AS psa
				   
SELECT name, category price, rating, review_count
FROM (SELECT DISTINCT name, primary_genre AS category , price, rating, review_count
	  FROM app_store_apps
  	  WHERE rating > 4
		AND price::money < 1:: money
		AND review_count::numeric > 100000
	 	AND primary_genre ILIKE 'Games')  AS asa
GROUP BY name, category,price,rating,review_count
ORDER BY category, rating DESC
LIMIT 40;
----
SELECT name,category,price, rating, review_count
FROM (SELECT DISTINCT name, category, price,rating,review_count
	  FROM play_store_apps
	  WHERE rating > 4
		AND price::money < 1:: money
		AND review_count > 100000
		AND category ILIKE 'Game') AS psa
GROUP BY name, category,price,rating,review_count
ORDER BY category, rating DESC

INNER JOIN
USING(name)
SELECT name, category price, rating, review_count
FROM (SELECT DISTINCT name, primary_genre AS category , price, rating, review_count
	  FROM app_store_apps
  	  WHERE rating > 4
		AND price::money < 1:: money
		AND review_count::numeric > 100000
	 	AND primary_genre ILIKE 'Games')  AS asa
GROUP BY name, category,price,rating,review_count
ORDER BY category, rating DESC
LIMIT 40;
----
SELECT a.name , a.primary_genre as app_primary_genre,  a.rating as app_rating,
	   a.content_rating as app_content_rating,a.price as app_price,
       a.currency as app_currency, a.review_count as app_review_count,
	   b.genres as play_genre, b.rating as play_rating,b.price as play_price,
	   b.content_rating as play_content_rating,b.type as play_type, install_count,
	   --to calculate the cost of the apps
	   case when a.price BETWEEN 0 AND 1 then 10000
	   else a.price*10000 end as cost
	 
FROM app_store_apps a
inner join play_store_apps b
on a.name = b.name
WHERE a.primary_genre ='Games'
AND a.price = 0.00 AND b.type = 'Free'
AND a.rating >= 4.0 AND b.rating >= 4.0
ORDER BY a.rating desc,cost desc
	
----------------
WITH psa AS (SELECT DISTINCT name AS psa_name, category, price AS psa_price,rating AS psa_rating,
			 review_count AS psa_review_count
		  	 FROM play_store_apps
	 		 WHERE rating > 4
				AND price::money < 1:: money
				AND review_count > 100000
				AND category ILIKE 'Game'),
	 asa AS (SELECT DISTINCT name AS asa_name, primary_genre AS category , price AS asa_price,
			 rating AS asa_rating, review_count AS asa_review_count
	  		 FROM app_store_apps
  	  		 WHERE rating > 4
				AND price::money < 1:: money
				AND review_count::numeric > 100000
	 			AND primary_genre ILIKE 'Games')
SELECT psa_name, psa_price, psa_rating,psa_review_count,asa_price,asa_rating,asa_review_count
FROM psa
INNER JOIN asa on psa.psa_name = asa.asa_name
GROUP BY psa_name, psa_price,psa_rating,psa_review_count,asa_price,asa_rating,asa_review_count
ORDER BY psa_name
LIMIT 200;

SELECT name
from app_store_apps
Where name = 'Temple Run 2';
						