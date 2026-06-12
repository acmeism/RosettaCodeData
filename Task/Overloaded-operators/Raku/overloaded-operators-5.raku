class Line {
    has @.start;
    has @.end;
}

# New infix + multi to add two Lines together, for some bogus definition of add
multi infix:<+> (Line $x, Line $y) {
    Line.new(
       :start(
          sqrt($x.start[0]² + $y.start[0]²),
          sqrt($x.start[1]² + $y.start[1]²)
       ),
       :end(
          sqrt($x.end[0]² + $y.end[0]²),
          sqrt($x.end[1]² + $y.end[1]²)
       )
    )
}

# In operation:
say Line.new(:start(-4,7), :end(5,0)) + Line.new(:start(1,1), :end(2,3));
