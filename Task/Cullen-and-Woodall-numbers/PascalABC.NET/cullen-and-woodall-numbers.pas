##
function cullen(n: integer) := n * power(2bi, n) + 1;

function woodall(n: integer) := n * power(2bi, n) - 1;

(1..20).select(x -> cullen(x)).println;
(1..20).select(x -> woodall(x)).println;
