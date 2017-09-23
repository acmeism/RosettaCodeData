WITH RECURSIVE
T0 (N, ITEM, LIST, NEW_LIST) AS
(
    SELECT 1,
           NULL,
           '90,47,58,29,22,32,55,5,55,73' || ',',
           NULL
     UNION ALL
    SELECT CASE
               WHEN SUBSTR(LIST, INSTR(LIST, ',') + 1, LENGTH(LIST)) = ''
               THEN N + 1
               ELSE N
           END,
           CASE
               WHEN SUBSTR(LIST, INSTR(LIST, ',') + 1, LENGTH(LIST)) <> ''
               THEN SUBSTR(LIST, 1, INSTR(LIST, ',') - 1)
               ELSE NULL
           END,
           CASE
               WHEN SUBSTR(LIST, INSTR(LIST, ',') + 1, LENGTH(LIST)) = ''
               THEN IFNULL(NEW_LIST || (SUBSTR(LIST, 1, INSTR(LIST, ',') - 1) - ITEM) || ',', '')
               ELSE SUBSTR(LIST, INSTR(LIST, ',') + 1, LENGTH(LIST))
           END,
           CASE
               WHEN SUBSTR(LIST, INSTR(LIST, ',') + 1, LENGTH(LIST)) <> ''
               THEN IFNULL(NEW_LIST, '') || IFNULL((SUBSTR(LIST, 1, INSTR(LIST, ',') - 1) - ITEM) || ',', '')
               ELSE NULL
           END
      FROM T0
     WHERE INSTR(LIST, ',') > 0
)
SELECT N,
       TRIM(LIST, ',') LIST
  FROM T0
 WHERE NEW_LIST IS NULL
   AND LIST <> ''
 ORDER BY N;
