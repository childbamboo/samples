- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■問題文
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Salaries
(emp_name CHAR(10) NOT NULL,
 sal_date DATE NOT NULL,
 sal_amt DECIMAL(8,2) NOT NULL,
 PRIMARY KEY (emp_name, sal_date));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO Salaries
VALUES ('Tom',   '1996-06-20', 500.00),
       ('Tom',   '1996-08-20', 700.00),
       ('Tom',   '1996-10-20', 800.00),
       ('Tom',   '1996-12-20', 900.00),
       ('Dick',  '1996-06-20', 500.00),
       ('Harry', '1996-07-20', 500.00),
       ('Harry', '1996-09-20', 700.00);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE VIEW Salaries2 (emp_name, sal_date, sal_amt)
AS SELECT S0.emp_name, S0.sal_date, MAX(S0.sal_amt)
     FROM Salaries AS S0, Salaries AS S1
    WHERE S0.sal_date <= S1.sal_date
      AND S0.emp_name = S1.emp_name
    GROUP BY S0.emp_name, S0.sal_date
   HAVING COUNT(*) <= 2;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT S0.emp_name, S0.sal_date, S0.sal_amt, S1.sal_date,
       S1.sal_amt
  FROM Salaries AS S0, Salaries AS S1
 WHERE S0.emp_name = S1.emp_name
   AND S0.sal_date =
            (SELECT MAX(S2.sal_date)
               FROM Salaries AS S2
              WHERE S0.emp_name = S2.emp_name)
   AND S1.sal_date =
            (SELECT MAX(S3.sal_date)
               FROM Salaries AS S3
              WHERE S0.emp_name = S3.emp_name
                AND S3.sal_date < S0.sal_date)
UNION ALL
SELECT S4.emp_name, MAX(S4.sal_date), MAX(S4.sal_amt),
       NULL, NULL
  FROM Salaries AS S4
 GROUP BY S4.emp_name
HAVING COUNT(*) = 1;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその3
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT B.emp_name, B.maxdate, Y.sal_amt, B.maxdate2, Z.sal_amt
  FROM (SELECT A.emp_name, A.maxdate, MAX(X.sal_date) AS maxdate2
          FROM (SELECT W.emp_name, MAX(W.sal_date) AS maxdate
                  FROM Salaries AS W
                 GROUP BY W.emp_name) AS A
            LEFT OUTER JOIN Salaries AS X
              ON A.emp_name = X.emp_name
             AND A.maxdate > X.sal_date
         GROUP BY A.emp_name, A.maxdate) AS B
     LEFT OUTER JOIN Salaries AS Y
         ON B.emp_name = Y.emp_name AND B.maxdate = Y.sal_date
     LEFT OUTER JOIN Salaries AS Z
         ON B.emp_name = Z.emp_name AND B.maxdate2 = Z.sal_date;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその4
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT S1.emp_name, S1.sal_date, S1.sal_amt, S2.sal_date,
       S2.sal_amt
  FROM Salaries2 AS S1, salaries2 AS S2 -- ビューを使う
 WHERE S1.emp_name = S2.emp_name
   AND S1.sal_date > S2.sal_date
UNION ALL
SELECT emp_name, MAX(sal_date), MAX(sal_amt), NULL, NULL
  FROM Salaries2
 GROUP BY emp_name
