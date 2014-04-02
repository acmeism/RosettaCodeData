select case LINE
         when 10 then
          'Tot.' || LPAD(POPULATION, 2) || ' Employees in ' || TIE_COUNT ||
          ' deps.Avg salary:' || TO_CHAR(SALARY, '99990.99')
         when 30 then
          '-'
         when 50 then
          'Department: ' || DEPT_ID || ', pop: ' || POPULATION ||
          '. Avg Salary: ' || TO_CHAR(SALARY, '99990.99')
         when 70 then
          LPAD('Employee ID', 14) || LPAD('Employee name', 20) ||
          LPAD('Salary', 9) || 'Rank'
         when 90 then
          LPAD('+', 14, '-') || LPAD('+', 20, '-') || LPAD('+', 9, '-') ||
          LPAD('+', 4, '-')
         else
          LPAD(' ', 8) || LPAD(EMP_ID, 6) || LPAD(EMP_NAME, 20) ||
          TO_CHAR(SALARY, '99990.99') || LPAD(case when TIE_COUNT = 1 then  ' ' else 'T' end || RANK, 4)
       end "Top rank per group"
  from (select 10 LINE
              ,null EMP_ID
              ,null EMP_NAME
              ,' ' DEPT_ID
              ,avg(SALARY) SALARY
              ,0 RANK
              ,count(distinct DEPT_ID) TIE_COUNT
              ,count(*) POPULATION
          from EMP
        union all
        select 30      LINE
              ,null    EMP_ID
              ,null    EMP_NAME
              ,DEPT_ID
              ,0       SALARY
              ,0       RANK
              ,0       TIE_COUNT
              ,0       POPULATION
          from EMP
         group by DEPT_ID
        union all
        select 50 LINE
              ,null EMP_ID
              ,null EMP_NAME
              ,DEPT_ID
              ,avg(SALARY) SALARY
              ,0 RANK
              ,0 TIE_COUNT
              ,count(*) POPULATION
          from EMP
         group by DEPT_ID
        union all
        select 70      LINE
              ,null    EMP_ID
              ,null    EMP_NAME
              ,DEPT_ID
              ,0       SALARY
              ,0       RANK
              ,0       TIE_COUNT
              ,0       POPULATION
          from EMP
         group by DEPT_ID
        union all
        select 90      LINE
              ,null    EMP_ID
              ,null    EMP_NAME
              ,DEPT_ID
              ,0       SALARY
              ,0       RANK
              ,0       TIE_COUNT
              ,0       POPULATION
          from EMP
         group by DEPT_ID
        union all
        select 110 LINE
              ,EMP_ID
              ,EMP_NAME
              ,DEPT_ID
              ,SALARY
              ,(select count(distinct EMP4.SALARY)
                  from EMP EMP4
                 where EMP4.DEPT_ID = EMP3.DEPT_ID
                   and EMP4.SALARY >= EMP3.SALARY) RANK
              ,(select count(*)
                  from EMP EMP2
                 where EMP2.DEPT_ID = EMP3.DEPT_ID
                   and EMP2.SALARY = EMP3.SALARY) TIE_COUNT
              ,0 POPULATION
          from EMP EMP3
         where $topN >= -- Here is the meat, Correlated subquery
               (select count(distinct EMP4.SALARY)
                  from EMP EMP4
                 where EMP4.DEPT_ID = EMP3.DEPT_ID
                   and EMP4.SALARY >= EMP3.SALARY))
 order by DEPT_ID ,LINE ,SALARY desc, EMP_ID;
