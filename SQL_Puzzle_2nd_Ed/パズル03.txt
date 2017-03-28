- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE VIEW Events
(proc_id, comparison_proc, anest_name, event_time, event_type) AS
SELECT P1.proc_id, P2.proc_id, P1.anest_name, P2.start_time, +1
  FROM Procs AS P1, Procs AS P2
 WHERE P1.anest_name = P2.anest_name
   AND NOT (P2.end_time <= P1.start_time
              OR P2.start_time >= P1.end_time)
UNION
SELECT P1.proc_id, P2.proc_id, P1.anest_name, P2.end_time,
       -1 AS event_type
  FROM Procs AS P1, Procs AS P2
 WHERE P1.anest_name = P2.anest_name
   AND NOT (P2.end_time <= P1.start_time
              OR P2.start_time >= P1.end_time);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT E1.proc_id, E1.event_time,
      (SELECT SUM(E2.event_type)
         FROM Events AS E2
        WHERE E2.proc_id = E1.proc_id
          AND E2.event_time < E1.event_time)
       AS instantaneous_count
  FROM Events AS E1
 ORDER BY E1.proc_id, E1.event_time;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT proc_id, MAX(instantaneous_count) AS max_inst
  FROM ConcurrentProcs
 GROUP BY proc_id;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT E1.proc_id,
       MAX((SELECT SUM(E2.event_type)
              FROM Events AS E2
             WHERE E2.proc_id = E1.proc_id
               AND E2.event_time < E1.event_time))
       AS max_inst_count
  FROM Events AS E1
 GROUP BY E1.proc_id;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT P3.proc_id, MAX(ConcurrentProcs.tally)
  FROM (SELECT P1.anest_name, P1.start_time, COUNT(*)
          FROM Procs AS P1 INNER JOIN Procs AS P2
            ON P1.anest_name = P2.anest_name
           AND P2.start_time <= P1.start_time
           AND P2.end_time > P1.start_time
         GROUP BY P1.anest_name, P1.start_time)
       AS ConcurrentProcs(anest_name, start_time, tally)
       INNER JOIN Procs AS P3
               ON ConcurrentProcs.anest_name = P3.anest_name
              AND P3.start_time <= ConcurrentProcs.start_time
              AND P3.end_time > ConcurrentProcs.start_time
 GROUP BY P3.proc_id;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ3
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE VIEW Vprocs (id1, id2, total) AS
SELECT P1.proc_id, P2.proc_id, COUNT(*)
  FROM Procs AS P1, Procs AS P2, Procs AS P3
 WHERE P2.anest_name = P1.anest_name
   AND P3.anest_name = P1.anest_name
   AND P1.start_time <= P2.start_time
   AND P2.start_time < P1.end_time
   AND P3.start_time <= P2.start_time
   AND P2.start_time < P3.end_time
 GROUP BY P1.proc_id, P2.proc_id;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT id1 AS proc_id, MAX(total) AS max_inst_count
  FROM Vprocs
 GROUP BY id1;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ4
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT P1.proc_id, P1.anest_name, MAX(E1.ecount) AS maxops
  FROM Procs AS P1, -- E1ÇÕäeñÉêåà„ÇÃèàíuÇÃèuä‘ä|ÇØéùÇøêî
       (SELECT P2.anest_name, P2.start_time, COUNT(*)
          FROM Procs AS P1, Procs AS P2
         WHERE P1.anest_name = P2.anest_name
           AND P1.start_time <= P2.start_time
           AND P1.end_time > P2.start_time
         GROUP BY P2.anest_name, P2.start_time)
         AS E1(anest_name, etime, ecount)
 WHERE E1.anest_name = P1.anest_name
   AND E1.etime >= P1.start_time
   AND E1.etime <  P1.end_time
 GROUP BY P1.proc_id, P1.anest_name;


- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ5
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT X.anest_name, MAX(X.proc_tally)
  FROM (SELECT P1.anest_name, COUNT(DISTINCT proc_id)
          FROM Procs AS P1, Clock AS C
         WHERE C.clock_time BETWEEN P1.start_time AND P1.end_time
         GROUP BY P1.anest_name) AS X(anest_name, proc_tally)
 GROUP BY X.anest_name;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE VIEW TodayClock (clock_time)
AS SELECT CURRENT_DATE + ticks FROM DayTicks;



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.009 - 015, Copyright Elsevier 2006.
