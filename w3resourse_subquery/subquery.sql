--#1

SELECT *
FROM [W3Resource].[Inventory].[Orders]
where salesman_id = (SELECT salesman_id
FROM [W3Resource].[Inventory].[Salesman]
where name = 'Paul Adam')

--2

SELECT *
FROM [W3Resource].[Inventory].[Orders]
where salesman_id = (SELECT salesman_id
FROM [W3Resource].[Inventory].[Salesman]
where city = 'London')


--3
SELECT *
FROM [W3Resource].[Inventory].[Orders]
where customer_id = (SELECT customer_id
FROM [W3Resource].[Inventory].[Orders]
where customer_id = 3007)

--4


SELECT *
FROM [W3Resource].[Inventory].[Orders]
where purch_amt >
(SELECT avg(purch_amt)
FROM [W3Resource].[Inventory].[Orders]
where ord_date = '2012-10-10')


--5

SELECT *
FROM [W3Resource].[Inventory].[Orders]
where salesman_id = (SELECT salesman_id
FROM [W3Resource].[Inventory].[Salesman]
where city = 'New York')


--6
SELECT commission
  FROM [W3Resource].[Inventory].[Salesman]
where salesman_id = (select salesman_id 
from [W3Resource].[Inventory].[Customer]
where city = 'Paris')



--7

select * from [W3Resource].[Inventory].[Customer]
where customer_id = (SELECT salesman_id - 2001
  FROM [W3Resource].[Inventory].[Salesman]
where name = 'Mc Lyon')

--8

select grade, count(*) as count from [W3Resource].[Inventory].[Customer]
group by grade
having grade > (
SELECT avg(grade)
FROM [W3Resource].[Inventory].[Customer]
where city = 'New York')

--9

SELECT *
FROM [W3Resource].[Inventory].[Orders]
where salesman_id = (SELECT salesman_id
FROM [W3Resource].[Inventory].[Salesman]
where commission = (select max(commission) from [W3Resource].[Inventory].[Salesman])
)

--10
SELECT O.*, C.cust_name
FROM [W3Resource].[Inventory].[Orders] as O, [W3Resource].[Inventory].[Customer] as C
where O.customer_id = C.customer_id and O.ord_date = '2012-08-17'

--11

SELECT salesman_id, name
  FROM [W3Resource].[Inventory].[Salesman]
where salesman_id in (
SELECT salesman_id
FROM [W3Resource].[Inventory].[Customer]
group by salesman_id
having count(salesman_id) = 2)


--12

SELECT *
  FROM [W3Resource].[Inventory].[Orders] as O1
  where purch_amt > (SELECT avg(purch_amt)
  FROM [W3Resource].[Inventory].[Orders] as O2
  where O1.customer_id = O2.customer_id)


--13

SELECT *
  FROM [W3Resource].[Inventory].[Orders] as O1
  where purch_amt >= (SELECT avg(purch_amt)
  FROM [W3Resource].[Inventory].[Orders] as O2
  where O1.customer_id = O2.customer_id)


--14
SELECT sum(purch_amt) as sum_purch_amt, ord_date
  FROM [W3Resource].[Inventory].[Orders] as O1
group by ord_date
having sum(purch_amt) >= (SELECT max(purch_amt)+1000
  FROM [W3Resource].[Inventory].[Orders] as O2
  where O1.ord_date = O2.ord_date)


--15

select * from [W3Resource].[Inventory].[Customer]
where exists (
SELECT count(customer_id)
FROM [W3Resource].[Inventory].[Customer]
where city = 'London'
having count(customer_id) >=1)


--16
SELECT *
  FROM [W3Resource].[Inventory].[Salesman]
where salesman_id in (
SELECT salesman_id
FROM [W3Resource].[Inventory].[Customer]
group by salesman_id
having count(salesman_id) > 1)


--17
SELECT *
  FROM [W3Resource].[Inventory].[Salesman]
where salesman_id in (
SELECT salesman_id
FROM [W3Resource].[Inventory].[Customer]
group by salesman_id
having count(salesman_id) = 1)

--18
SELECT *
  FROM [W3Resource].[Inventory].[Salesman]
where salesman_id in (
SELECT salesman_id
  FROM [W3Resource].[Inventory].[Orders]
group by customer_id, salesman_id
having count(customer_id) > 1)



--19
SELECT *
  FROM [W3Resource].[Inventory].[Salesman]
where city = ANY
(SELECT city
FROM [W3Resource].[Inventory].[Customer])

--20
SELECT *
  FROM [W3Resource].[Inventory].[Salesman]
where city in
(SELECT city
FROM [W3Resource].[Inventory].[Customer])

