barrier=: 2 4,2 5,2 6,3 6,4 6,5 6,5 5,5 4,5 3,5 2,4 2,:3 2
price=: _,.~_,~100 barrier} 8 8$1
dirs=: 0 0-.~>,{,~<i:1
start=: 0 0
end=: 7 7

next=: {{
   frontier=. ~.locs=. ,/dests=. ($price)|"1 ({:"2 y)+"1/dirs
   paths=. ,/y,"2 1/"2 dests
   costs=. ,x+(<"1 dests){price
   deals=. (1+locs <.//. costs) <. (<"1 frontier) { values
   keep=. costs < (frontier i. locs) { deals
   (keep#costs);keep#paths
}}

Asrch=: {{
  values=: ($price)$_
  best=: ($price)$a:
  paths=: ,:,:start
  costs=: ,0
  while. #paths do.
    dests=. <"1 {:"2 paths
    values=: costs dests} values
    best=: (<"2 paths) dests} best
    'costs paths'=.costs next paths
  end.
  ((<end){values) ; (<end){best
}}
