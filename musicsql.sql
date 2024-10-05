create database music;
use music;
-- 1.who is senior most employee based on job title
select * from employee
order by levels desc limit 1;


-- 2.which country have the most invoices
select count(*),billing_country from invoice 
group by billing_country
order by count(*) desc;

-- 3 top values of total invoice
select total from invoice 
order by total desc limit 3;

-- write the query that returns city name and sum of invoice totals;
select sum(total) ,billing_city 
from invoice
group by billing_city
order by sum(total) desc;


-- wite a query which customer has spend the most

select customer.customer_id as cus_id,customer.first_name as first_cus,customer.last_name,sum(invoice.total)as total
from customer join invoice
on customer.customer_id=invoice.customer_id
group by cus_id
order by total desc
limit 1; 


-- write a query to return email,firstname,lastname and genre of all rock music listeners 
-- return your order list alphabetically   by email starting with a
select distinct email,first_name,last_name
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name = 'rock'
)
order by email; 

select artist.artist_id,artist.name,count(artist.artist_id)as no_of_songs
from track
join album2 on album2.album_id = track.album_id
join artist on artist.artist_id= album2.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name='rock'
group by artist.artist_id
order by no_of_songs desc
limit 10;


-- return  all the tracks have longer lenth then avg return name and milisecond for each track 
-- order by longest track
select name,milliseconds
from track
where milliseconds>(
select avg(milliseconds) as avg_track
from track)
order by milliseconds desc;

-- find how much spent by each customer on artist?write query to return customer name,
-- arist name and total spent
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
select c.customer_id,c.first_name,c.last_name,bsa.artist_name,sum(il.unit_price*il.quantity)
as amount_spent
from invoice i
join customer c on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id =i.invoice_id
join track t on t.track_id=il.track_id
  join album2 alb on alb.album_id =t.album_id
join best_selling_artist bsa on bsa.artist_id=alb.artist_id
group by 1,2,3,4
order by 5 desc;

 
 
 -- most popular music genre for each country
 with popular_genre as
 (
 select count(invoice_line.quantity) as purchases,customer.country,genre.name,genre.genre_id,
 row_number()over (partition by customer.country order by count(invoice_line.quantity)desc)as row_no
 from invoice_line
 join invoice on invoice.invoice_id=invoice_line.invoice_id
 join customer on customer.customer_id =invoice.customer_id 
 join track on track.track_id = invoice_line.track_id
 join genre on genre.genre_id=track.genre_id
 group by 2,3,4
 order by 2 asc,1 desc
 )
 select * from popular_genre where row_no<=1
 
 
