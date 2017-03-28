- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ñ‚ëËï∂
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Jobs
(job_id INTEGER NOT NULL PRIMARY KEY,
 start_date DATE NOT NULL,
 ... );

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Personnel
(emp_id INTEGER NOT NULL PRIMARY KEY,
 emp_name CHAR(20) NOT NULL,
 ... );

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Teams
(job_id INTEGER NOT NULL,
 mech_type INTEGER NOT NULL,
 emp_id INTEGER NOT NULL,
 ... );

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Teams
(job_id INTEGER NOT NULL REFERENCES Jobs(job_id),
 mech_type CHAR(10) NOT NULL
   CHECK (mech_type IN ('Primary', 'Assistant')),
 emp_id INTEGER NOT NULL REFERENCES Personnel(emp_id)
 ...);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT Jobs.job_id, Teams.emp_id AS "primary"
  FROM Jobs LEFT OUTER JOIN Teams
              ON Jobs.job_id = Teams.job_id
 WHERE Teams.mech_type = 'Primary';

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT Jobs.job_id,
       (SELECT emp_id
          FROM Teams
         WHERE Jobs.job_id = Teams.job_id
           AND Teams.mech_type = 'Primary') AS "primary",
       (SELECT emp_id
          FROM Teams
         WHERE Jobs.job_id = Teams.job_id
           AND Teams.mech_type = 'Assistant') AS assistant
  FROM Jobs;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT Jobs.job_id,
       (SELECT emp_name
          FROM Teams, Personnel
         WHERE Jobs.job_id = Teams.job_id
           AND Personnel.emp_id = Teams.emp_id
           AND Teams.mech_type = 'Primary') AS "primary",
       (SELECT emp_name
          FROM Teams, Personnel
         WHERE Jobs.job_id = Teams.job_id
           AND Personnel.emp_id = Teams.emp_id
           AND Teams.mech_type = 'Assistant') AS Assistant
  FROM Jobs;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Jobs
(job_id INTEGER NOT NULL PRIMARY KEY REFERENCES Teams (job_id),
 start_date DATE NOT NULL,
 ... );

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Teams
(job_id INTEGER NOT NULL,
 mech_type CHAR(10) NOT NULL
    CHECK (mech_type IN ('Primary', 'Assistant')),
 emp_id INTEGER NOT NULL REFERENCES Personnel(emp_id),
 PRIMARY KEY (job_id, mech_type));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Teams
(job_id INTEGER NOT NULL UNIQUE,
 mech_type CHAR(10) NOT NULL
    CHECK (mech_type IN ('Primary', 'Assistant')),
 emp_id INTEGER NOT NULL REFERENCES Personnel(emp_id),
 PRIMARY KEY (job_id, mech_type));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Teams
(job_id INTEGER NOT NULL PRIMARY KEY,
 mech_type CHAR(10) NOT NULL
    CHECK (mech_type IN ('Primary', 'Assistant')),
 emp_id INTEGER NOT NULL REFERENCES Personnel(emp_id),
 UNIQUE (job_id, mech_type));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ3
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Teams
(job_id INTEGER NOT NULL REFERENCES Jobs(job_id),
 primary_mech INTEGER NOT NULL REFERENCES Personnel(emp_id),
 assist_mech  INTEGER NOT NULL REFERENCES Personnel(emp_id),
 CONSTRAINT at_least_one_mechanic
   CHECK(COALESCE (primary_mech, assist_mech) IS NOT NULL),
 ...);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Personnel
(emp_id INTEGER NOT NULL PRIMARY KEY,
 emp_name CHAR(20) NOT NULL,
 mech_type CHAR(10) NOT NULL
     CHECK (mech_type IN ('Primary', 'Assistant')),
 UNIQUE (emp_id, mech_type),
 ...);

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Teams
(job_id INTEGER NOT NULL REFERENCES Jobs(job_id),
 primary_mech INTEGER NOT NULL,
 primary_type CHAR(10) DEFAULT 'Primary' NOT NULL
     CHECK (primary_type = 'Primary'),
 assist_mech INTEGER NOT NULL ,
 assist_type CHAR(10) DEFAULT 'Assistant' NOT NULL
     CHECK (assist_type = 'Assistant') ,
 CONSTRAINT fk_primary FOREIGN KEY (primary_mech, primary_type)
     REFERENCES Personnel(emp_id, mech_type),
 CONSTRAINT fk_assist FOREIGN KEY (assist_mech, assist_type)
     REFERENCES Personnel(emp_id, mech_type),
 CONSTRAINT at_least_one_mechanic
     CHECK(COALESCE (primary_mech, assist_mech) IS NOT NULL)) ;



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.069 - 074, Copyright Elsevier 2006.
