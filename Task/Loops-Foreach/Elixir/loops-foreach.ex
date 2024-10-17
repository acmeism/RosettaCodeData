iex(1)> list = [1,3.14,"abc",[3],{0,5}]
[1, 3.14, "abc", [3], {0, 5}]
iex(2)> Enum.each(list, fn x -> IO.inspect x end)
1
3.14
"abc"
[3]
{0, 5}
:ok
