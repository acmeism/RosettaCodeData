SELECT
        isnull(if row_num % 3 = 0 then 'Fizz' endif + if row_num % 5 = 0 then 'Buzz' endif, str(row_num))
FROM
        sa_rowgenerator(1,100)
