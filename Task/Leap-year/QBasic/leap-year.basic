DECLARE FUNCTION diy% (y AS INTEGER)
DECLARE FUNCTION isLeapYear% (yr AS INTEGER)
DECLARE FUNCTION year% (date AS STRING)

PRINT isLeapYear(year(DATE$))

FUNCTION diy% (y AS INTEGER)
    IF y MOD 4 THEN
        diy = 365
    ELSEIF y MOD 100 THEN
        diy = 366
    ELSEIF y MOD 400 THEN
        diy = 365
    ELSE
        diy = 366
    END IF
END FUNCTION

FUNCTION isLeapYear% (yr AS INTEGER)
    isLeapYear = (366 = diy(yr))
END FUNCTION

FUNCTION year% (date AS STRING)
    year% = VAL(RIGHT$(date, 4))
END FUNCTION
