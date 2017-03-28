- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ñ‚ëËï∂
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Register
(course_nbr INTEGER NOT NULL,
 student_name CHAR(10) NOT NULL,
 teacher_name CHAR(10) NOT NULL,
 ...);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT R1.course_nbr, R1.student_name, MIN(R1.teacher_name), NULL
  FROM Register AS R1
 GROUP BY R1.course_nbr, R1.student_name
HAVING COUNT(*) = 1
UNION
SELECT R1.course_nbr, R1.student_name,
       MIN(R1.teacher_name), MAX(R1.teacher_name)
  FROM Register AS R1
 GROUP BY R1.course_nbr, R1.student_name
HAVING COUNT(*) = 2
UNION
SELECT R1.course_nbr, R1.student_name,
       MIN(R1.teacher_name), '--More--'
  FROM Register AS R1
 GROUP BY R1.course_nbr, R1.student_name
HAVING COUNT(*) > 2;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT course_nbr, student_name, MIN(teacher_name),
       CASE COUNT(*) WHEN 1 THEN NULL
                     WHEN 2 THEN MAX(teacher_name)
                     ELSE '--More--' END
  FROM Register
 GROUP BY course_nbr, student_name;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CASE WHEN COUNT(*) = 1 THEN NULL
     WHEN COUNT(*) = 2 THEN MAX(teacher_name)
     ELSE '--More--'
END

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ3
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT CASE WHEN teacher_name
              = (SELECT MIN(teacher_name)
                   FROM Register AS R1
                  WHERE R1.course_nbr = R0.course_nbr
                    AND R1.student_name = R0.student_name)
            THEN course_nbr
            ELSE NULL END AS course_nbr_hdr,
       CASE WHEN teacher_name
              = (SELECT MIN(teacher_name)
                   FROM Register AS R1
                  WHERE R1.course_nbr = R0.course_nbr
                    AND R1.student_name = R0.student_name)
            THEN student_name
            ELSE NULL END AS student_name_hdr,
       teacher_name
  FROM Register AS R0
 ORDER BY course_nbr, student_name, teacher_name;



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.053 - 055, Copyright Elsevier 2006.
