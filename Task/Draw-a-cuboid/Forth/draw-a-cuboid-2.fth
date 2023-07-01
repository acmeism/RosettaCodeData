: hline ( char len )
  0 ?do dup emit loop drop ;
: vline ( char len )
  0 ?do dup emit -1 1 at-deltaxy loop drop ;

: cuboid { dz dy dx -- }
  page
  dy 0 ?do   dy i -   i        at-xy   '# dx hline loop
  dz 0 ?do   0        dy i +   at-xy   '+ dx hline loop
  dy 0 ?do   dx i +   dy i -   at-xy   '/ dz vline loop
;
