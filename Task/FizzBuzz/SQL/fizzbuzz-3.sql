SELECT i, fizzbuzz
  FROM
    (SELECT i,
            CASE
              WHEN i % 15 = 0 THEN 'FizzBuzz'
              WHEN i %  5 = 0 THEN 'Buzz'
              WHEN i %  3 = 0 THEN 'Fizz'
              ELSE NULL
            END AS fizzbuzz
       FROM generate_series(1,100) AS i) AS fb
 WHERE fizzbuzz IS NOT NULL;
