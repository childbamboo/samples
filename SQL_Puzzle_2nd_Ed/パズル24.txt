- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ñ‚ëËï∂
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE MyTable
(keycol INTEGER NOT NULL,
 f1 INTEGER NOT NULL,
 f2 INTEGER NOT NULL,
 f3 INTEGER NOT NULL,
 f4 INTEGER NOT NULL,
 f5 INTEGER NOT NULL,
 f6 INTEGER NOT NULL,
 f7 INTEGER NOT NULL,
 f8 INTEGER NOT NULL,
 f9 INTEGER NOT NULL,
 f10 INTEGER NOT NULL);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT *
  FROM MyTable
 WHERE SIGN(f1) + SIGN(f2) + ... + SIGN(f10) = 1;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CASE WHEN x <> 0 THEN 1 ELSE 0 END

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Foobar
(keycol INTEGER NOT NULL,
 i INTEGER NOT NULL CHECK (i BETWEEN 1 AND 10),
 f INTEGER NOT NULL,
 PRIMARY KEY (keycol, i));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT keycol
  FROM Foobar
 WHERE f = 0
 GROUP BY keycol
HAVING COUNT(*) = 9;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE VIEW Foobar (keycol, f)
AS SELECT keycol, f1
     FROM MyTable
    WHERE f1 <> 0
   UNION
   SELECT keycol, f2 FROM MyTable WHERE f2 <> 0
   UNION
    ...
   UNION
   SELECT keycol, f10 FROM MyTable WHERE f10 <> 0 ;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ3
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT *
  FROM MyTable
 WHERE (f1, f2, ... , f10) IN
          (VALUES (f1, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                  (0, f2, 0, 0, 0, 0, 0, 0, 0, 0),
                  ...
                  (0, 0, 0, 0, 0, 0, 0, 0, 0, f10))
   AND (f1 + f2 + ... f10) <> 0;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ4
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT *
  FROM MyTable
 WHERE 0 IN (VALUES (f2 + f3 + ... f10), -- f1Çî≤Ç≠
                    (f1 + f3 + ... f10), -- f2Çî≤Ç≠
                    ...
                    (f1 + f2 + ... f9))  -- f10Çî≤Ç≠
   AND (f1 + f2 + ... f10) <> 0;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ5
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT *
  FROM MyTable
 WHERE COALESCE(f1, f2, f3, f4, f5, f6, f7, f8, f9, f10)
       IS NOT NULL;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

COALESCE (NULLIF (f1, 0), NULLIF (f2, 0), ..., NULLIF (f10, 0))



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.103 - 106, Copyright Elsevier 2006.
