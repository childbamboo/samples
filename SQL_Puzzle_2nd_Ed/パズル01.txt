- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■問題文
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE FiscalYearTable1
(fiscal_year INTEGER,
 start_date  DATE,
 end_date    DATE);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(SELECT f1.fiscal_year
   FROM FiscalYearTable1 AS F1
  WHERE <任意の日付データ> BETWEEN F1.start_date AND F1.end_date)

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE FiscalYearTable1
(fiscal_year INTEGER NOT NULL PRIMARY KEY,
 start_date  DATE NOT NULL,
 CONSTRAINT valid_start_date
   CHECK ((EXTRACT(YEAR FROM start_date) = fiscal_year - 1)
           AND (EXTRACT(MONTH FROM start_date) = 10)
           AND (EXTRACT(DAY FROM start_date) = 01)),
 end_date DATE NOT NULL,
 CONSTRAINT valid_end_date
   CHECK ((EXTRACT(YEAR FROM end_date) = fiscal_year)
           AND (EXTRACT(MONTH FROM end_date) = 09)
           AND (EXTRACT(DAY FROM end_date) = 30)));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CHECK ((end_date - start_date) = INTERVAL '359' DAY)



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.001 - 003, Copyright Elsevier 2006.
