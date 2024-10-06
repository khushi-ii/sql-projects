use mobile;

CREATE TABLE cab(id integer,state VARCHAR(200),city varchar(200),seater integer,charge integer); 

INSERT INTO cab(id,state,city,seater,charge) 
 VALUES(1,'Jharkhand','Jamshedpur',4,3000),
(2,'Bihar','Purnea',3,2250),
(3,'Jharkhand','Jamshedpur',4,3000),
(4,'West Bengal','Kolkata',2,1750),
(5,'West Bengal','Siliguri',4,3500),
(6,'Jharkhand','Ranchi',4,3000),
(7,'Bihar','Sasaram',3,2100);


CREATE TABLE customers(id integer,namee VARCHAR(200),from_state VARCHAR(200),min_seater integer,min_rent integer,max_rent integer); 

INSERT INTO customers(id,namee,from_State,min_seater,min_rent,max_rent) 
VALUES(1,'Ram','Jharkhand',3,2500,3200),
(2,'Shyam','West Bengal',2,1500,2500),
(3,'Suresh','West Bengal',4,2500,4000),
(4,'Mahesh','Bihar',3,2200,2500),
(5,'Raj','Bihar',3,1800,2300);

CREATE TABLE order_details(id integer,date date,cust_id integer,cab_id integer); 

INSERT INTO order_details(id,date,cust_id,cab_id) 
 VALUES (1,'2022-05-07',1,1),
(2,'2022-05-07',2,4),
(3,'2022-05-07',3,5),
(4,'2022-05-07',4,2);
select * from cab;
select * from customers;
select * from order_details;

select a.namee,a2.namee,a.id,a2.id from customers a join customers a2 on a.from_state = a2.from_state where a.id <a2.id;

select a.id,a.city,a.charge,b.id,b.city,b.charge from cab a join cab b on a.city=b.city and a.charge=b.charge and a.id <> b.id;

select a.id,a.namee,b.id,b.state,b.city,b.seater,b.charge from customers a join cab b
 on a.from_state = b.state and b.charge between a.min_rent and a.max_rent and b.seater >=a.min_seater
 and b.id not in(select distinct cab_id from order_details);
 
 select a.date,b.charge from order_details a inner join cab b on a.cab_id=b.id;
 
 select *,ifnull(id,0)+ifnull(maths,0)+ifnull(english,0)+ifnull(physics,0)+ifnull(chemistry,0)+ifnull(computer,0) as sum from marks;
 
 CREATE TABLE table1(id integer); 

 INSERT INTO table1(id) 
 VALUES(1),
 (1),
 (2),
 (3),
 (4),
 (3),
 (null),
 (null);
 
 CREATE TABLE table2(id integer); 

 INSERT INTO table2(id) 
 VALUES(1),
 (2),
 (3),
 (2),
 (null);

 select * from table1;
  select * from table2;
  
  
  CREATE TABLE details(Timing1 TIME, Timing2 TIME); 

 INSERT INTO details(Timing1,Timing2) 
 VALUES('10:50:00','12:30:00'),
 ('12:30:00','13:52:00'),
('05:45:00','09:00:00');

select * from details;

-- time diff
SELECT *,
    CONCAT(
        FLOOR(TIMESTAMPDIFF(SECOND, Timing1, Timing2) / 3600), " hr ",    -- Hours part
        FLOOR((TIMESTAMPDIFF(SECOND, Timing1, Timing2) % 3600) / 60), " min ", -- Minutes part
        floor((TIMESTAMPDIFF(SECOND, Timing1, Timing2) % 60)), " sec"   -- Seconds part
    ) AS times
FROM details;

CREATE TABLE details1 (
  custid varchar(200),
  orderid integer,
  item varchar(200),
  quantity integer 
);
-- insert some values
INSERT INTO details1(custid,orderid,item,quantity) 
values ('c1',1, 'mouse', 2),
('c1',1, 'keyboard', 3),
('c1',1, 'headphone', 5),
('c1',1, 'laptop',1 ),
('c1',1, 'pendrive', 3),
('c2',1, 'tv', 2),
('c2',1, 'washing machine', 2),
('c2',1, 'mobile', 1),
('c2',1, 'earphones',3 );

select group_concat(item,'-',quantity) summary from details1
group by custid;

SELECT GROUP_CONCAT(item ORDER BY quantity DESC) AS items
FROM details1;

select * from `sql inter`;

select * from `sql inter 2`;

SELECT s1.`customer name`, s1.`customer id`, COUNT(DISTINCT s2.`order id`), MONTH(s2.`order date`) AS mnth
FROM `sql inter` s1
JOIN `sql inter 2` s2
ON s1.`customer id` = s2.`customer id`
WHERE MONTH(s2.`order date`) IN (4, 5)
 GROUP BY s1.`customer name`, s1.`customer id`, mnth;
