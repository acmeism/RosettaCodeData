floyd:{n:1+ til sum 1+til x;
       t:d:0;
       while[1+x-:1;0N!(t+:1)#(d+:t)_n]}

floyd2:{n:1+ til sum 1+til x;
        t:d:0;
        while[1+x-:1;1 (" " sv string each (t+:1)#(d+:t)_n),"\n"]}

//The latter function 'floyd2' includes logic to remove the leading "," before "1" in the first row.

floyd[5]
floyd2[14]
