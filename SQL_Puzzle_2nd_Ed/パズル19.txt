- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ñ‚ëËï∂
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE SalesData
(district_nbr INTEGER NOT NULL,
 sales_person CHAR(10) NOT NULL,
 sales_id INTEGER NOT NULL,
 sales_amt DECIMAL(5,2) NOT NULL);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT S0.district_nbr, S0.sales_person,
       S0.sales_id, S0.sales_amt
  FROM SalesData AS S1, SalesData AS S0
 WHERE S0.district_nbr = S1.district_nbr
   AND S0.sales_amt <= S1.sales_amt
 GROUP BY S0.district_nbr, S0.sales_person, S0.sales_id,
          S0.sales_amt
HAVING COUNT(*) <= 3;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT S0.district_nbr, S0.sales_person
  FROM SalesData AS S1, SalesData AS S0
 WHERE S0.district_nbr = S1.district_nbr
   AND S0.sales_amt <= S1.sales_amt
 GROUP BY S0.district_nbr, S0.sales_person
HAVING COUNT(DISTINCT S1.sales_person) <= 3
 ORDER BY S0.district_nbr, S0.sales_person;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT DISTINCT S1.district_nbr, S1.sales_person
  FROM (SELECT district_nbr, sales_person,
               DENSE_RANK() OVER (PARTITION BY district_nbr
                                  ORDER BY sales_amt DESC)
          FROM SalesData) AS S1 (district_nbr, sales_person,
                                 rank_nbr)
 WHERE S1.rank_nbr <= 3;



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.082 - 085, Copyright Elsevier 2006.
