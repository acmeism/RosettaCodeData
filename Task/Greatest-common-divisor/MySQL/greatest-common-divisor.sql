DROP FUNCTION IF EXISTS gcd;
DELIMITER |

CREATE FUNCTION gcd(x INT, y INT)
RETURNS INT
BEGIN
  SET @dividend=GREATEST(ABS(x),ABS(y));
  SET @divisor=LEAST(ABS(x),ABS(y));
  IF @divisor=0 THEN
    RETURN @dividend;
  END IF;
  SET @gcd=NULL;
  SELECT gcd INTO @gcd FROM
    (SELECT @tmp:=@dividend,
            @dividend:=@divisor AS gcd,
            @divisor:=@tmp % @divisor AS remainder
       FROM mysql.help_relation WHERE @divisor>0) AS x
    WHERE remainder=0;
  RETURN @gcd;
END;|

DELIMITER ;

SELECT gcd(12345, 9876);
