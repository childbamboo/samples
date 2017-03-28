- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Personnel
(emp_id INTEGER NOT NULL PRIMARY KEY,
 emp_name CHAR(30) NOT NULL,
 ...);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Badges
(badge_nbr INTEGER NOT NULL PRIMARY KEY,
 emp_id INTEGER NOT NULL REFERENCES Personnel(emp_id),
 issued_date DATE NOT NULL,
 badge_status CHAR(1) NOT NULL
   CHECK (badge_status IN ('A', 'I')),
 CHECK (1 <= ALL (SELECT COUNT(badge_status)
                    FROM Badges
                   WHERE badge_status = 'A'
                   GROUP BY emp_id)));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

UPDATE Badges
   SET badge_status = 'A'
 WHERE ('I' = ALL (SELECT badge_status
                     FROM Badges AS B1
                    WHERE Badges.emp_id = B1.emp_id))
   AND (issued_date = (SELECT MAX(issued_date)
                         FROM Badges AS B2
                        WHERE Badges.emp_id = B2.emp_id));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT P.emp_id, emp_name, badge_nbr
  FROM Personnel AS P, Badges AS B
 WHERE B.emp_id = P.emp_id
   AND B.badge_status = 'A';

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Badges
(badge_nbr INTEGER NOT NULL PRIMARY KEY,
 emp_id INTEGER NOT NULL REFERENCES Personnel(emp_id),
 issued_date DATE NOT NULL,
 badge_seq INTEGER NOT NULL CHECK (badge_seq > 0),
 UNIQUE (emp_id, badge_seq),
 ... );

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE VIEW ActiveBadges (emp_id, badge_nbr)
AS SELECT emp_id, badge_nbr
     FROM Badges AS B1
    WHERE badge_seq = (SELECT MAX(badge_seq)
                         FROM Badges AS B2
                        WHERE B1.emp_id = B2.emp_id);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

UPDATE Badges
   SET badge_seq = (SELECT COUNT(*)
                      FROM Badges AS B1
                     WHERE Badges.emp_id = B1.emp_id
                       AND Badges.badge_seq >= B1.badge_seq);



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.016 - 018, Copyright Elsevier 2006.
