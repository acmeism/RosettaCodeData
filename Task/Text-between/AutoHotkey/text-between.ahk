data =
(
Hello Rosetta Code world|Hello | world|
Hello Rosetta Code world|start| world|
Hello Rosetta Code world|Hello |end|
</div><div style=\"chinese\">你好嗎</div>|<div style=\"chinese\">|</div>|
<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">|<text>|<table>|
<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">|<table>|</table>|
The quick brown fox jumps over the lazy other fox|quick | fox|
One fish two fish red fish blue fish|fish | red|
FooBarBazFooBuxQuux|Foo|Foo|
)
result := ""
for i, line in StrSplit(data, "`n", "`r")
	x := StrSplit(line, "|")
	, result .= "text: """ x.1 """`nstart: """ x.2 """`tend: """ x.3 """`noutput: """ textBetween(x.1, x.2, x.3) """`n----`n"
MsgBox, 262144, , % result
return

textBetween(text, start, end){
	RegExMatch(text,(start="start"?"^":"\Q" start "\E") "(.*?)" (end="end"?"$":"\Q" end "\E?"),m)
	return m1
}
