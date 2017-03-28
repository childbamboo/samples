- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■問題文
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE CandidateSkills
(candidate_id INTEGER NOT NULL,
 skill_code CHAR(15) NOT NULL,
 PRIMARY KEY (candidate_id, skill_code));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO CandidateSkills
VALUES (100, 'accounting'),
       (100, 'inventory'),
       (100, 'manufacturing'),
       (200, 'accounting'),
       (200, 'inventory'),
       (300, 'manufacturing'),
       (400, 'inventory'),
       (400, 'manufacturing'),
       (500, 'accounting'),
       (500, 'manufacturing');

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT DISTINCT C1.candidate_id, 'job_id #212' -- 仕事IDコードの定数
  FROM CandidateSkills AS C1,            -- スキル1つにつき1テーブル
       CandidateSkills AS C2,
       CandidateSkills AS C3
 WHERE C1.candidate_id = C2.candidate_id
   AND C1.candidate_id = C3.candidate_id
   AND -- 以下で紹介依頼を表す式を作る
        (    C1.skill_code = 'manufacturing'
         AND C2.skill_code = 'inventory'
          OR C3.skill_code = 'accounting');

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE JobOrders
(job_id INTEGER NOT NULL,
 skill_group INTEGER NOT NULL,
 skill_code CHAR(15) NOT NULL,
 PRIMARY KEY (job_id, skill_group, skill_code));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

INSERT INTO JobOrders
VALUES (1, 1, 'inventory'),
       (1, 1, 'manufacturing'),
       (1, 2, 'accounting'),
       (2, 1, 'inventory'),
       (2, 1, 'manufacturing'),
       (2, 2, 'accounting'),
       (2, 2, 'manufacturing'),
       (3, 1, 'manufacturing'),
       (4, 1, 'inventory'),
       (4, 1, 'manufacturing'),
       (4, 1, 'accounting');

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT DISTINCT J1.job_id, C1.candidate_id
  FROM JobOrders AS J1 INNER JOIN CandidateSkills AS C1
    ON J1.skill_code = C1.skill_code
 GROUP BY candidate_id, skill_group, job_id
HAVING COUNT(*) >= (SELECT COUNT(*)
                      FROM JobOrders AS J2
                     WHERE J1.skill_group = J2.skill_group
                       AND J1.job_id = J2.job_id);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
■答えその3
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT J1.job_id, C1.candidate_id
  FROM (SELECT job_id, skill_group, COUNT(*) AS grp_cnt
          FROM JobOrders
         GROUP BY job_id, skill_group) AS J1 CROSS JOIN
       (SELECT R1.job_id, R1.skill_group, S1.candidate_id,
               COUNT(*) AS candidate_cnt
          FROM JobOrders AS R1, CandidateSkills AS S1
         WHERE R1.skill_code = S1.skill_code
GROUP BY R1.job_id, R1.skill_group, S1.candidate_id) AS C1
 WHERE J1.job_id = C1.job_id
   AND J1.skill_group = C1.skill_group
   AND J1.grp_cnt = C1.candidate_cnt
 GROUP BY J1.job_id, C1.candidate_id;



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.075 - 079, Copyright Elsevier 2006.
