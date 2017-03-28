- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


SELECT C1.claim_id, C1.patient_name, S1.claim_status
  FROM claims AS C1, ClaimStatusCodes AS S1
 WHERE S1.claim_seq IN
           (SELECT MIN(S2.claim_seq)
              FROM ClaimStatusCodes AS S2
             WHERE S2.claim_seq IN
                       (SELECT MAX(S3.claim_seq)
                          FROM LegalEvents AS E1,
                               ClaimStatusCodes AS S3
                         WHERE E1.claim_status = S3.claim_status
                           AND E1.claim_id = C1.claim_id
                         GROUP BY E1.defendant_name));


- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SELECT C1.claim_id, C1.patient_name,
       CASE MIN(S1.claim_seq) WHEN 2 THEN 'AP'
                              WHEN 3 THEN 'OR'
                              WHEN 4 THEN 'SF'
                              ELSE 'C1' END
  FROM ((Claims AS C1
          INNER JOIN
          Defendants AS D1
          ON C1.claim_id = D1.claim_id)
        CROSS JOIN
        ClaimStatusCodes AS S1)
       LEFT OUTER JOIN
       LegalEvents AS E1
       ON C1.claim_id  = E1.claim_id
          AND D1.defendant_name = E1.defendant_name
          AND S1.claim_status = E1.Claim_status
 WHERE E1.claim_id IS NULL
 GROUP BY C1.claim_id, C1.patient_name;



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.048 - 052, Copyright Elsevier 2006.