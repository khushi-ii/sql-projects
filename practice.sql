use hr_emp;
CREATE TABLE `match` (
    team VARCHAR(20)
);
INSERT INTO `match` (team)
VALUES ('india'),('pak'),('aus'),('eng');
select * from `match`;
with cte as(
select *, row_number() over(order by team asc) as  id 
from `match`)
select * from cte as a join cte as b on a.team <> b.team
where a.id<b.id;

create table employeee(id int , name varchar(10));
insert into employeee(id,name) values (1,'emp1'),(2,'emp2'),(3,'emp3'),(4,'emp4'),(5,'emp5'),(6,'emp6'),(7,'emp7'),(8,'emp8');

with cte as(
select * , concat(id,' ',name) as con , ntile(3) over (order by id asc) as groupss from employeee)
select group_concat(con) as result ,groupss
from cte
group by groupss
order by groupss;


#cummulative sales by order id
create table cumm(emp_id int , sales_date date,sales_amount int);
insert into cumm values(101,'2024-01-8',1000),(102,'2024-01-30',5000),(104,'2024-01-26',800),(101,'2024-01-12',2000),(101,'2024-01-2',500);
select *,sum(sales_amount) over(partition by emp_id order by sales_date) as cumm_sales from cumm;


# salary emp greater than managers salary
create table greater1(emp_id int , emp_name varchar(20),salary int,managerid int);
insert into greater1 values(1,'arjun',70000,5),(2,'bharat',60000,5),(3,'chetan',90000,4),(4,'dinesh',80000,null),(5,'esha',75000,4);

SELECT g1.emp_id AS e1_empid,
       g1.emp_name AS e1_empname,
       g1.salary AS e1_salary
FROM greater1 g1
JOIN greater1 g2 ON g1.managerid = g2.emp_id
where g1.salary > g2.salary;


#3rd  highest salary
with cte as(select salary,dense_rank() over(order by salary desc) as  salaryrank from greater1)
select salary from cte where salaryrank=3;


#delete duplicate rows
CREATE TABLE test_cumm2(emp_id int, sales_amount int);  -- Create an empty copy of the table

INSERT INTO test_cumm2 (emp_id, sales_amount)
VALUES (1, 1000), (2, 1000), (3, 2000), (4, 2000);  -- Add sample data

-- Apply the delete operation on the test table
DELETE FROM test_cumm2
WHERE emp_id NOT IN (
    SELECT emp_id
    FROM (
        SELECT MIN(emp_id) AS emp_id
        FROM test_cumm
        GROUP BY sales_amount
    ) AS subquery
);

-- Check the results
SELECT * FROM greater1;


#alternate records
select * from(
select * ,row_number() over(order by emp_id) as rnk from greater1) A
where rnk%2=0;

# employees who have joined this month
select * from cumm ;
where  month(sales_date)=2;


#fetch emp name and manager name from the same table
select e.emp_name as e_name,m.emp_name as m_name
from greater1 e join greater1 m on e.emp_id =m.managerid;

   

select min(sales_amount),max(sales_amount) from cumm;

# calculatedistance
CREATE TABLE car_distances (
    car VARCHAR(10),
    day DATE,
    cumulative_distance INT
);
INSERT INTO car_distances (car, day,cumulative_distance) VALUES
('car1', '2024-09-01',  100),
('car1', '2024-09-02', 250),
('car1', '2024-09-03', 450),
('car2', '2024-09-01', 80),
('car2', '2024-09-02',200),
('car2', '2024-09-03', 380);

select *,cumulative_distance-lag(cumulative_distance,1,0) over(partition by car order by day) as distance
from car_distances;

# recuce the redundant data
CREATE TABLE routes1 (
    `source` VARCHAR(50),
    destination VARCHAR(50),
    distance INT
);
INSERT INTO routes1 (`source`, destination, distance) VALUES
('Bangalore', 'Hyderabad', 400),
('Hyderabad', 'Bangalore', 400),
('Chennai', 'Pune', 400),
('Pune', 'Chennai', 400),
('Delhi', 'Mumbai', 400),
('Mumbai', 'Delhi', 400);


with cte as(
select *,row_number() over() as rn
from routes1)
select * from cte c1 join cte c2 
on c1.rn<c2.rn and c1.`source` = c2.destination and c1.destination =c2.`source`;

# ungroup data
CREATE TABLE items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    count INT
);

INSERT INTO items (name, count) VALUES
('water', 2),
('tent', 4),
('apple', 1);

select * from greater1;



# salary range from 10000 to 40000
select *  from greater1 where salary between 10000 and 40000;

#employess from the same city
CREATE TABLE employes (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    gender CHAR(1),
    city VARCHAR(50),
    salary DECIMAL(10, 2)
);


