- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ñ‚ëËï∂
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE TestResults
(test_name CHAR(20) NOT NULL,
 test_step INTEGER NOT NULL,
 comp_date DATE,               -- NULLÇÕñ¢äÆóπÇà”ñ°Ç∑ÇÈ
 PRIMARY KEY (test_name, test_step));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT DISTINCT test_name
  FROM TestResults AS T1
 WHERE NOT EXISTS (SELECT *
                     FROM TestResults AS T2
                    WHERE T1.test_name = T2.test_name
                      AND T2.comp_date IS NULL);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT test_name
  FROM TestResults
 GROUP BY test_name
HAVING COUNT(*) = COUNT(comp_date);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT test_name,
       COUNT(*) AS test_steps_needed ,
      (COUNT(*) - COUNT(comp_date)) AS test_steps_missing
  FROM TestResults
 GROUP BY test_name
HAVING COUNT(*) <> COUNT(comp_date);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT DISTINCT test_name
  FROM TestResults
 WHERE comp_date IS NULL;



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.086 - 087, Copyright Elsevier 2006.
