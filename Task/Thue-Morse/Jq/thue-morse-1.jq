def thueMorse:
  0,
  ({sb0: "0", sb1: "1", n:1 }
   | while( true;
      {n: (.sb0|length),
       sb0: (.sb0 + .sb1),
       sb1: (.sb1 + .sb0)} )
   | .sb0[.n:]
   | explode[]
   | . - 48);
