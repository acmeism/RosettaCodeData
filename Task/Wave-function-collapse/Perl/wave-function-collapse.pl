use v5.36;
use experimental 'for_list';

my @Blocks = ( [ <0 0 0>, <0 0 0>, <0 0 0> ],
               [ <0 0 0>, <1 1 1>, <0 1 0> ],
               [ <0 1 0>, <0 1 1>, <0 1 0> ],
               [ <0 1 0>, <1 1 1>, <0 0 0> ],
               [ <0 1 0>, <1 1 0>, <0 1 0> ],
             );

sub X($a,$b) { my @c; for my $aa (0..$a-1) { map { push @c, $aa, $_ } 0..$b-1 } @c }

sub  XY(       $row, $col, $width)          { $col + $row * $width }
sub XYZ($page, $row, $col, $height, $width) { XY( XY($page, $row, $height), $col, $width) }

sub wfc($B, $bdim, $tdim) {
   my ($td0,$td1) = @$tdim;
   my $N = $td0 * $td1;
   my @blocks = map @$_, @$B; # flatten

   my @adj; # indices in R of the four adjacent blocks
   for my($i,$j) (X $td0, $td1) {
      $adj[XYZ($i, $j, 0, $td1, 4)] = XY(($i-1)%$td0,  $j   %$td1, $td1); # above (index 1)
      $adj[XYZ($i, $j, 1, $td1, 4)] = XY( $i   %$td0, ($j-1)%$td1, $td1); # left  (index 3)
      $adj[XYZ($i, $j, 2, $td1, 4)] = XY( $i   %$td0, ($j+1)%$td1, $td1); # right (index 5)
      $adj[XYZ($i, $j, 3, $td1, 4)] = XY(($i+1)%$td0,  $j   %$td1, $td1); # below (index 7)
   }

   my ($bd0,$bd1,$bd2) = @$bdim;
   my @horz; # blocks which can sit next to each other horizontally
   for my($i,$j) (X $bd0, $bd0) {
      @horz[XY($i,$j,$bd0)] = 1;
      for my $k (0..$bd1-1) {
         $horz[XY($i, $j, $bd0)]= 0 if $blocks[XYZ($i, $k,      0, $bd1, $bd2)]
                                    != $blocks[XYZ($j, $k, $bd2-1, $bd1, $bd2)]
      }
   }

   my @vert; # blocks which can sit next to each other vertically */
   for my($i,$j) (X $bd0, $bd0) {
      $vert[XY($i,$j,$bd0)] = 1;
      for my $k (0..$bd2-1) {
         if ($blocks[XYZ($i, 0, $k, $bd1, $bd2)] != $blocks[XYZ($j, $bd1-1, $k, $bd1, $bd2)]) {
            $vert[XY($i, $j, $bd0)] = 0;
            last
         }
      }
   }

   my @allow = (1) x (4*($bd0+1)*$bd0); # all block constraints, based on neighbors
   for my($i,$j) (X $bd0, $bd0) {
      $allow[XYZ(0, $i, $j, $bd0+1, $bd0)] = $vert[XY($j, $i, $bd0)]; # above (north)
      $allow[XYZ(1, $i, $j, $bd0+1, $bd0)] = $horz[XY($j, $i, $bd0)]; # left  (west)
      $allow[XYZ(2, $i, $j, $bd0+1, $bd0)] = $horz[XY($i, $j, $bd0)]; # right (east)
      $allow[XYZ(3, $i, $j, $bd0+1, $bd0)] = $vert[XY($i, $j, $bd0)]; # below (south)
   }

   my @R = ($bd0) x $N;
   my (@todo, @wave, @entropy, @indices, $min, @possible);

   while () {
      my $c;
      for (0..$N-1) { $todo[$c++] = $_ if $bd0 == $R[$_] }
      last unless $c;
      $min = $bd0;
      for my $i (0..$c-1) {
         $entropy[$i] = 0;
         for my $j (0..$bd0-1) {
            $entropy[$i] +=
               $wave[XY($i, $j, $bd0)] =
                  $allow[XYZ(0, $R[ $adj[XY($todo[$i],0,4)] ], $j, $bd0+1, $bd0)] &
                  $allow[XYZ(1, $R[ $adj[XY($todo[$i],1,4)] ], $j, $bd0+1, $bd0)] &
                  $allow[XYZ(2, $R[ $adj[XY($todo[$i],2,4)] ], $j, $bd0+1, $bd0)] &
                  $allow[XYZ(3, $R[ $adj[XY($todo[$i],3,4)] ], $j, $bd0+1, $bd0)]
         }
         $min = $entropy[$i] if $entropy[$i] < $min
      }

      @R=[] and last unless $min;

      my $d = 0;
      for (0..$c-1) { $indices[$d++] = $_ if $min == $entropy[$_] }
      my $ind = $bd0 * (my $ndx = $indices[ int rand $d ]);
      $d = 0;
      for (0..$bd0-1) { $possible[$d++] = $_ if $wave[$ind+$_]  }
      $R[$todo[$ndx]] = $possible[ int rand $d ];
   }

   return "DOES NOT COMPUTE" unless @R > 1;

   my @tile;
   for my($i0,$i1)(X $td0, $bd1) {
       for my($j0,$j1) (X $td1, $bd2) {
           $tile[XY(XY($j0, $j1, $bd2-1), XY($i0, $i1, $bd1-1), 1+$td1*($bd2-1))] =
                (' ','#')[ $blocks[XYZ($R[XY($i0, $j0, $td1)], $i1, $j1, $bd1, $bd2)] ]
       }
   }
   my $width = 2 * sqrt scalar @tile;
   join(' ', @tile) =~ s/.{$width}\K(?=.)/\n/gr;
}

my @bdims = (5,3,3);
my @size  = (8,8);
say wfc(\@Blocks, \@bdims, \@size);
