- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
¡–â‘è•¶
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Absenteeism
(emp_id INTEGER NOT NULL REFERENCES Personnel (emp_id),
 absent_date DATE NOT NULL,
 reason_code CHAR(40) NOT NULL
             REFERENCES ExcuseList (reason_code),
 severity_points INTEGER NOT NULL
             CHECK (severity_points BETWEEN 1 AND 4),
 PRIMARY KEY (emp_id, absent_date));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
¡“š‚¦‚»‚Ì1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

UPDATE Absenteeism
   SET severity_points= 0,
       reason_code = 'long term illness'
 WHERE EXISTS
   (SELECT *
      FROM Absenteeism AS A2
     WHERE Absenteeism.emp_id = A2.emp_id
       AND Absenteeism.absent_date =
           (A2.absent_date + INTERVAL '1' DAY));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT emp_id, SUM(severity_points)
  FROM Absenteeism
 GROUP BY emp_id;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DELETE FROM Personnel
  WHERE emp_id =
    (SELECT A1.emp_id
       FROM Absenteeism AS A1
      WHERE A1.emp_id = Personnel.emp_id
      GROUP BY A1.emp_id
     HAVING SUM(severity_points) >= 40);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
¡“š‚¦‚»‚Ì2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DELETE FROM Personnel
 WHERE emp_id =
   (SELECT A1.emp_id
      FROM Absenteeism AS A1
     WHERE A1.emp_id = Personnel.emp_id
       AND absent_date
           BETWEEN CURRENT_TIMESTAMP - INTERVAL '365' DAY
               AND CURRENT_TIMESTAMP
     GROUP BY A1.emp_id
    HAVING SUM(severity_points) >= 40);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Absenteeism
(emp_id INTEGER NOT NULL
        REFERENCES Personnel (emp_id)
        ON DELETE CASCADE,
 ...);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

UPDATE Absenteeism AS A1
   SET severity_points = 0,
       reason_code = 'long term illness'
 WHERE EXISTS
   (SELECT *
      FROM Absenteeism AS A2
     WHERE A1.emp_id = A2.emp_id
       AND (A2.absent_date + INTERVAL '1' DAY) = A1.absent_date);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT A.emp_id,
       SUM(A.severity_points) AS absentism_score
  FROM Absenteeism AS A, Calendar AS C
 WHERE C.cal_date = A.absent_date
   AND A.absent_date
       BETWEEN CURRENT_TIMESTAMP - INTERVAL '365' DAY
           AND CURRENT_TIMESTAMP
   AND C.date_type = 'work'
 GROUP BY emp_id
HAVING SUM(severity_points) >= 40;



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.004 - 008, Copyright Elsevier 2006.
