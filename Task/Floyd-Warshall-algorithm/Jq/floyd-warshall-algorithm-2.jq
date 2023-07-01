def fwi:
  . as $weights
  | keys_unsorted as $nodes
  # construct the dist matrix
  | reduce $nodes[] as $u ({};
      reduce $nodes[] as $v (.;
        .[$u][$v] = infinite))
  | reduce $nodes[] as $u (.; .[$u][$u] = 0 )
  | reduce $nodes[] as $u (.;
      reduce ($weights[$u]|keys_unsorted[]) as $v (.;
        .[$u][$v] = $weights[$u][$v] ))
  | reduce $nodes[] as $w (.;
      reduce $nodes[] as $u (.;
        reduce $nodes[] as $v (.;
      (.[$u][$w] + .[$w][$v]) as $x
      | if .[$u][$v] > $x then .[$u][$v] = $x
        else . end )))
;


weights | fwi
