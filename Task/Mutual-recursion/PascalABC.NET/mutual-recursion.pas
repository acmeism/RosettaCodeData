##
function M(n: integer): integer; forward;
function F(n: integer): integer := if n < 1 then 1 else n - M(F(n - 1));
function M(n: integer): integer := if n < 1 then 0 else n - F(M(n - 1));

(0..19).select(x -> F(x)).println;
(0..19).select(x -> M(x)).println;
