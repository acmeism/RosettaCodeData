-- Load some numbers
CREATE TABLE numbers(i INTEGER);
INSERT INTO numbers VALUES(1);
INSERT INTO numbers SELECT i + (SELECT MAX(i) FROM numbers) FROM numbers;
INSERT INTO numbers SELECT i + (SELECT MAX(i) FROM numbers) FROM numbers;
INSERT INTO numbers SELECT i + (SELECT MAX(i) FROM numbers) FROM numbers;
INSERT INTO numbers SELECT i + (SELECT MAX(i) FROM numbers) FROM numbers;
INSERT INTO numbers SELECT i + (SELECT MAX(i) FROM numbers) FROM numbers;
INSERT INTO numbers SELECT i + (SELECT MAX(i) FROM numbers) FROM numbers;
INSERT INTO numbers SELECT i + (SELECT MAX(i) FROM numbers) FROM numbers;
-- Define the fizzes and buzzes
CREATE TABLE fizzbuzz (message VARCHAR(8), divisor INTEGER);
INSERT INTO fizzbuzz VALUES('fizz',      3);
INSERT INTO fizzbuzz VALUES('buzz',      5);
INSERT INTO fizzbuzz VALUES('fizzbuzz', 15);
-- Play fizzbuzz
SELECT COALESCE(max(message),CAST(i AS VARCHAR(99))) as result
FROM numbers LEFT OUTER JOIN fizzbuzz ON MOD(i,divisor) = 0
GROUP BY i
HAVING i <= 100
ORDER BY i;
-- Tidy up
DROP TABLE fizzbuzz;
DROP TABLE numbers;
