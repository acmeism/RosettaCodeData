USING: arrays kernel locals math math.functions random sequences ;
IN: median

: pivot ( seq -- pivot ) random ;

: split ( seq pivot -- {lt,eq,gt} )
  [ [ < ] curry partition ] keep
  [ = ] curry partition
  3array ;

DEFER: nth-in-order
:: nth-in-order-recur ( seq ind -- elt )
  seq dup pivot split
  dup [ length ] map  0 [ + ] accumulate nip
  dup [ ind <= [ 1 ] [ 0 ] if ] map sum 1 -
  [ swap nth ] curry bi@
  ind swap -
  nth-in-order ;

: nth-in-order ( seq ind -- elt )
  dup 0 =
  [ drop first ]
  [ nth-in-order-recur ]
  if ;

: median ( seq -- median )
  dup length 1 - 2 / floor nth-in-order ;
