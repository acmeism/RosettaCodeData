# 20220705 Raku programming solution

my (@board, @diag1, @diag2, @diag1Lookup, @diag2Lookup, $n, $minCount, $layout);

my %limits   = ( my @pieces = <Q B K> ) Z=> 7,7,6; # >>=>>> 10;
my %names    = @pieces Z=> <Queens Bishops Knights>;

sub isAttacked(\piece, \row, \col) {
   given piece {
      when 'Q' {
         (^$n)>>.&{ return True if @board[$_;col] || @board[row;$_] }
	 return True if @diag1Lookup[@diag1[row;col]] ||
	                @diag2Lookup[@diag2[row;col]]
      }
      when 'B' {
         return True if @diag1Lookup[@diag1[row;col]] ||
                        @diag2Lookup[@diag2[row;col]]
      }
      default { # 'K'
         return True if (
            @board[row;col] or
            row+2 < $n && col-1 >= 0 && @board[row+2;col-1] or
            row-2 >= 0 && col-1 >= 0 && @board[row-2;col-1] or
            row+2 < $n && col+1 < $n && @board[row+2;col+1] or
            row-2 >= 0 && col+1 < $n && @board[row-2;col+1] or
            row+1 < $n && col+2 < $n && @board[row+1;col+2] or
            row-1 >= 0 && col+2 < $n && @board[row-1;col+2] or
            row+1 < $n && col-2 >= 0 && @board[row+1;col-2] or
            row-1 >= 0 && col-2 >= 0 && @board[row-1;col-2]
	 )
      }
   }
   return False
}

sub attacks(\piece, \row, \col, \trow, \tcol) {
   given piece {
      when 'Q' { row==trow || col==tcol || abs(row - trow)==abs(col - tcol) }
      when 'B' { abs(row - trow) == abs(col - tcol) }
      default  { my (\rd,\cd) = ((trow - row),(tcol - col))>>.abs; # when 'K'
                 (rd == 1 && cd == 2) || (rd == 2 && cd == 1)               }
   }
}

sub storeLayout(\piece) {
   $layout = [~] @board.map: -> @row {
      [~] ( @row.map: { $_ ??  piece~' ' !! '. ' } ) , "\n"
   }
}

sub placePiece(\piece, \countSoFar, \maxCount) {
   return if countSoFar >= $minCount;
   my ($allAttacked,$ti,$tj) = True,0,0;
   for ^$n X ^$n -> (\i,\j) {
      unless isAttacked(piece, i, j) {
         ($allAttacked,$ti,$tj) = False,i,j andthen last
      }
      last unless $allAttacked
   }
   if $allAttacked {
      $minCount = countSoFar;
      storeLayout(piece);
      return
   }
   if countSoFar <= maxCount {
      my ($si,$sj) = $ti,$tj;
      if piece eq 'K' {
         ($si,$sj) >>-=>> 2;
         $si = 0 if $si < 0;
         $sj = 0 if $sj < 0;
      }
      for ($si..^$n) X ($sj..^$n) -> (\i,\j) {
         unless isAttacked(piece, i, j) {
            if (i == $ti && j == $tj) || attacks(piece, i, j, $ti, $tj) {
               @board[i][j] = True;
               unless piece eq 'K' {
	          (@diag1Lookup[@diag1[i;j]],@diag2Lookup[@diag2[i;j]])=True xx *
               }
               placePiece(piece, countSoFar+1, maxCount);
               @board[i][j] = False;
               unless piece eq 'K' {
                  (@diag1Lookup[@diag1[i;j]],@diag2Lookup[@diag2[i;j]])=False xx *
               }
            }
	 }
      }
   }
}

for @pieces -> \piece {
   say %names{piece}~"\n=======\n";
   loop ($n = 1 ; ; $n++) {
      @board = [ [ False xx $n ] xx $n ];
      unless piece eq 'K' {
         @diag1 = ^$n .map: { $_ ... $n+$_-1 } ;
         @diag2 = ^$n .map: { $n+$_-1 ... $_ } ;
	 @diag2Lookup = @diag1Lookup = [ False xx 2*$n-1 ]
      }
      $minCount = 2³¹ - 1; # golang: math.MaxInt32
      my \nSQ   = $n*$n;
      for 1..nSQ -> \maxCount {
         placePiece(piece, 0, maxCount);
         last if $minCount <= nSQ
      }
      printf("%2d x %-2d : %d\n", $n, $n, $minCount);
      if $n == %limits{piece} {
         printf "\n%s on a %d x %d board:\n", %names{piece}, $n, $n;
         say $layout andthen last
      }
   }
}
