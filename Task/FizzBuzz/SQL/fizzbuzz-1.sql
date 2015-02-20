SELECT CASE
    WHEN MOD(level,15)=0 THEN 'FizzBuzz'
    WHEN MOD(level,3)=0 THEN 'Fizz'
    WHEN MOD(level,5)=0 THEN 'Buzz'
    ELSE TO_CHAR(level)
    END FizzBuzz
    FROM dual
    CONNECT BY LEVEL <= 100;
