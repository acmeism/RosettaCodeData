: line ( e dy d dx c n -- )
  spaces dup >r emit
  9 *  1- 0 do dup emit loop drop
  r> emit
  spaces emit cr
;

: cuboid { dz dy dx -- }
  cr
  bl 0 '- dx '+ dy 1+ line
  dy 0 ?do
    '| i bl dx '/ dy i - line loop
  '| dy '- dx '+ 0 line
  dz 4 * dy - 2 - 0 ?do
    '| dy bl dx '| 0 line loop
  '+ dy bl dx '| 0 line
  dy 0 ?do
    '/ dy i - 1- bl dx '| 0 line loop
  bl 0 '- dx '+ 0 line
;
