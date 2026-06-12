WITH
v(n, x) AS (
  VALUES
  (0, 1),
  (1, 8),
  (2, 2),
  (3, -3),
  (4, 0),
  (5, 1),
  (6, 1),
  (7, -2.3),
  (8, 0),
  (9, 5.5),
  (10, 8),
  (11, 6),
  (12, 2),
  (13, 9),
  (14, 11),
  (15, 10),
  (16, 3)
),
t(n, x, y, d) AS (
  SELECT a.n, a.x, b.x, ABS(b.x - a.x) FROM v AS a JOIN v AS b ON b.n - a.n = 1
)
SELECT x, y, d FROM t WHERE d = (SELECT MAX(d) FROM t) ORDER BY n
