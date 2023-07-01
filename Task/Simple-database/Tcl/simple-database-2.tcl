bash$ udb.tcl db
wrong # args: should be "udb.tcl dbfile subcommand ?args...?"
bash$ udb.tcl db ?
unknown or ambiguous subcommand "?": must be add, bydate, latest, or latestpercategory
bash$ udb.tcl db add
wrong # args: should be "udb.tcl dbfile add title category ?date? ?arg ...?"
bash$ udb.tcl db add "Title 1" foo
bash$ udb.tcl db add "Title 2" foo
bash$ udb.tcl db add "Title 3" bar
bash$ udb.tcl db bydate
Title: Title 1
Category: foo
Date: Tue Nov 15 18:11:58 GMT 2011
----------------------------------------------------------------------
Title: Title 2
Category: foo
Date: Tue Nov 15 18:12:01 GMT 2011
----------------------------------------------------------------------
Title: Title 3
Category: bar
Date: Tue Nov 15 18:12:07 GMT 2011
bash$ udb.tcl db latest
Title: Title 3
Category: bar
Date: Tue Nov 15 18:12:07 GMT 2011
bash$ udb.tcl db latest foo
Title: Title 2
Category: foo
Date: Tue Nov 15 18:12:01 GMT 2011
bash$ udb.tcl db latest bar
Title: Title 3
Category: bar
Date: Tue Nov 15 18:12:07 GMT 2011
bash$ udb.tcl db latestpercategory
Title: Title 2
Category: foo
Date: Tue Nov 15 18:12:01 GMT 2011
----------------------------------------------------------------------
Title: Title 3
Category: bar
Date: Tue Nov 15 18:12:07 GMT 2011
bash$ udb.tcl db add "Title 4" bar "12:00 Monday last week"
bash$ udb.tcl db bydate
Title: Title 4
Category: bar
Date: Mon Nov 14 12:00:00 GMT 2011
----------------------------------------------------------------------
Title: Title 1
Category: foo
Date: Tue Nov 15 18:11:58 GMT 2011
----------------------------------------------------------------------
Title: Title 2
Category: foo
Date: Tue Nov 15 18:12:01 GMT 2011
----------------------------------------------------------------------
Title: Title 3
Category: bar
Date: Tue Nov 15 18:12:07 GMT 2011
bash$ cat db
{Title 1} {foo 1321380718 {}}
{Title 2} {foo 1321380721 {}}
{Title 3} {bar 1321380727 {}}
{Title 4} {bar 1321272000 {}}
bash$ udb.tcl db add "Title 5" foo "12:00 Monday last week" Comment 'Wholly excellent!'
bash$ cat db
{Title 1} {foo 1321380718 {}}
{Title 2} {foo 1321380721 {}}
{Title 3} {bar 1321380727 {}}
{Title 4} {bar 1321272000 {}}
{Title 5} {foo 1321272000 {Comment {Wholly excellent!}}}
bash$ udb.tcl db bydate
Title: Title 4
Category: bar
Date: Mon Nov 14 12:00:00 GMT 2011
----------------------------------------------------------------------
Title: Title 5
Category: foo
Date: Mon Nov 14 12:00:00 GMT 2011
Comment: Wholly excellent!
----------------------------------------------------------------------
Title: Title 1
Category: foo
Date: Tue Nov 15 18:11:58 GMT 2011
----------------------------------------------------------------------
Title: Title 2
Category: foo
Date: Tue Nov 15 18:12:01 GMT 2011
----------------------------------------------------------------------
Title: Title 3
Category: bar
Date: Tue Nov 15 18:12:07 GMT 2011
