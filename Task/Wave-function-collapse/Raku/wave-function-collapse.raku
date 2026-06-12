# 20220728 Raku programming solution

my @Blocks = ( [   <0 0 0>,
                   <0 0 0>,
         <0 0 0>    ],
               [   <0 0 0>,
              <1 1 1>,
         <0 1 0>    ],
               [   <0 1 0>,
              <0 1 1>,
               <0 1 0>    ],
               [   <0 1 0>,
              <1 1 1>,
               <0 0 0>    ],
               [   <0 1 0>,
              <1 1 0>,
               <0 1 0>    ], );

sub XY(\row, \col, \width) { col+row*width }
sub XYZ(\page, \row, \col, \height, \width) {
   XY( XY(page, row, height), col, width)
}

sub wfc(@blocks, @bdim, @tdim) {

   my \N  = [*] my (\td0,\td1) = @tdim[0,1];
   my @adj; # indices in R of the four adjacent blocks
   for ^td0 X ^td1 -> (\i,\j) {                        # in a 3x3 grid
      @adj[XYZ(i,j,0,td1,4)]= XY((i-1)%td0,j%td1,td1); # above (index 1)
      @adj[XYZ(i,j,1,td1,4)]= XY(i%td0,(j-1)%td1,td1); # left  (index 3)
      @adj[XYZ(i,j,2,td1,4)]= XY(i%td0,(j+1)%td1,td1); # right (index 5)
      @adj[XYZ(i,j,3,td1,4)]= XY((i+1)%td0,j%td1,td1); # below (index 7)
   }

   my (\bd0,\bd1,\bd2) = @bdim[0..2];
   my @horz; # blocks which can sit next to each other horizontally
   for ^bd0 X ^bd0 -> (\i,\j) {
      @horz[XY(i,j,bd0)] = 1;
      for ^bd1 -> \k {
         @horz[XY(i, j, bd0)]= 0 if @blocks[XYZ(i, k,     0, bd1, bd2)] !=
                               @blocks[XYZ(j, k, bd2-1, bd1, bd2)]
      }
   }

   my @vert; # blocks which can sit next to each other vertically */
   for  ^bd0 X ^bd0 -> (\i,\j) {
      @vert[XY(i,j,bd0)] = 1;
      for ^bd2 -> \k {
         if @blocks[XYZ(i,     0, k, bd1, bd2)] !=
       @blocks[XYZ(j, bd1-1, k, bd1, bd2)] {
       @vert[XY(i, j, bd0)]= 0 andthen last;
    }
      }
   }

   my @allow = 1 xx 4*(bd0+1)*bd0; # all block constraints, based on neighbors
   for  ^bd0 X ^bd0 -> (\i,\j) {
      @allow[XYZ(0, i, j, bd0+1, bd0)] = @vert[XY(j, i, bd0)]; # above (north)
      @allow[XYZ(1, i, j, bd0+1, bd0)] = @horz[XY(j, i, bd0)]; # left  (west)
      @allow[XYZ(2, i, j, bd0+1, bd0)] = @horz[XY(i, j, bd0)]; # right (east)
      @allow[XYZ(3, i, j, bd0+1, bd0)] = @vert[XY(i, j, bd0)]; # below (south)
   }

   my (@R, @todo, @wave, @entropy, @indices, $min, @possible) = bd0 xx N;
   loop {
      my $c = 0;
      for ^N { @todo[$c++] = $_ if bd0 == @R[$_] }
      last unless $c;
      $min = bd0;
      for ^$c -> \i {
         @entropy[i]= 0;
         for ^bd0 -> \j {
            @entropy[i] +=
               @wave[XY(i, j, bd0)] =
                  @allow[XYZ(0, @R[@adj[XY(@todo[i],0,4)]], j, bd0+1, bd0)] +&
                  @allow[XYZ(1, @R[@adj[XY(@todo[i],1,4)]], j, bd0+1, bd0)] +&
                  @allow[XYZ(2, @R[@adj[XY(@todo[i],2,4)]], j, bd0+1, bd0)] +&
                  @allow[XYZ(3, @R[@adj[XY(@todo[i],3,4)]], j, bd0+1, bd0)]
         }
    $min = @entropy[i] if @entropy[i] < $min
      }

      unless $min { @R=[] andthen last } # original behaviour
      #unless $min { @R = bd0 xx N andthen redo } # if failure is not an option

      my $d = 0;
      for ^$c { @indices[$d++] = $_ if $min == @entropy[$_] }
      my \ind = bd0 * my \ndx = @indices[ ^$d .roll ];
      $d = 0;
      for ^bd0 { @possible[$d++] = $_ if @wave[ind+$_]  }
      @R[@todo[ndx]] = @possible[ ^$d .roll ];
   }

   exit unless @R.Bool;

   my @tile;
   for ^td0 X ^bd1 X ^td1 X ^bd2 -> (\i0,\i1,\j0,\j1) {
      @tile[XY(XY(j0, j1, bd2-1), XY(i0, i1, bd1-1), 1+td1*(bd2-1))] =
         @blocks[XYZ(@R[XY(i0, j0, td1)], i1, j1, bd1, bd2)]
   }

   return @tile
}

my (@bdims,@size) := (5,3,3), (8,8);

my @tile = wfc @Blocks».List.flat, @bdims, @size  ;

say .join.trans( [ '0', '1' ] => [ '  ', '# ' ] ) for @tile.rotor(17)
