CREATE FUNCTION gcd(integer, integer)
RETURNS integer
LANGUAGE sql
AS $function$
WITH RECURSIVE x (u, v) AS (
  SELECT ABS($1), ABS($2)
  UNION
  SELECT v, u % v FROM x WHERE v > 0
)
SELECT min(u) FROM x;
$function$
