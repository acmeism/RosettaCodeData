require 'web/gethttp xml/sax/x2j regex'

x2jclass 'rcPopLang'

rx         =:  (<0 1) {:: (2#a:) ,~ rxmatches rxfrom ]

'Popular Languages' x2jDefn
   /                             :=  langs  : langs =: 0 2 $ a:
   html/body/div/div/div/ul/li   :=  langs =: langs ,^:(a:~:{.@[)~ lang ;  ' \((\d+) members?\)' rx y
   html/body/div/div/div/ul/li/a :=  lang  =: '^\s*((?:.(?!User|Tasks|Omit|attention|operations|by))+)\s*$' rx y
)

cocurrent'base'

sortTab    =.  \: __ ". [: ;:^:_1: {:"1
formatTab  =:  [: ;:^:_1: [: (20 A. (<'-') , |. , [: ('.' <"1@:,.~ ":) 1 + 1 i.@,~ 1{$)&.|: sortTab f.

rcPopLangs =:  formatTab@:process_rcPopLang_@:gethttp