INSERT INTO employes (id, name, gender, city, salary) VALUES
(1, 'Amit Sharma', 'M', 'Delhi', 80000.00),
(2, 'Priya Patel', 'F', 'Mumbai', 75000.00),
(3, 'Rajesh Kumar', 'M', 'Delhi', 72000.00),
(4, 'Sonia Gupta', 'F', 'Bangalore', 68000.00),
(5, 'Arjun Singh', 'M', 'Mumbai', 71000.00),
(6, 'Anita Desai', 'F', 'Kolkata', 60000.00),
(7, 'Vikram Reddy', 'M', 'Bangalore', 65000.00),
(8, 'Neha Rao', 'F', 'Delhi', 69000.00),
(9, 'Ravi Mehta', 'M', 'Chennai', 62000.00),
(10, 'Sanya Kapoor', 'F', 'Mumbai', 78000.00);

SELECT e1.name AS Employee1, e1.city AS City1, e2.name AS Employee2, e2.city AS City2
FROM employes e1
JOIN employes e2 ON e1.city = e2.city
WHERE e1.id < e2.id;

# find null values
select * from employes where id is null;

# cumm sum
select id,name,salary,sum(salary) over(order by id) as cummsales from employes;

#male female emp rartio
SELECT 
    (COUNT(CASE WHEN gender = 'M' THEN 1 END) * 100.0 / COUNT(*)) AS percentage_male
FROM 
    employes;
    
 
 #fetch 50% recird from table
 select * from employes
 where id<=(select count(id)/2 from employes);
 
 #or what if we dont have id col
 select * from(select * , row_number() over(order by id) as rn from employes) as emp
 where emp.rn<=(select count(rn)/2 from employes);
 
 
 # fetch the emp salary reaplce last 2 dig with XX eg 12345 -> 123XX
  #LENGTH(salary) gives total len,LEFT(salary, LENGTH(salary) - 2)->
   #extracts all from left expect last 2 from ryt ,CONCAT(..., 'XX')->combines i.e append
   #CAST(FLOOR(salary) AS CHAR): Converts the integer part of the salary to a string
   SELECT 
    id,
    name,
		CONCAT(
        LEFT(CAST(FLOOR(salary) AS CHAR), LENGTH(CAST(FLOOR(salary) AS CHAR)) - 2),
        'XX'
    ) as salry_formatted
FROM 
    employes;

                                                         
#fetch even odd rows->when no id given
select * from(select * , row_number() over(order by id) as rn from employes)as emp
where emp.rn%2=0; #for odd->%2=1

#a% _a% %a_    ___l   v%a


# n highest  salary with or without top.limit
select * from employes
order by salary desc;

# this not preffered in interview
select * from employes
order by salary
limit 1 offset 4;


#or
select e1.salary from employes e1  where 2=(select count(distinct e2.salary)
from employes e2
where e2.salary>e1.salary);  # count how many times e2>e1 if =2 means second highest


# duplicates
select id,count(*) as duplicate
from employes
group by id
having count(*)>1;

#dlt


DELETE FROM employes
WHERE id IN (
    SELECT id
    FROM (
        SELECT id
        FROM employes
        GROUP BY id
        HAVING COUNT(*) > 1
    ) AS subquery
);

#retrive employess who work in same project
with cte as
(select e.name,e.id,ed.project from employes as e inner join employesdetails as ed on e.id=ed.id)
select c1.name,c1.id,c2.project from cte c1,cte c2 where c1.project=cr.project and
c1.id != c2.id and c1.id<c2.id;



#highest sal from each project
select max(ed.salary) from employes as e1 inner join employesdetails as ed on e1.id =ed.id
group by project
order by projectsal desc;

#employes joined this year or monthly sales or yearlgy sales can find out too
SELECT YEAR(doj) AS join_date, COUNT(*) AS total_emp
FROM employes
GROUP BY YEAR(doj)
ORDER BY join_date;


#create 3 groups base on salry <1lakh as low 1l + 2L med and ....
select *,
case
when salary>100000 then 'high'
else 'low' 
end as salarystatus
from employes;

# pivot the data in emp and retrive salary on basis on city should display rows seperately and then salary
select name,id,
sum(case when city='Delhi' then salary end)as "Delhi",
sum(case when city='Mumbai' then salary end)as "Mumbai",
sum(case when city='Banglore' then salary end)as "Banglore"
from employes
group by id,name;

# fetch users login consicutively more then 3 or more time
select * from(
select *,
case when name=lead(name) over(order by id) and
name=lead(name,2) over(order by id) 
then name 
else null
end as repeated
from login_details) x
where x.repeated is not null;

