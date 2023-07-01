$ . input  # source the input
$ echo $D
jconsole s dataflow
$ $D display the latest entry
┌───────────────────────┬──────────┬──────────┬─────────┬────┬───────┬───────┬───────────┐
│time                   │name      │expression│algebraic│rank│valence│example│explanation│
│2012-02-07:20:36:54.749│many more!│          │         │    │       │       │           │
└───────────────────────┴──────────┴──────────┴─────────┴────┴───────┴───────┴───────────┘
$ $D display the latest entry where 'part of speech' contains verb
choose 1 of
┌────┬────┬──────────┬─────────┬────┬───────┬───────┬───────────┐
│time│name│expression│algebraic│rank│valence│example│explanation│
└────┴────┴──────────┴─────────┴────┴───────┴───────┴───────────┘
$ $D display the latest entry where example contains average
┌───────────────────────┬────┬──────────┬────────────┬────────┬───────┬────────────────┬────────────────────┐
│time                   │name│expression│algebraic   │rank    │valence│example         │explanation         │
│2012-02-07:20:36:54.564│fork│(f g h)y  │g(f(y),h(y))│infinite│monad  │average=: +/ % #│sum divided by tally│
└───────────────────────┴────┴──────────┴────────────┴────────┴───────┴────────────────┴────────────────────┘
$ $D display all entries ordre by valence # oops!  transposition typo.
Commands:

DBNAME add DATA
DBNAME display the latest entry
DBNAME display the latest entry where CATEGORY contains WORD
DBNAME display all entries
DBNAME display all entries order by CATEGORY

1) The first add with new DBNAME assign category names.
2) lower case arguments verbatim.
3) UPPER CASE: substitute your values.

Examples, having saved this program as a file named s :
$ jconsole s simple.db display all entries
$ jconsole s simple.db add "first field" "2nd field"

$ $D display all entries order by valence
┌───────────────────────┬──────────┬──────────┬─────────────────┬──────────┬───────┬─────────────────┬─────────────────────────────┐
│time                   │name      │expression│algebraic        │rank      │valence│example          │explanation                  │
│2012-02-08:23:45:06.539│many more!│          │                 │          │       │                 │                             │
│2012-02-08:23:45:06.329│insert    │f/ y      │insert f within y│infinite  │dyad   │sum=: +/         │continued_fraction=:+`%/     │
│2012-02-08:23:45:06.400│hook      │x(f g)y   │f(x,g(y))        │infinite  │dyad   │display verb in s│a reflexive dyadic hook      │
│2012-02-08:23:45:06.426│fork      │x(f g h)y │g(f(x,y),h(x,y)) │infinite  │dyad   │2j1(+ * -)9 12   │product of sum and difference│
│2012-02-08:23:45:06.471│passive   │x f~ y    │f(y,x)           │ranks of f│dyad   │(%~ i.@:>:) 8x   │8 intervals from 0 to 1      │
│2012-02-08:23:45:06.515│atop      │x f@g y   │f(g(x,y))        │rank of g │dyad   │>@{.             │(lisp) open the car          │
│2012-02-08:23:45:06.353│fork      │(f g h)y  │g(f(y),h(y))     │infinite  │monad  │average=: +/ % # │sum divided by tally         │
│2012-02-08:23:45:06.376│hook      │(f g)y    │f(y,g(y))        │infinite  │monad  │(/: 2&{"1)table  │sort by third column         │
│2012-02-08:23:45:06.448│reflexive │f~ y      │f(y,y)           │infinite  │monad  │^~y              │y raised to the power of y   │
│2012-02-08:23:45:06.493│atop      │f@g y     │f(g(y))          │rank of g │monad  │*:@(+/)          │square the sum               │
└───────────────────────┴──────────┴──────────┴─────────────────┴──────────┴───────┴─────────────────┴─────────────────────────────┘
$ $D display all entries
┌───────────────────────┬──────────┬──────────┬─────────────────┬──────────┬───────┬─────────────────┬─────────────────────────────┐
│time                   │name      │expression│algebraic        │rank      │valence│example          │explanation                  │
│2012-02-08:23:45:06.329│insert    │f/ y      │insert f within y│infinite  │dyad   │sum=: +/         │continued_fraction=:+`%/     │
│2012-02-08:23:45:06.353│fork      │(f g h)y  │g(f(y),h(y))     │infinite  │monad  │average=: +/ % # │sum divided by tally         │
│2012-02-08:23:45:06.376│hook      │(f g)y    │f(y,g(y))        │infinite  │monad  │(/: 2&{"1)table  │sort by third column         │
│2012-02-08:23:45:06.400│hook      │x(f g)y   │f(x,g(y))        │infinite  │dyad   │display verb in s│a reflexive dyadic hook      │
│2012-02-08:23:45:06.426│fork      │x(f g h)y │g(f(x,y),h(x,y)) │infinite  │dyad   │2j1(+ * -)9 12   │product of sum and difference│
│2012-02-08:23:45:06.448│reflexive │f~ y      │f(y,y)           │infinite  │monad  │^~y              │y raised to the power of y   │
│2012-02-08:23:45:06.471│passive   │x f~ y    │f(y,x)           │ranks of f│dyad   │(%~ i.@:>:) 8x   │8 intervals from 0 to 1      │
│2012-02-08:23:45:06.493│atop      │f@g y     │f(g(y))          │rank of g │monad  │*:@(+/)          │square the sum               │
│2012-02-08:23:45:06.515│atop      │x f@g y   │f(g(x,y))        │rank of g │dyad   │>@{.             │(lisp) open the car          │
│2012-02-08:23:45:06.539│many more!│          │                 │          │       │                 │                             │
└───────────────────────┴──────────┴──────────┴─────────────────┴──────────┴───────┴─────────────────┴─────────────────────────────┘
$ cat dataflow
'2012-02-08:23:45:06.304';'name';'expression';'algebraic';'rank';'valence';'example';'explanation'
'2012-02-08:23:45:06.329';'insert';'f/ y';'insert f within y';'infinite';'dyad';'sum=: +/';'continued_fraction=:+`%/'
'2012-02-08:23:45:06.353';'fork';'(f g h)y';'g(f(y),h(y))';'infinite';'monad';'average=: +/ % #';'sum divided by tally'
'2012-02-08:23:45:06.376';'hook';'(f g)y';'f(y,g(y))';'infinite';'monad';'(/: 2&{"1)table';'sort by third column'
'2012-02-08:23:45:06.400';'hook';'x(f g)y';'f(x,g(y))';'infinite';'dyad';'display verb in s';'a reflexive dyadic hook'
'2012-02-08:23:45:06.426';'fork';'x(f g h)y';'g(f(x,y),h(x,y))';'infinite';'dyad';'2j1(+ * -)9 12';'product of sum and difference'
'2012-02-08:23:45:06.448';'reflexive';'f~ y';'f(y,y)';'infinite';'monad';'^~y';'y raised to the power of y'
'2012-02-08:23:45:06.471';'passive';'x f~ y';'f(y,x)';'ranks of f';'dyad';'(%~ i.@:>:) 8x';'8 intervals from 0 to 1'
'2012-02-08:23:45:06.493';'atop';'f@g y';'f(g(y))';'rank of g';'monad';'*:@(+/)';'square the sum'
'2012-02-08:23:45:06.515';'atop';'x f@g y';'f(g(x,y))';'rank of g';'dyad';'>@{.';'(lisp) open the car'
'2012-02-08:23:45:06.539';'many more!'
$
