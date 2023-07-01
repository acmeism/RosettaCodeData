C:``one`two`three`four`five`six`seven`eight`nine`ten,
  `eleven`twelve`thirteen`fourteen`fifteen`sixteen`seventeen`eighteen`nineteen                             / cardinal numbers <20

T:``ten`twenty`thirty`forty`fifty`sixty`seventy`eighty`ninety                                              / tens
M:``thousand`million`billion`trillion`quadrillion`quintillion`sextillion`septillion                        / magnitudes

st:{                                                                                                       / stringify <1000
  $[x<20; C x;
    x<100; (T;C)@'10 vs x;
    {C[y],`hundred,$[z=0;`;x z]}[.z.s] . 100 vs x] }

s:{$[x=0; "zero"; {" "sv string except[;`]raze x{$[x~`;x;x,y]}'M reverse til count x} st each 1000 vs x]}  / stringify

fim:{@[;0;upper],[;"four is magic.\n"] raze 1_{y," is ",x,", "}prior s each(count s@)\[x]}                 / four is magic

1 raze fim each 0 4 8 16 25 89 365 2586 25865 369854 40000000001;                                          / tests
