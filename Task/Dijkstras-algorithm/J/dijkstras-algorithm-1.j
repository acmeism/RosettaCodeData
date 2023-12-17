NB. verbs and adverb
parse_table=: ;:@:(LF&= [;._2 -.&CR)
mp=: +/ .*~~                            NB. matrix product
min=: <./                               NB. minimum
Index=: (i.`)(`:6)                      NB. Index adverb

dijkstra=: dyad define
  'LINK WEIGHT'=. , (0 _ ,. 2) <;.3 y
  'SOURCE SINK'=. |: LINK
  FRONTIER=. , < {. x
  GOAL=. {: x
  enumerate=. 2&([\)&.>
  while. FRONTIER do.
    PATH_MASK=. FRONTIER (+./@:(-:"1/)&:>"0 _~ enumerate)~ LINK
    I=. PATH_MASK min Index@:mp WEIGHTS
    PATH=. I >@{ FRONTIER
    STATE=. {: PATH
    if. STATE -: GOAL do. PATH return. end.
    FRONTIER=. (<<< I) { FRONTIER  NB. elision
    ADJACENCIES=. (STATE = SOURCE) # SINK
    FRONTIER=. FRONTIER , PATH <@,"1 0 ADJACENCIES
  end.
  EMPTY
)



NB. The specific problem

INPUT=: noun define
a	 b	 7
a	 c	 9
a	 f	 14
b	 c	 10
b	 d	 15
c	 d	 11
c	 f	 2
d	 e	 6
e	 f	 9
)

T=: parse_table INPUT
NAMED_LINKS=: _ 2 {. T
NODES=: ~. , NAMED_LINKS                NB. vector of boxed names
NUMBERED_LINKS=: NODES i. NAMED_LINKS
WEIGHTS=: _ ".&> _ _1 {. T
GRAPH=: NUMBERED_LINKS ,. WEIGHTS NB. GRAPH is the numerical representation


TERMINALS=: NODES (i. ;:) 'a e'

NODES {~ TERMINALS dijkstra GRAPH

Note 'Output'
┌─┬─┬─┬─┐
│a│c│d│e│
└─┴─┴─┴─┘

TERMINALS and GRAPH are integer arrays:

   TERMINALS
0 5

   GRAPH
0 1  7
0 2  9
0 3 14
1 2 10
1 4 15
2 4 11
2 3  2
4 5  6
5 3  9
)
