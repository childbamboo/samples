- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ñ‚ëËï∂
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Personnel
(emp_id INTEGER PRIMARY KEY,
 first_name CHAR(20) NOT NULL,
 last_name CHAR(20) NOT NULL);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Phones
(emp_id INTEGER NOT NULL,
 phone_type CHAR(3) NOT NULL
    CHECK (phone_type IN ('hom', 'fax')),
 phone_nbr CHAR(12) NOT NULL,
 PRIMARY KEY (emp_id, phone_type),
 FOREIGN KEY (emp_id) REFERENCES Personnel(emp_id));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE VIEW HomePhones
(last_name, first_name, emp_id, home_phone)
AS SELECT E1.last_name, E1.first_name, E1.emp_id, H1.phone_nbr
     FROM (Personnel AS E1 LEFT OUTER JOIN Phones AS H1
             ON E1.emp_id = H1.emp_id
            AND H1.phone_type = 'hom');

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE VIEW FaxPhones (last_name, first_name, emp_id, fax_phone)
AS SELECT E1.last_name, E1.first_name, E1.emp_id, F1.phone_nbr
     FROM (Personnel AS E1 LEFT OUTER JOIN Phones AS F1
              ON E1.emp_id = F1.emp_id
             AND F1.phone_type = 'fax');

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT H1.last_name, H1.first_name, home_phone, fax_phone
  FROM HomePhones AS H1, FaxPhones AS F1
 WHERE H1.emp_id = F1.emp_id;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT COALESCE(H1.last_name, F1.last_name),
       COALESCE(H1.first_name, F1.first_name),
       home_phone, fax_phone
  FROM HomePhones AS H1 FULL OUTER JOIN FaxPhones AS F1
    ON H1.emp_id = F1.emp_id;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT E1.last_name, E1.first_name, H1.phone_nbr AS Home,
       F1.phone_nbr AS FAX
  FROM (Personnel AS E1 LEFT OUTER JOIN Phones AS H1
          ON E1.emp_id = H1.emp_id
         AND H1.phone_type = 'hom')
       LEFT OUTER JOIN Phones AS F1
            ON E1.emp_id = F1.emp_id
           AND F1.phone_type = 'fax';

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ3
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT E1.emp_id, E1.first_name, E1.last_name,
       MAX(CASE WHEN P1.phone_type = 'hom'
                THEN P1.phone_nbr
           ELSE NULL END) AS home_phone,
       MAX(CASE WHEN P1.phone_type = 'fax'
                THEN P1.phone_nbr
           ELSE NULL END) AS fax_phone
  FROM Personnel AS E1 LEFT OUTER JOIN Phones AS P1
    ON P1.emp_id = E1.emp_id
 GROUP BY E1.emp_id, E1.first_name, E1.last_name;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ4
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT P1.last_name, P1.first_name,
       (SELECT T1.phone_nbr
          FROM Phones AS T1
         WHERE T1.emp_id = P1.emp_id
           AND T1.phone_type = 'hom') AS home_phone,
       (SELECT T2.phone_nbr
          FROM Phones AS T2
         WHERE T2.emp_id = P1.emp_id
           AND T2.phone_type = 'fax') AS fax_phone
  FROM Personnel AS P1;



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.056 - 059, Copyright Elsevier 2006.
