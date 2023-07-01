NB. first we nest each integer to the required depth, independently
NB. then we recursively merge deep boxes
NB. for consistency, if there are no integers, we box that empty list
dtree=: {{
  <^:(0=L.) merge <^:]each y
}}

merge=: {{
  if.(0=#$y)+.2>L.y do.y return.end.   NB. done if no deep boxes left
  shallow=. 2 > L."0 y                 NB. locate shallow boxes
  group=. shallow} (+/\ shallow),:-#\y NB. find groups of adjacent deep boxes
  merge each group ,each//. y          NB. combine them and recursively merge their contents
}}
