   Test_text=: <;._2 noun define
Hello Rosetta Code world
Hello Rosetta Code world
Hello Rosetta Code world
</div><div style=\"chinese\">你好嗎</div>
<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">
<table style=\"myTable\"><tr><td>hello world</td></tr></table>
The quick brown fox jumps over the lazy other fox
One fish two fish red fish blue fish
FooBarBazFooBuxQuux
)

   Test_delim=: <"1 '|'&cut;._2 noun define
Hello | world
start| world
Hello |end
<div style=\"chinese\">|</div>
<text>|<table>
<table>|</table>
quick | fox
fish | red
Foo|Foo
)

   Test_output=: <;._2 noun define
Rosetta Code
Hello Rosetta Code
Rosetta Code world
你好嗎
Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">

brown
two fish
BarBaz
)

   Test_output = Test_delim textBetween&.> Test_text
1 1 1 1 1 1 1 1 1
