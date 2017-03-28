- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■問題文
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Projects
(workorder_id CHAR(5) NOT NULL,
 step_nbr INTEGER NOT NULL
     CHECK (step_nbr BETWEEN 0 AND 1000),
 step_status CHAR(1) NOT NULL
     CHECK (step_status IN ('C', 'W')), -- Cは完了、Wは待機
 PRIMARY KEY (workorder_id, step_nbr));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT workorder_id
  FROM Projects AS P1
 WHERE step_nbr = 0
   AND step_status = 'C'
   AND 'W' = ALL (SELECT step_status
                    FROM Projects AS P2
                   WHERE step_nbr <> 0
                     AND P1.workorder_id = P2.workorder_id);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT workorder_id
  FROM Projects
 GROUP BY workorder_id
HAVING SUM(CASE WHEN step_nbr <> 0 AND step_status = 'W' THEN 1
                WHEN step_nbr = 0  AND step_status = 'C' THEN 1
                ELSE 0 END) = COUNT(step_nbr);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT workorder_id
  FROM Projects AS P1
 GROUP BY workorder_id
HAVING SUM(SIGN(step_nbr) * POSITION('W' IN step_status)
        + (1 - SIGN(step_nbr)) * POSITION('C' IN step_status))
       = COUNT(step_nbr);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその3
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT workorder_id
  FROM Projects
 GROUP BY workorder_id
HAVING COUNT(*)     -- あるworkorder_idについての全行数
        = COUNT(CASE WHEN step_nbr = 0 AND step_status = 'C'
                     THEN 1
                     ELSE NULL END)  -- 0番で「完了」の行数
        + COUNT(CASE WHEN step_nbr <> 0 AND step_status = 'W'
                     THEN 1
                     ELSE NULL END); -- 0番以外で「待機」の行数

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT workorder_id
  FROM Projects
 WHERE step_status = 'C'
 GROUP BY workorder_id
HAVING SUM(step_nbr) = 0;



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.045 - 047, Copyright Elsevier 2006.
