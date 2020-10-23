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