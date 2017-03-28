- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
¡–â‘è•¶
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Titles
(product_id INTEGER NOT NULL PRIMARY KEY,
 magazine_sku INTEGER NOT NULL,
 issn INTEGER NOT NULL,
 issn_year INTEGER NOT NULL);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Newsstands
 (stand_nbr INTEGER NOT NULL PRIMARY KEY,
  stand_name CHAR(20) NOT NULL);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Sales
(product_id   INTEGER NOT NULL REFERENCES Titles(product_id),
 stand_nbr    INTEGER NOT NULL REFERENCES Newsstands(stand_nbr),
 net_sold_qty INTEGER NOT NULL,
 PRIMARY KEY(product_id, stand_nbr));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
¡“š‚¦‚»‚Ì1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE VIEW MagazineSales(stand_name, magazine_sku, net_sold_qty)
AS SELECT Newsstands.stand_name, Titles.magazine_sku,
          net_sold_qty
     FROM Titles, Sales, Newsstands
    WHERE Sales.stand_nbr   = Newsstands.stand_nbr
      AND Titles.product_id = Sales.product_id;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT stand_name
  FROM MagazineSales AS M0
 GROUP BY stand_name
HAVING -- ğŒ‚ğ–‚½‚·2‚Â
     ((SELECT AVG(net_sold_qty)
         FROM MagazineSales AS M1
        WHERE M1.stand_name = M0.stand_name
          AND magazine_sku = 1107) > 5)
  OR ((SELECT AVG(net_sold_qty)
         FROM MagazineSales AS M2
        WHERE M2.stand_name = M0.stand_name
          AND magazine_sku IN (2667, 48632)) > 2)
 AND NOT -- ğŒ‚ğ–‚½‚³‚È‚¢2‚Â
     ((SELECT AVG(net_sold_qty)
         FROM MagazineSales AS M3
        WHERE M3.stand_name = M0.stand_name
          AND magazine_sku = 2667) < 2
      OR
      (SELECT AVG(net_sold_qty)
         FROM MagazineSales AS M4
        WHERE M4.stand_name = M0.stand_name
          AND magazine_sku = 48632) < 2);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
¡“š‚¦‚»‚Ì2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE VIEW MagazineSales
(stand_nbr, magazine_sku, avg_qty_sold)
 AS SELECT Sales.stand_nbr, Titles.magazine_sku,
           AVG(Sales.net_sold_qty)
      FROM Titles, Newsstands, Sales
     WHERE Titles.product_id = Sales.product_id
       AND Newsstands.stand_nbr = Sales.stand_nbr
       AND Titles.magazine_sku IN (1107, 2667, 48632)
     GROUP BY Sales.stand_nbr, Titles.magazine_sku;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT DISTINCT N0.stand_name
  FROM MagazineSales AS M0, Newsstands AS N0
 WHERE N0.stand_nbr = M0.stand_nbr
   AND ((M0.magazine_sku = 1107 AND M0.avg_qty_sold > 5)
        OR (M0.magazine_sku = 2667 AND M0.avg_qty_sold > 2
            AND EXISTS (SELECT *
                          FROM MagazineSales AS Other
                         WHERE Other.magazine_sku = 48632
                           AND Other.stand_nbr = M0.stand_nbr
                           AND Other.avg_qty_sold > 2)));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
¡“š‚¦‚»‚Ì3
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE INDEX Titles_magazine_sku
ON Titles (magazine_sku, product_id);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT DISTINCT N1.stand_name
  FROM Newsstands AS N1
 WHERE N1.stand_nbr IN (SELECT S1.stand_nbr
                          FROM Sales AS S1
                         WHERE S1.product_id IN
                           (SELECT T1.product_id
                              FROM Titles AS T1
                             WHERE magazine_sku = 1107)
                         GROUP BY S1.stand_nbr
                        HAVING AVG(S1.net_sold_qty) > 5)
    OR (N1.stand_nbr IN (SELECT S1.stand_nbr
                           FROM Sales AS S1
                          WHERE S1.product_id IN
                                (SELECT T1.product_id
                                   FROM Titles AS T1
                                  WHERE magazine_sku = 2667)
                          GROUP BY S1.stand_nbr
                         HAVING AVG(S1.net_sold_qty) > 2)
        AND N1.stand_nbr IN (SELECT S1.stand_nbr
                               FROM Sales AS S1
                              WHERE S1.product_id IN
                                (SELECT T1.product_id
                                   FROM Titles AS T1
                                  WHERE magazine_sku = 48632)
                              GROUP BY S1.stand_nbr
                             HAVING AVG(S1.net_sold_qty) > 2));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
