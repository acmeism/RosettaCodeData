def feigenbaum_delta(imax; jmax):
  def lpad: tostring | (" " *  (4 - length)) + .;
  def pp(i;x): "\(i|lpad)   \(x)";

  "Feigenbaum's delta constant incremental calculation:",
     pp("i"; "δ"),
     pp(1; "3.20"),
     ( foreach range(2; 1+imax) as $i (
         {a1: 1.0, a2: 0.0, d1: 3.2};

         .a = .a1 + (.a1 - .a2) / .d1
         | reduce range(1; 1+jmax) as $j (.;
             .x = 0 | .y = 0
             | reduce range(1; 1+pow(2;$i)) as $k (.;
                 .y = (1 - 2 * .x * .y)
                 | .x = .a - (.x * .x) )
             | .a -= (.x / .y) )
         | .d = (.a1 - .a2) / (.a - .a1)
         | .d1 = .d | .a2 = .a1 | .a1 = .a;
	    pp($i; .d) ) ) ;

feigenbaum_delta(13; 10)
