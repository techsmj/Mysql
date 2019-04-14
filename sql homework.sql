USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
select * from actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select first_name,last_name from actor;
alter table actor
add Actor_Name varchar(200) ; 
select first_name,last_name, Actor_Name from actor;
update actor set Actor_Name = concat(first_name, ' ' ,last_name) ;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select * from actor where first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor where last_name like "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

select last_name,first_name from actor where last_name like "%LI%";
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT  country_id, country FROM country WHERE country IN ("Afghanistan", "Bangladesh", "China");
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).

alter table actor
add Description blob(200);

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor DROP COLUMN Description;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT COUNT(last_name),last_name
FROM actor
GROUP BY last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT COUNT(last_name),last_name
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >1;
 -- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor
SET
  first_name = 'HARPO'
WHERE
  first_name ='Groucho'
  and
	last_name = 'Williams';
    
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
   
UPDATE actor
SET
  first_name = REPLACE('Groucho', 'first_name','HARPO')
WHERE
  actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address
SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address ON staff.address_id=address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
Select staff.first_name, staff.last_name, sum(payment.amount) as Totalamount
from staff
join payment on (payment.staff_id=staff.staff_id) and payment.payment_date between'2005-08-01' and '2005-08-31'
group by payment.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select film.title, Count(film_actor.actor_id) as "Number of Actors"
from film_actor
inner join film using (film_id)
group by actor_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

select film.title, Count(film.title) as "Total Films"
from film
inner join inventory using (film_id)
where film.title= 'Hunchback Impossible'
group by film_id;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name
select customer.first_name, customer.last_name, sum(payment.amount) as "Total Paid"
from customer
inner join payment using (customer_id)
group by customer_id
order by last_name;
SELECT * from language;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title, language_id  FROM film
WHERE language_id IN
	(SELECT language_id
     FROM film
     WHERE language_id = 1)
AND (title LIKE "K%") OR (title LIKE "Q%");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name, actor_id from actor
where actor_id in (
(select actor_id from film_actor
where film_id in
(select film_id from film
where  title = 'ALONE TRIP')));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select  customer.last_name,customer.first_name,customer.email, country.country  from customer
left join address
    on customer.address_id= address.address_id
left join city
    on city.city_id = address.city_id
left join country
    on country.country_id =city.country_id
   where country = 'CANADA'
   ORDER BY last_name;
SELECT * FROM category;
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select  film.title, category.category_id, category.name
from category
left join film_category
    on category.category_id= film_category.category_id
left join film
    on film.film_id = film_category.film_id
   where category.name = "family"
   ORDER BY name;
-- 7e. Display the most frequently rented movies in descending order.
select  film_text.title, COUNT(rental.rental_id) as 'Rental Count'
from film_text
join inventory
on film_text.film_id= inventory.film_id
join rental
on rental.inventory_id = inventory.inventory_id
GROUP BY title
ORDER BY COUNT(rental.rental_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select  store.store_id, SUM(payment.amount) as 'Total'
from store
join staff
on store.store_id= staff.store_id
join payment
on payment.staff_id = staff.staff_id
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select  store.store_id, city.city, country.country as 'Country'
from store
join address
on store.address_id= address.address_id
join city
on address.city_id = city.city_id
join country
on country.country_id =city.country_id
GROUP BY store_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select  category.name,  sum(payment.amount) as 'Total revenue'
from film_category
join category
on category.category_id= film_category.category_id
join inventory
on film_category.film_id = inventory.film_id
join rental
on rental.inventory_id = inventory.inventory_id
join payment
on payment.rental_id= rental.rental_id
GROUP BY category.name 
ORDER BY sum(payment.amount) DESC
LIMIT 5
;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Top_Five   as
select  category.name,  sum(payment.amount) as 'Total revenue'
from film_category
join category
on category.category_id= film_category.category_id
join inventory
on film_category.film_id = inventory.film_id
join rental
on rental.inventory_id = inventory.inventory_id
join payment
on payment.rental_id= rental.rental_id
GROUP BY category.name 
ORDER BY sum(payment.amount) DESC
LIMIT 5
;


-- 8b. How would you display the view that you created in 8a?
SELECT* FROM top_five;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five;
