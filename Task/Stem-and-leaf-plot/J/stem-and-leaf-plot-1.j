stem        =: <.@(%&10)
leaf        =: 10&|
stemleaf    =: (stem@{. ; leaf)/.~ stem
expandStems =: <./ ([ + i.@>:@-~) >./
expandLeaves=: (expandStems e. ])@[ #inv ]

showStemLeaf=: (":@,.@expandStems@[ ; ":&>@expandLeaves)&>/@(>@{. ; <@{:)@|:@stemleaf@/:~
