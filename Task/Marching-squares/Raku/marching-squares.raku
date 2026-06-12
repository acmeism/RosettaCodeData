# 20220708 Raku programming solution

enum <E N W S>;
my (@dx,@dy) := (1,0,-1,0), (0,-1,0,1);
my \example   = ((0, 0, 0, 0, 0),
                 (0, 0, 0, 0, 0),
                 (0, 0, 1, 1, 0),
                 (0, 0, 1, 1, 0),
                 (0, 0, 0, 1, 0),
                 (0, 0, 0, 0, 0));

printf("X: %d, Y: %d, Path: %s\n", identifyPerimeter(example));

sub identifyPerimeter(\data) {

   my (\height,\width) = { .elems, .first.elems }(data);

   for ^width X ^height -> (\x,\y) {
      if data[y;x] {
         my ($cx,$cy,$directions,$previous) = x, y;
         repeat {
            my $mask;
            for (0,0,1),(1,0,2),(0,1,4),(1,1,8) -> (\dx,\dy,\b) {
	       my ($mx,$my) = $cx+dx,$cy+dy;
	       $mask += b if all $mx>1, $my>1, data[$my-1;$mx-1]
            }
            given do given $mask {
               when * ∈ ( 1,  5, 13 ) { N }
               when * ∈ ( 2,  3,  7 ) { E }
               when * ∈ ( 4, 12, 14 ) { W }
               when * ∈ ( 8, 10, 11 ) { S }
               when * ∈ (     6     ) { $previous == N ?? W !! E }
               when * ∈ (     9     ) { $previous == E ?? N !! S }
            } {
	       $directions ~= $previous = $_ ;
	       ($cx,$cy) <<+=<< (@dx[.value], @dy[.value])
	    }
         } until $cx==x and $cy==y ;
         return x, -y, $directions
      }
   }
   return -1, -1, "Not found!"
}
