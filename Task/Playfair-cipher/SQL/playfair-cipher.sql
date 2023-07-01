--Clean up previous run
IF EXISTS (SELECT *
           FROM   SYS.TYPES
           WHERE  NAME = 'FairPlayTable')
  DROP TYPE FAIRPLAYTABLE

--Set Types
CREATE TYPE FAIRPLAYTABLE AS TABLE (LETTER VARCHAR(1), COLID INT, ROWID INT)

GO

--Configuration Variables
DECLARE @KEYWORD VARCHAR(25) = 'CHARLES' --Keyword for encryption
DECLARE @INPUT VARCHAR(MAX) = 'Testing Seeconqz' --Word to be encrypted
DECLARE @Q INT = 0 -- Q removed?
DECLARE @ENCRYPT INT = 1 --Encrypt?
--Setup Variables
DECLARE @WORDS TABLE
  (
     WORD_PRE  VARCHAR(2),
     WORD_POST VARCHAR(2)
  )
DECLARE @T_TABLE FAIRPLAYTABLE
DECLARE @NEXTLETTER CHAR(1)
DECLARE @WORD VARCHAR(2),
        @COL1 INT,
        @COL2 INT,
        @ROW1 INT,
        @ROW2 INT,
        @TMP  INT
DECLARE @SQL     NVARCHAR(MAX) = '',
        @COUNTER INT = 1,
        @I       INT = 1
DECLARE @COUNTER_2 INT = 1

SET @INPUT = REPLACE(@INPUT, ' ', '')
SET @KEYWORD = UPPER(@KEYWORD)

DECLARE @USEDLETTERS VARCHAR(MAX) = ''
DECLARE @TESTWORDS VARCHAR(2),
        @A         INT = 0

WHILE @COUNTER_2 <= 5
  BEGIN
      WHILE @COUNTER <= 5
        BEGIN
            IF LEN(@KEYWORD) > 0
              BEGIN
                  SET @NEXTLETTER = LEFT(@KEYWORD, 1)
                  SET @KEYWORD = RIGHT(@KEYWORD, LEN(@KEYWORD) - 1)

                  IF CHARINDEX(@NEXTLETTER, @USEDLETTERS) = 0
                    BEGIN
                        INSERT INTO @T_TABLE
                        SELECT @NEXTLETTER,
                               @COUNTER,
                               @COUNTER_2

                        SET @COUNTER = @COUNTER + 1
                        SET @USEDLETTERS = @USEDLETTERS + @NEXTLETTER
                    END
              END
            ELSE
              BEGIN
                  WHILE 1 = 1
                    BEGIN
                        IF CHARINDEX(CHAR(64 + @I), @USEDLETTERS) = 0
                           AND NOT ( CHAR(64 + @I) = 'Q'
                                     AND @Q = 1 )
                           AND NOT ( @Q = 0
                                     AND CHAR(64 + @I) = 'J' )
                          BEGIN
                              SET @NEXTLETTER = CHAR(64 + @I)
                              SET @USEDLETTERS = @USEDLETTERS + CHAR(64 + @I)
                              SET @I = @I + 1

                              BREAK
                          END

                        SET @I = @I + 1
                    END

                  -- SELECT 1 AS [T]
                  --BREAK
                  INSERT INTO @T_TABLE
                  SELECT @NEXTLETTER,
                         @COUNTER,
                         @COUNTER_2

                  SET @COUNTER = @COUNTER + 1
              END
        END

      SET @COUNTER_2 = @COUNTER_2 + 1
      SET @COUNTER = 1
  END

--Split word into Digraphs
WHILE @A < 1
  BEGIN
      SET @TESTWORDS = UPPER(LEFT(@INPUT, 2))

      IF LEN(@TESTWORDS) = 1
        BEGIN
            SET @TESTWORDS = @TESTWORDS + 'X'
            SET @A = 1
        END
      ELSE IF RIGHT(@TESTWORDS, 1) = LEFT(@TESTWORDS, 1)
        BEGIN
            SET @TESTWORDS = RIGHT(@TESTWORDS, 1) + 'X'
            SET @INPUT = RIGHT(@INPUT, LEN(@INPUT) - 1)
        END
      ELSE
        SET @INPUT = RIGHT(@INPUT, LEN(@INPUT) - 2)

      IF LEN(@INPUT) = 0
        SET @A = 1

      INSERT @WORDS
      SELECT @TESTWORDS,
             ''
  END

