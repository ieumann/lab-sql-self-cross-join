USE sakila;

# 1. Get all pairs of actors that worked together.
# Retrieving only the pairs of IDs.
SELECT fa1.actor_id AS actor1, fa2.actor_id AS actor2 
FROM film_actor as fa1
# I only want to display the pairs where the IDs are different.
JOIN film_actor as fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id 
JOIN actor as a ON fa1.actor_id = a.actor_id
ORDER BY fa1.actor_id ASC;

# Retrieving the names.
SELECT a1.first_name AS act1_firstname, a1.last_name AS act1_lastname,
       a2.first_name AS act2_firstname, a2.last_name AS act2_lastname
FROM film_actor AS fa1
JOIN film_actor AS fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id 
JOIN actor AS a1 ON fa1.actor_id = a1.actor_id
JOIN actor AS a2 ON fa2.actor_id = a2.actor_id
ORDER BY act1_firstname ASC;

# 2. Get all pairs of customers that have rented the same film more than 3 times.
SELECT c1.first_name AS cust1_first, c1.last_name AS cust1_last, 
       c2.first_name AS cust2_first, c2.last_name AS cust2_last, 
       f.title AS film_title
FROM customer AS c1
JOIN rental AS r1 ON c1.customer_id = r1.customer_id
JOIN inventory AS i1 ON r1.inventory_id = i1.inventory_id
JOIN rental AS r2 ON i1.film_id = r2.inventory_id
JOIN customer AS c2 ON r2.customer_id = c2.customer_id AND c1.customer_id < c2.customer_id
JOIN film AS f ON i1.film_id = f.film_id
GROUP BY c1.customer_id, c2.customer_id, f.film_id
HAVING COUNT(*) > 3
ORDER BY film_title;
# There is no such pair of customers.

# 3. Get all possible pairs of actors and films.
SELECT title, first_name, last_name FROM actor
CROSS JOIN film 
ORDER BY title;

# Or to save computing time if necessary, I create temporary tables for actors and films.
CREATE TEMPORARY TABLE temp_actors AS SELECT * FROM actor;
CREATE TEMPORARY TABLE temp_films AS SELECT * FROM film;
# I get all possible pairs of actors and films.
SELECT title, first_name, last_name 
FROM temp_actors 
CROSS JOIN temp_films 
ORDER BY title;
# I drop the temporary tables again.
DROP TEMPORARY TABLE IF EXISTS temp_actors;
DROP TEMPORARY TABLE IF EXISTS temp_films;