--21
SELECT *
  FROM [W3Resource].[Inventory].[Salesman] as S
where exists
(SELECT *
FROM [W3Resource].[Inventory].[Customer] as C
where S.name < C.cust_name)


--22

SELECT *
  FROM [W3Resource].[Inventory].[Customer]
where grade > Any
(select grade from [W3Resource].[Inventory].[Customer] where city < 'New York')



--23

SELECT *
  FROM [W3Resource].[Inventory].[Orders]
where purch_amt > Any 
(select purch_amt from 
[W3Resource].[Inventory].[Orders]
where ord_date = '2012-09-10')


--24
SELECT *
  FROM [W3Resource].[Inventory].[Orders]
where purch_amt < Any 
(select purch_amt from 
[W3Resource].[Inventory].[Customer] as C, [W3Resource].[Inventory].[Orders] as O
where city = 'London' and O.customer_id = C.customer_id)


--25

SELECT *
  FROM [W3Resource].[Inventory].[Orders]
where purch_amt <  
(select max(purch_amt) from 
[W3Resource].[Inventory].[Customer] as C, [W3Resource].[Inventory].[Orders] as O
where city = 'London' and O.customer_id = C.customer_id)


--26

SELECT *
FROM [W3Resource].[Inventory].[Customer]
where grade > all (SELECT grade
FROM [W3Resource].[Inventory].[Customer]
where city = 'New York')


--27
SELECT salesman_id, sum(purch_amt) as total_amt
  FROM [W3Resource].[Inventory].[Orders]
where salesman_id = any (SELECT salesman_id
  FROM [W3Resource].[Inventory].[Salesman]
  )
group by salesman_id


--28
SELECT *
FROM [W3Resource].[Inventory].[Customer]
where grade != any (SELECT grade
FROM [W3Resource].[Inventory].[Customer]
where city = 'London')


--29
SELECT *
FROM [W3Resource].[Inventory].[Customer]
where grade != (SELECT grade
FROM [W3Resource].[Inventory].[Customer]
where city = 'Paris')


--30
SELECT *
FROM [W3Resource].[Inventory].[Customer]
where grade not in (SELECT grade
FROM [W3Resource].[Inventory].[Customer]
where city = 'Dallas')


--31

SELECT COM_NAME, avg(pro_price) as avg_pro_price
FROM [W3Resource].[dbo].[item_mast] as I, [W3Resource].[dbo].[company_mast] as C
where I.pro_com = C.COM_ID
group by C.COM_NAME


--32

SELECT COM_NAME, avg(pro_price) as avg_pro_price
FROM [W3Resource].[dbo].[item_mast] as I, [W3Resource].[dbo].[company_mast] as C
where I.pro_com = C.COM_ID
group by C.COM_NAME
having avg(pro_price) >= 350


--33



SELECT COM_NAME, pro_name, pro_price
FROM [W3Resource].[dbo].[item_mast] as I, [W3Resource].[dbo].[company_mast] as C
where I.pro_com = C.COM_ID and pro_price = (
select max(pro_price) 
from [W3Resource].[dbo].[item_mast] as I
where I.pro_com = C.COM_ID)


--34
SELECT *
FROM [W3Resource].[Employee].[emp_details]
where  EMP_LNAME in ('Gabriel','Dosio')

--35
SELECT *
FROM [W3Resource].[Employee].[emp_details]
where EMP_DEPT  in (89, 63)


--36

SELECT DET.EMP_FNAME, DET.EMP_LNAME
FROM [W3Resource].[Employee].[emp_department] as DEP, [W3Resource].[Employee].[emp_details] as DET
where DEP.DPT_ALLOTMENT > 50000 and DEP.DPT_CODE = DET.EMP_DEPT


--37

SELECT *
  FROM [W3Resource].[Employee].[emp_department]
where DPT_ALLOTMENT > (SELECT avg(DPT_ALLOTMENT)
  FROM [W3Resource].[Employee].[emp_department])


--38

SELECT DPT_NAME
  FROM [W3Resource].[Employee].[emp_department] 
 where dpt_code in
(select EMP_DEPT
from [W3Resource].[Employee].[emp_details] 
group by EMP_DEPT
having count(emp_idno) > 2) 

--39


select EMP_FNAME, EMP_LNAME
from [W3Resource].[Employee].[emp_details] 
where EMP_DEPT in (SELECT top(1) DPT_CODE
  FROM [W3Resource].[Employee].[emp_department]
where dpt_allotment > (
SELECT min(dpt_allotment)
  FROM [W3Resource].[Employee].[emp_department])
order by DPT_ALLOTMENT desc)
  