HAVING COUNT(*) = 1;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその5
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT S1.emp_name, S1.sal_date AS curr_date,
       S1.sal_amt AS curr_amt,
       CASE WHEN S2.sal_date <> S1.sal_date
            THEN S2.sal_date END AS prev_date,
       CASE WHEN S2.sal_date <> S1.sal_date
            THEN S2.sal_amt  END AS prev_amt
  FROM Salaries AS S1 INNER JOIN Salaries AS S2
    ON S2.emp_name = S1.emp_name
   AND S2.sal_date =
         COALESCE((SELECT MAX(S4.sal_date)
                     FROM Salaries AS S4
                    WHERE S4.emp_name = S1.emp_name
                      AND S4.sal_date < S1.sal_date),
                  S2.sal_date)
 WHERE NOT EXISTS(SELECT *
                    FROM Salaries AS S3
                   WHERE S3.emp_name = S1.emp_name
                     AND S3.sal_date > S1.sal_date);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその6
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE VIEW SalaryHistory
(emp_name, curr_date, curr_amt, prev_date, prev_amt)
AS SELECT S0.emp_name,
          S0.sal_date AS curr_date,
          S0.sal_amt AS curr_amt,
          S1.sal_date AS prev_date,
          S1.sal_amt AS prev_amt
     FROM Salaries AS S0
          LEFT OUTER JOIN Salaries AS S1
            ON S0.emp_name = S1.emp_name
           AND S0.sal_date > S1.sal_date;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT S0.emp_name,S0.curr_date, S0.curr_amt,
       S0.prev_date, S0.prev_amt
  FROM SalaryHistory AS S0
 WHERE S0.curr_date
          = (SELECT MAX(curr_date)
               FROM SalaryHistory AS S1
              WHERE S0.emp_name = S1.emp_name)
   AND (S0.prev_date = (SELECT MAX(prev_date)
                          FROM SalaryHistory AS S2
                         WHERE S0.emp_name = S2.emp_name)
                            OR S0.prev_date IS NULL);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその7
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

WITH salaryRanks(emp_name, sal_date, sal_amt, pos)
AS (SELECT emp_name, sal_date, sal_amt,
           RANK() OVER (PARTITION BY emp_name
                            ORDER BY sal_date DESC)
      FROM Salaries)
SELECT C.emp_name, C.sal_date AS curr_date,
       C.sal_amt AS curr_amt,
       P.sal_date AS prev_date, P.sal_amt AS prev_amt
  FROM SalaryRanks AS C LEFT OUTER JOIN SalaryRanks AS P
    ON P.emp_name = C.emp_name
   AND P.pos = 2 WHERE C.pos = 1;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその8
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT S1.emp_name,
       MAX(CASE WHEN rn = 1 THEN sal_date ELSE NULL END)
         AS curr_date,
       MAX(CASE WHEN rn = 1 THEN sal_amt ELSE NULL END)
         AS curr_amt,
       MAX(CASE WHEN rn = 2 THEN sal_date ELSE NULL END)
         AS prev_date,
       MAX(CASE WHEN rn = 2 THEN sal_amt ELSE NULL END)
         AS prev_amt
  FROM (SELECT emp_name, sal_date, sal_amt,
               RANK() OVER (PARTITION BY emp_name
                            ORDER BY sal_date DESC)
          FROM Salaries) AS S1 (emp_name, sal_date, sal_amt, rn)
 WHERE rn < 3
 GROUP BY S1.emp_name;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその9
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

WITH CTE (emp_name, sal_date, sal_amt, rn)
AS (SELECT emp_name, sal_date, sal_amt ,
           ROW_NUMBER() OVER (PARTITION BY emp_name
                              ORDER BY sal_date DESC) AS rn
                              --行に連番を付与する
      FROM Salaries)
SELECT O.emp_name,
       O.sal_date AS curr_date, O.sal_amt AS curr_amt,
       I.sal_date AS prev_date, I.sal_amt AS prev_amt
  FROM CTE AS O LEFT OUTER JOIN CTE AS I
    ON O.emp_name = I.emp_name
   AND I.rn = 2
 WHERE O.rn = 1;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT emp_name, curr_date, curr_amt, prev_date, prev_amt
  FROM (SELECT emp_name, sal_date AS curr_date,
               sal_amt AS curr_amt,
               MIN(sal_date) OVER (PARTITION BY emp_name
                                   ORDER BY sal_date DESC
                                   ROWS BETWEEN 1 FOLLOWING
                                   AND 1 FOLLOWING) AS prev_date,
               MIN(sal_amt)  OVER (PARTITION BY emp_name
                                   ORDER BY sal_date DESC
                                   ROWS BETWEEN 1 FOLLOWING
                                   AND 1 FOLLOWING) AS prev_amt,
               ROW_NUMBER() OVER (PARTITION BY emp_name
                                  ORDER BY sal_date DESC) AS rn
          FROM Salaries) AS DT
  WHERE rn = 1;



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.060 - 068, Copyright Elsevier 2006.