--Start Encryption
IF @ENCRYPT = 1
  BEGIN
      --Loop through Digraphs amd encrypt
      DECLARE WORDS_LOOP CURSOR LOCAL FORWARD_ONLY FOR
        SELECT WORD_PRE
        FROM   @WORDS
        FOR UPDATE OF WORD_POST

      OPEN WORDS_LOOP

      FETCH NEXT FROM WORDS_LOOP INTO @WORD

      WHILE @@FETCH_STATUS = 0
        BEGIN
            --Find letter positions
            SET @ROW1 = (SELECT ROWID
                         FROM   @T_TABLE
                         WHERE  LETTER = LEFT(@WORD, 1))
            SET @ROW2 = (SELECT ROWID
                         FROM   @T_TABLE
                         WHERE  LETTER = RIGHT(@WORD, 1))
            SET @COL1 = (SELECT COLID
                         FROM   @T_TABLE
                         WHERE  LETTER = LEFT(@WORD, 1))
            SET @COL2 = (SELECT COLID
                         FROM   @T_TABLE
                         WHERE  LETTER = RIGHT(@WORD, 1))

            --Move positions according to encryption rules
            IF @COL1 = @COL2
              BEGIN
                  SET @ROW1 = @ROW1 + 1
                  SET @ROW2 = @ROW2 + 1
              --select 'row'
              END
            ELSE IF @ROW1 = @ROW2
              BEGIN
                  SET @COL1 = @COL1 + 1
                  SET @COL2 = @COL2 + 1
              --select 'col'
              END
            ELSE
              BEGIN
                  SET @TMP = @COL2
                  SET @COL2 = @COL1
                  SET @COL1 = @TMP
              --select 'reg'
              END

            IF @ROW1 = 6
              SET @ROW1 = 1

            IF @ROW2 = 6
              SET @ROW2 = 1

            IF @COL1 = 6
              SET @COL1 = 1

            IF @COL2 = 6
              SET @COL2 = 1

            --Find encrypted letters by positions
            UPDATE @WORDS
            SET    WORD_POST = (SELECT (SELECT LETTER
                                        FROM   @T_TABLE
                                        WHERE  ROWID = @ROW1
                                               AND COLID = @COL1)
                                       + (SELECT LETTER
                                          FROM   @T_TABLE
                                          WHERE  COLID = @COL2
                                                 AND ROWID = @ROW2))
            WHERE  WORD_PRE = @WORD

            FETCH NEXT FROM WORDS_LOOP INTO @WORD
        END

      CLOSE WORDS_LOOP

      DEALLOCATE WORDS_LOOP
  END
--Start Decryption
ELSE
  BEGIN
      --Loop through Digraphs amd decrypt
      DECLARE WORDS_LOOP CURSOR LOCAL FORWARD_ONLY FOR
        SELECT WORD_PRE
        FROM   @WORDS
        FOR UPDATE OF WORD_POST

      OPEN WORDS_LOOP

      FETCH NEXT FROM WORDS_LOOP INTO @WORD

      WHILE @@FETCH_STATUS = 0
        BEGIN
            --Find letter positions
            SET @ROW1 = (SELECT ROWID
                         FROM   @T_TABLE
                         WHERE  LETTER = LEFT(@WORD, 1))
            SET @ROW2 = (SELECT ROWID
                         FROM   @T_TABLE
                         WHERE  LETTER = RIGHT(@WORD, 1))
            SET @COL1 = (SELECT COLID
                         FROM   @T_TABLE
                         WHERE  LETTER = LEFT(@WORD, 1))
            SET @COL2 = (SELECT COLID
                         FROM   @T_TABLE
                         WHERE  LETTER = RIGHT(@WORD, 1))

            --Move positions according to encryption rules
            IF @COL1 = @COL2
              BEGIN
                  SET @ROW1 = @ROW1 - 1
                  SET @ROW2 = @ROW2 - 1
              --select 'row'
              END
            ELSE IF @ROW1 = @ROW2
              BEGIN
                  SET @COL1 = @COL1 - 1
                  SET @COL2 = @COL2 - 1
              --select 'col'
              END
            ELSE
              BEGIN
                  SET @TMP = @COL2
                  SET @COL2 = @COL1
                  SET @COL1 = @TMP
              --select 'reg'
              END

            IF @ROW1 = 0
              SET @ROW1 = 5

            IF @ROW2 = 0
              SET @ROW2 = 5

            IF @COL1 = 0
              SET @COL1 = 5

            IF @COL2 = 0
              SET @COL2 = 5

            --Find decrypted letters by positions
            UPDATE @WORDS
            SET    WORD_POST = (SELECT (SELECT LETTER
                                        FROM   @T_TABLE
                                        WHERE  ROWID = @ROW1
                                               AND COLID = @COL1)
                                       + (SELECT LETTER
                                          FROM   @T_TABLE
                                          WHERE  COLID = @COL2
                                                 AND ROWID = @ROW2))
            WHERE  WORD_PRE = @WORD

            FETCH NEXT FROM WORDS_LOOP INTO @WORD
        END

      CLOSE WORDS_LOOP

      DEALLOCATE WORDS_LOOP
  END

--Output
DECLARE WORDS CURSOR LOCAL FAST_FORWARD FOR
  SELECT WORD_POST
  FROM   @WORDS

OPEN WORDS

FETCH NEXT FROM WORDS INTO @WORD

WHILE @@FETCH_STATUS = 0
  BEGIN
      SET @SQL = @SQL + @WORD + ' '

      FETCH NEXT FROM WORDS INTO @WORD
  END

CLOSE WORDS

DEALLOCATE WORDS

SELECT @SQL

--Cleanup
IF EXISTS (SELECT *
           FROM   SYS.TYPES
           WHERE  NAME = 'FairPlayTable')
  DROP TYPE FAIRPLAYTABLE
