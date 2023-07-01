WITH ranked_emp AS (
    SELECT  emp_name
           ,dept_id
           ,salary
           ,DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary ) ranking
    FROM    emp
    )
SELECT  dept_id
       ,ranking
       ,emp_name
       ,salary
FROM    ranked_emp
WHERE   ranking <= 2
ORDER BY dept_id, ranking;
