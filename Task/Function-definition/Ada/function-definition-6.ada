with Multiply;
...
function Multiply_Integer is new Multiply(Number => Integer);
use Multiply_Integer; -- If you must

type My_Integer is Range -100..100;
function Multiply_My_Integer is new Multiply(My_Integer);
