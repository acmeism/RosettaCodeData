DECLARE @binary AS NVARCHAR(MAX) = '001010111'
DECLARE @gray AS NVARCHAR(MAX) = ''

--Encoder
SET @gray = LEFT(@binary, 1)

WHILE LEN(@binary) > 1
  BEGIN
      IF LEFT(@binary, 1) != SUBSTRING(@binary, 2, 1)
        SET @gray = @gray + '1'
      ELSE
        SET @gray = @gray + '0'

      SET @binary = RIGHT(@binary, LEN(@binary) - 1)
  END

SELECT @gray

--Decoder
SET @binary = LEFT(@gray, 1)

WHILE LEN(@gray) > 1
  BEGIN
      IF RIGHT(@binary, 1) != SUBSTRING(@gray, 2, 1)
        SET @binary = @binary + '1'
      ELSE
        SET @binary = @binary + '0'

      SET @gray = RIGHT(@gray, LEN(@gray) - 1)
  END

SELECT @binary