¡“š‚¦‚»‚Ì4
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT N1.stand_name
  FROM Sales AS S1, Titles AS T1, Newsstands AS N1
 WHERE T1.magazine_sku IN (2667, 48632, 1107)
   AND S1.product_id = T1.product_id
   AND S1.stand_nbr = N1.stand_nbr
 GROUP BY N1.stand_name
HAVING (AVG(CASE WHEN T1.magazine_sku = 2667
                 THEN S1.net_sold_qty ELSE NULL END) > 2
        AND AVG(CASE WHEN T1.magazine_sku  = 48632
                     THEN S1.net_sold_qty ELSE NULL END) > 2)
    OR AVG(CASE WHEN T1.magazine_sku  = 1107
                THEN S1.net_sold_qty ELSE NULL END) > 5;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
¡“š‚¦‚»‚Ì5
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT stand_name
  FROM (SELECT N1.stand_name
          FROM Sales AS S1
               INNER JOIN Titles AS T1
               ON S1.product_id = T1.product_id
                  INNER JOIN Newsstands AS N1
                  ON S1.stand_nbr = N1.stand_nbr
         WHERE T1.magazine_sku IN (2667, 48632, 1107)
         GROUP BY N1.stand_nbr, N1.stand_name
        HAVING (AVG(CASE WHEN T1.magazine_sku = 2667
                         THEN S1.net_sold_qty ELSE NULL END) > 2
           AND AVG(CASE WHEN T1.magazine_sku = 48632
                        THEN S1.net_sold_qty ELSE NULL END) > 2)
            OR AVG(CASE WHEN T1.magazine_sku = 1107
                        THEN S1.net_sold_qty ELSE NULL END) > 5);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
¡“š‚¦‚»‚Ì6
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT stand_name
  FROM Newsstands AS N1
 WHERE 1 =
   ANY ((SELECT SIGN(AVG(net_sold_qty) - 2)
           FROM Sales AS S1
          WHERE product_id IN (SELECT product_id
                                 FROM Titles
                                WHERE magazine_sku = 2667)
                    AND S1.stand_nbr = N1.stand_nbr
         INTERSECT
         SELECT SIGN(AVG(net_sold_qty) - 2)
           FROM Sales AS S2
          WHERE product_id IN (SELECT product_id
                                 FROM Titles
                                WHERE magazine_sku = 48632)
            AND S2.stand_nbr = N1.stand_nbr)
         UNION
         SELECT SIGN(AVG(net_sold_qty) - 5)
           FROM Sales AS S3
          WHERE product_id IN (SELECT product_id
                                 FROM Titles
                                WHERE magazine_sku = 1107)
            AND S3.stand_nbr = N1.stand_nbr);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
¡“š‚¦‚»‚Ì7
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT stand_nbr
  FROM (SELECT stand_nbr,
               AVG(CASE WHEN magazine_sku = 2667
                        THEN net_sold_qty END),
               AVG(CASE WHEN magazine_sku = 48632
                        THEN net_sold_qty END),
               AVG(CASE WHEN magazine_sku = 1107
                        THEN net_sold_qty END)
          FROM Sales, Titles
         WHERE Sales.product_id = Titles.product_id
         GROUP BY stand_nbr
        ) AS T (stand_nbr, avg_2667, avg_48632, avg_1107)
 WHERE avg_1107 > 5 OR (avg_2667 > 2 AND avg_48632 > 2);



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.094 - 102, Copyright Elsevier 2006.
