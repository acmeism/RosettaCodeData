ex1=:'0-1 1-2 2-0 3'
ex2=:'1-6 1-7 1-8 2-5 2-7 2-8 3-5 3-6 3-8 4-5 4-6 4-7'
ex3=:'1-4 1-6 1-8 3-2 3-6 3-8 5-2 5-4 5-8 7-2 7-4 7-6'
ex4=:'1-6 7-1 8-1 5-2 2-7 2-8 3-5 6-3 3-8 4-5 4-6 4-7'
require'format/printf'
require'format/printf'
task=: {{
  colors=. greedy parse y
  echo'nodes: %d, edges: %d, colours: %d' sprintf #each graph;ref;~.colors
  edgecolors=. <@(,&":':',&":])/"1(>labels i.L:1 ref){colors
  ,./>' ',.~each^:2(cut y),:each edgecolors
}}

   task ex1
nodes: 4, edges: 4, colours: 3
0-1  1-2  2-0  3
0:1  1:2  2:0  0:0

   task ex2
nodes: 8, edges: 12, colours: 2
1-6  1-7  1-8  2-5  2-7  2-8  3-5  3-6  3-8  4-5  4-6  4-7
0:1  0:1  0:1  0:1  0:1  0:1  0:1  0:1  0:1  0:1  0:1  0:1

   task ex3
nodes: 8, edges: 12, colours: 4
1-4  1-6  1-8  3-2  3-6  3-8  5-2  5-4  5-8  7-2  7-4  7-6
0:1  0:2  0:3  1:0  1:2  1:3  2:0  2:1  2:3  3:0  3:1  3:2

   task ex4
nodes: 8, edges: 12, colours: 2
1-6  7-1  8-1  5-2  2-7  2-8  3-5  6-3  3-8  4-5  4-6  4-7
0:1  1:0  1:0  1:0  0:1  0:1  0:1  1:0  0:1  0:1  0:1  0:1
