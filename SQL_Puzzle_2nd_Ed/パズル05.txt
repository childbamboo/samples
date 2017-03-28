- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE TABLE Foobar
(no_alpha VARCHAR(6) NOT NULL
          CHECK (UPPER(no_alpha) = LOWER(no_alpha)),
 some_alpha VARCHAR(6) NOT NULL
          CHECK (UPPER(some_alpha) <> LOWER(some_alpha)),
 all_alpha VARCHAR(6) NOT NULL
          CHECK (UPPER(all_alpha) <> LOWER(all_alpha)
            AND SUBSTRING(LOWER(all_alpha) FROM 1 FOR 1)
                BETWEEN 'a' AND 'z'
            AND SUBSTRING(LOWER(all_alpha) FROM 2 FOR 1) || 'a'
                BETWEEN 'a' AND 'za'
            AND SUBSTRING(LOWER(all_alpha) FROM 3 FOR 1) || 'a'
                BETWEEN 'a' AND 'za'
            AND SUBSTRING(LOWER(all_alpha) FROM 4 FOR 1) || 'a'
                BETWEEN 'a' AND 'za'
            AND SUBSTRING(LOWER(all_alpha) FROM 5 FOR 1) || 'a'
                BETWEEN 'a' AND 'za'
            AND SUBSTRING(LOWER(all_alpha) FROM 6 FOR 1) || 'a'
                BETWEEN 'a' AND 'za' ));

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

all_alpha VARCHAR(6) NOT NULL
CHECK (TRANSLATE (all_alpha USING one_letter_translation) =
'xxxxxx')

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Å°ìöÇ¶ÇªÇÃ3
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

all_alpha VARCHAR(6) NOT NULL
CHECK (all_alpha SIMILAR TO '[:ALPHA:]+')



=================================================================
This article was published in JOE CELKO'S SQL PUZZLES AND ANSWERS
Second Edition, Joe Celko, pp.019 - 020, Copyright Elsevier 2006.
