iex(1)> Code.eval_string("x + 4 * Enum.sum([1,2,3,4])", [x: 17])
{57, [x: 17]}
iex(2)> Code.eval_string("c = a + b", [a: 1, b: 2])
{3, [a: 1, b: 2, c: 3]}
iex(3)> Code.eval_string("a = a + b", [a: 1, b: 2])
{3, [a: 3, b: 2]}
