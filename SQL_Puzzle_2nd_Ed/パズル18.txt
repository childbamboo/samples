- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DELETE FROM Consumers
 WHERE fam IS NULL     -- é©ï™ÇÃfamóÒÇÕNULLÇ≈
   AND EXISTS          -- Ç©Ç¬ÅAÇŸÇ©Ç…éüÇÃÇÊÇ§Ç»â∆ë∞Ç™Ç¢ÇÈ
       (SELECT *
          FROM Consumers AS C1
         WHERE C1.con_id <> Consumers.con_id   -- é©ï™à»äOÇ≈
           AND C1.address = Consumers.address  -- ìØÇ∂èZèäÇ…èZÇ›
           AND C1.fam IS NOT NULL);       -- famóÒÇ™NULLÇ≈Ç»Ç¢êl

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DELETE FROM Consumers
 WHERE fam IS NULL       -- famóÒÇ™NULL
   AND (SELECT COUNT(*)
          FROM Consumers AS C1
         WHERE C1.address = Consumers.address) > 1;

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ3
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DELETE FROM Consumers
 WHERE fam IS NULL      -- famóÒÇ™NULL
   AND EXISTS (SELECT *
                 FROM Consumers AS C1
                WHERE C1.fam = Consumers.con_id);



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.080 - 081, Copyright Elsevier 2006.
