parse=: {{
  ref=: 2$L:1(;:each cut y) -.L:1 ;:'-'
  labels=: /:~~.;ref
  sparse=. (*:#labels) > 20*#ref
  graph=: (+.|:) 1 (labels i.L:1 ref)} $.^:sparse 0$~2##labels
}}

greedy=: {{
  colors=. (#y)#a:
  for_node.y do.
    color=. <{.(-.~ [:i.1+#) ~.;node#colors
    colors=. color node_index} colors
  end.
  ;colors
}}
