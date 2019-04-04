select * from actor;
select first_name,last_name from actor;
alter table actor
add Actor_Name varchar(200) ; 
select first_name,last_name, Actor_Name from actor;
update actor set Actor_Name = concat(first_name, ' ' ,last_name) ;
select * from actor where first_name = "John";
select * from actor where last_name like "%GEN%";
select last_name,first_name from actor where last_name like "%LI%";

SELECT  country_id, country FROM country WHERE country IN ("Afghanistan", "Bangladesh", "China");

alter table actor
add Description blob(200);
select * from actor;

ALTER TABLE actor DROP COLUMN Description;

SELECT COUNT(last_name),last_name
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >1;

UPDATE actor
SET
  first_name = REPLACE('HARPO', 'first_name','Groucho')
WHERE
  actor_id = 172;