-- Q1a: 
USE sakila;
SELECT first_name, last_name 
FROM actor; 

-- Q1b: 
SELECT CONCAT(first_name," ", last_name) AS actor_name 
FROM actor; 



-- Q2a: 

SELECT actor_id, first_name, last_name from actor
WHERE first_name = 'Joe'; 

-- Q2b: 
SELECT * FROM actor
WHERE last_name LIKE '%GEN%';

-- Q2c: 
SELECT * FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name ASC; 

-- Q2d: 
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan','Bangladesh','China');

-- Q3a:
ALTER TABLE actor 
	ADD middle_name VARCHAR(30) AFTER first_name; 

-- Q3b: 
ALTER TABLE actor 
MODIFY COLUMN middle_name blob;

-- Q3c: 
ALTER TABLE actor
DROP COLUMN middle_name;

-- Q4a: 
SELECT last_name, COUNT(*) as COUNT
FROM actor 
GROUP BY last_name 
ORDER BY COUNT DESC; 

-- Q4b:
SELECT last_name, COUNT(*) as COUNT
FROM actor 
GROUP BY last_name 
HAVING COUNT >= 2 
ORDER BY COUNT DESC; 

-- Q4c: 
SELECT actor_id, first_name, last_name from actor
WHERE first_name = 'GROUCHO'
	and last_name = 'WILLIAMS'; 

UPDATE actor
SET first_name = 'HARPO'
WHERE actor_id = 172; 

-- Q4d: 
UPDATE actor
SET first_name = (
CASE WHEN first_name = 'HARPO'
THEN 'GROUCHO'
ELSE 'MUCHO GROUCHO'
END
)
WHERE actor_id = 172; 

-- Q5a 

DESCRIBE sakila.address

SHOW CREATE TABLE sakila.address

-- Q6a 
SELECT * FROM address
SELECT * FROM staff


SELECT first_name, last_name, address 
FROM staff s 
INNER JOIN address a 
ON s.address_id = a.address_id


-- Q6b: 
SELECT * FROM payment

SELECT first_name, last_name, SUM(amount) 
FROM staff s 
INNER JOIN payment p 
ON s.staff_id = p.staff_id
GROUP BY p.staff_id

-- Q6c 

SELECT title, (
	SELECT COUNT(*) FROM film_actor WHERE film_actor.film_id = film.film_id
) AS 'Number of Actors'
FROM film;

-- Q6d:

SELECT title, (
	SELECT COUNT(*) FROM inventory WHERE film.film_id = inventory.film_id
) AS 'Number in Inventory' 
FROM film
WHERE title = 'Hunchback Impossible';

-- Q6e 
SELECT first_name, last_name, SUM(amount) 
FROM payment p 
INNER JOIN customer c  
ON p.customer_id = c.customer_id
GROUP BY p.customer_id
ORDER BY last_name ASC;

-- Q7a 
SELECT title 
FROM film 
WHERE language_id IN(
	SELECT language_id
    FROM language 
    WHERE name = 'English') 
AND (title LIKE 'K%') OR  (title LIKE 'Q%');


-- Q7b

SELECT first_name, last_name 
FROM actor
WHERE actor_id IN(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN(
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'
));

-- Q7c 

SELECT c.first_name, c.last_name, c.email, a.address, co.country
FROM customer c 
LEFT JOIN address a
	ON c.address_id = a.address_id
LEFT JOIN city ci
	ON a.city_id =ci.city_id 
LEFT JOIN country co 
	ON ci.country_id = co.country_id
	WHERE co.country = 'Canada'
;

-- Q7d 

SELECT title
FROM film
WHERE film_id IN(
	SELECT film_id
    FROM film_category
    WHERE category_id IN(
		SELECT category_id
        FROM category
        WHERE name = 'Family' 
));



-- 7e: 

SELECT f.title, f.film_id, COUNT(rental_id) AS 'Number of Times Rented'
FROM film f
LEFT JOIN inventory i
	ON f.film_id = i.film_id
LEFT JOIN rental r
	ON r.inventory_id = i.inventory_id
GROUP BY f.film_id, f.title
ORDER BY COUNT(rental_id) DESC;

-- 7f:
SELECT s.store_id AS 'Store', SUM(p.amount) as 'Total Business' 
FROM store s
INNER JOIN customer c
	ON c.store_id = s.store_id
INNER JOIN payment p
	ON p.customer_id = c.customer_id
GROUP BY s.store_id
ORDER BY s.store_id; 

-- 7g: 

SELECT s.store_id AS 'Store ID', c.city, co.country
FROM store s
LEFT JOIN address a
	ON s.address_id = a.address_id
LEFT JOIN city c
	ON c.city_id = a.city_id 
LEFT JOIN country co
	ON c.country_id = co.country_id;

    
-- 7h: 

SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross Revenue' 
FROM film f
LEFT JOIN film_category fc
	ON fc.film_id = f.film_id
LEFT JOIN category c
	ON fc.category_id = c.category_id
LEFT JOIN inventory i
	ON i.film_id = f.film_id
LEFT JOIN rental r
	ON r.inventory_id = i.inventory_id
LEFT JOIN payment p 
	ON p.rental_id = r.rental_id 
	WHERE p.amount IS NOT NULL 
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

-- 8a:

DROP VIEW IF EXISTS top_five_genres; 

CREATE VIEW top_five_genres AS 

SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross Revenue' 
FROM film f
LEFT JOIN film_category fc
	ON fc.film_id = f.film_id
LEFT JOIN category c
	ON fc.category_id = c.category_id
LEFT JOIN inventory i
	ON i.film_id = f.film_id
LEFT JOIN rental r
	ON r.inventory_id = i.inventory_id
LEFT JOIN payment p 
	ON p.rental_id = r.rental_id 
	WHERE p.amount IS NOT NULL 
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

-- 8b:
SELECT * FROM top_five_genres 

-- 8c:

DROP VIEW top_five_genres 

SELECT * FROM top_five_genres -- just to make sure it has been dropped 