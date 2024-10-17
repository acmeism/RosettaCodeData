##
function M(n: integer): integer; forward;
function F(n: integer): integer := n < 1 ? 1 : n - M(F(n - 1));
function M(n: integer): integer := n < 1 ? 0 : n - F(M(n - 1));

(0..19).select(x -> F(x)).println;
(0..19).select(x -> M(x)).println;
