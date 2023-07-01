USING: backtrack kernel math.ranges prettyprint sequences sets ;
101 <iota> [ 0 6 9 20 [ 100 swap <range> amb-lazy ] tri@ ] bag-of diff last .
