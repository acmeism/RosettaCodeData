DROP TABLE fizzbuzz;
CREATE TABLE fizzbuzz(i int, fizz string, buzz string);
INSERT INTO fizzbuzz VALUES(1,"","");
INSERT INTO fizzbuzz SELECT i + (SELECT max(i) FROM fizzbuzz), fizz, buzz FROM fizzbuzz;
INSERT INTO fizzbuzz SELECT i + (SELECT max(i) FROM fizzbuzz), fizz, buzz FROM fizzbuzz;
INSERT INTO fizzbuzz SELECT i + (SELECT max(i) FROM fizzbuzz), fizz, buzz FROM fizzbuzz;
INSERT INTO fizzbuzz SELECT i + (SELECT max(i) FROM fizzbuzz), fizz, buzz FROM fizzbuzz;
INSERT INTO fizzbuzz SELECT i + (SELECT max(i) FROM fizzbuzz), fizz, buzz FROM fizzbuzz;
INSERT INTO fizzbuzz SELECT i + (SELECT max(i) FROM fizzbuzz), fizz, buzz FROM fizzbuzz;
INSERT INTO fizzbuzz SELECT i + (SELECT max(i) FROM fizzbuzz), fizz, buzz FROM fizzbuzz;
DROP TABLE lookup;
CREATE TABLE lookup (fizzy, buzzy, rem);
INSERT INTO lookup VALUES("fizz", "buzz", 1);
SELECT
 (SELECT i FROM lookup WHERE rem = (i%3<>0)&(i%5<>0)),
 (SELECT fizzy FROM lookup WHERE rem = (i%3=0)),
 (SELECT buzzy FROM lookup WHERE rem = (i%5=0))
  FROM fizzbuzz WHERE i <= 100;
