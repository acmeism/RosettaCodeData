   IGNORE=: ;:'y(0)1',CR

   Filter=: (#~`)(`:6)

   NB. extract tokens from a large body newline terminated of text
   roughparse=: ;@(<@;: ::(''"_);._2)

   NB. count frequencies and get the top x
   top=: top=: {. \:~@:((#;{.)/.~)

   NB. read all installed script (.ijs) files and concatenate them
   JSOURCE=: ;fread each 1&e.@('.ijs'&E.)@>Filter {."1 dirtree jpath '~install'

   10 top (roughparse JSOURCE)-.IGNORE
┌─────┬──┐
│49591│, │
├─────┼──┤
│40473│=:│
├─────┼──┤
│35593│; │
├─────┼──┤
│34096│=.│
├─────┼──┤
│24757│+ │
├─────┼──┤
│18726│" │
├─────┼──┤
│18564│< │
├─────┼──┤
│18446│/ │
├─────┼──┤
│16984│> │
├─────┼──┤
│14655│@ │
└─────┴──┘
