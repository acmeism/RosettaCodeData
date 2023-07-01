def count(class; m; n):
  reduce (range(m;n) | [.] | implode | select( test( "\\p{" + class + "}" ))) as $i
    (0; . + 1);
