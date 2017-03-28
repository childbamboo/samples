- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ñ‚ëËï∂
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE PilotSkills
 (pilot CHAR(15) NOT NULL,
  plane CHAR(15) NOT NULL,
  PRIMARY KEY (pilot, plane));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO PilotSkills
VALUES ('Celko', 'Piper Cub'),
       ('Higgins', 'B-52 Bomber'),
       ('Higgins', 'F-14 Fighter'),
       ('Higgins', 'Piper Cub'),
       ('Jones', 'B-52 Bomber'),
       ('Jones', 'F-14 Bomber'),
       ('Smith', 'B-1 Bomber'),
       ('Smith', 'B-52 Bomber'),
       ('Smith', 'F-14 Fighter'),
       ('Wilson', 'B-1 Bomber'),
       ('Wilson', 'B-52 Bomber'),
       ('Wilson', 'F-14 Fighter'),
       ('Wilson', 'F-17 Fighter');

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Hangar
 (plane CHAR(15) PRIMARY KEY);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO Hangar
VALUES ('B-1 Bomber'),
       ('B-52 Bomber'),
       ('F-14 Fighter');

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT DISTINCT pilot
  FROM PilotSkills AS PS1
 WHERE NOT EXISTS
          (SELECT *
             FROM Hangar
            WHERE NOT EXISTS
                     (SELECT *
                        FROM PilotSkills AS PS2
                       WHERE (PS1.pilot = PS2.pilot)
                         AND (PS2.plane = Hangar.plane)));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT Pilot
  FROM PilotSkills AS PS1, Hangar AS H1
 WHERE PS1.plane = H1.plane
 GROUP BY PS1.pilot
HAVING COUNT(PS1.plane) = (SELECT COUNT(*) FROM Hangar);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ3
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT PS1.pilot
  FROM PilotSkills AS PS1 LEFT OUTER JOIN Hangar AS H1
    ON PS1.plane = H1.plane
 GROUP BY PS1.pilot
HAVING COUNT(PS1.plane) = (SELECT COUNT(plane) FROM Hangar)
   AND COUNT(H1.plane)  = (SELECT COUNT(plane) FROM Hangar);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  HAVING COUNT(PS1.plane) = COUNT(H1.plane)



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.088 - 091, Copyright Elsevier 2006.
