# 20250625 Raku programming solution

class BitRank {
   has array[uint64] $.block is rw;
   has array[uint]   $.count is rw;

   method Resize(Int $num) {
      my $size = ($num + 1) +> 6 + 1;
      self.block = array[uint64].new: 0 xx $size;
      self.count =   array[uint].new: 0 xx $size;
   }

   method SetOne(Int $i, Int $val) {
      if $val == 1 { $.block[$i +> 6] +|= (1 +< ($i +& 63)) }
   }

   method popcountll(uint64 $n is copy) returns Int {
      loop ( my $count = 0 ; $n > 0 ; $count++ ) { $n +&= $n - 1 }
      return $count
   }

   method Rank1(Int $i) returns Int {
      $.count[$i +> 6] + self.popcountll($.block[$i +> 6] +& ((1 +< ($i +& 63)) - 1));
   }

   method Rank1FromTo(Int $i, Int $j) returns Int {
      return self.Rank1($j) - self.Rank1($i);
   }

   method Rank0(Int $i) returns Int { return $i - self.Rank1($i) }

   method Rank0FromTo(Int $i, Int $j) returns Int {
      return self.Rank0($j) - self.Rank0($i)
   }
}

class WaveletMatrix {
   has Int     $.height is rw;
   has BitRank @.B      is rw;
   has Int     @.pos    is rw;

   method new(@vec, Int :$sigma?) { self.bless(:@vec, :$sigma) }

   submethod BUILD(:@vec, Int :$sigma?) {
      my $s = $sigma // (@vec.max + 1);
      self.height = $s <= 1 ?? 1 !! ($s - 1).base(2).chars;
      self.B = BitRank.new xx self.height;
      self.pos = 0 xx self.height;

      for ^self.height -> $i {
         my $br = BitRank.new;
         $br.Resize(@vec.elems);
         for ^@vec.elems -> $j {
            $br.SetOne($j, self.get(@vec[$j], self.height - $i - 1));
         }
         self.B[$i] = $br;
         self.pos[$i] = self.stablePartition(@vec, -> $c { self.get($c, self.height - $i - 1) == 0 });
       }
   }

   method stablePartition(@arr, &predicate) returns Int {
      my $partition = @arr.classify: { &predicate($_) ?? 'true' !! 'false' };
      @arr = do given $partition { |.<true>, |.<false> }
      return $partition.<true>.elems
   }

   method get(Int $val, Int $i) returns Int { return ($val +> $i) +& 1 }

   method Rank(Int $val, Int $l, Int $r) returns Int {
      return self.RankSingle($val, $r) - self.RankSingle($val, $l);
   }

   method RankSingle(Int $val, Int $i) returns Int {
      my ($p, $idx) = 0, $i;
      for 0 ..^ $.height -> $j {
         if self.get($val, $.height - $j - 1) == 1 {
            $p = @.pos[$j] + @.B[$j].Rank1($p);
            $idx = @.pos[$j] + @.B[$j].Rank1($idx);
         } else {
            $p = @.B[$j].Rank0($p);
            $idx = @.B[$j].Rank0($idx);
         }
      }
      return $idx - $p;
   }

   method Quantile(Int $k, Int $l, Int $r) returns Int {
      my ($res, $left, $right, $kth) = 0, $l, $r, $k;
      for 0 ..^ $.height -> $i {
         my $j = @.B[$i].Rank0FromTo($left, $right);
         if $j > $kth {
            $left  = @.B[$i].Rank0($left);
            $right = @.B[$i].Rank0($right);
         } else {
            $left  = @.pos[$i] + @.B[$i].Rank1($left);
            $right = @.pos[$i] + @.B[$i].Rank1($right);
            $kth  -= $j;
            $res +|= (1 +< ($.height - $i - 1));
         }
      }
      return $res
   }

   method RangeFreq(Int $l, Int $r, Int $a, Int $b) returns Int {
      return self.rangeFreqRecursive($l, $r, $a, $b, 0, 1 +< $.height, 0)
   }

   method rangeFreqRecursive(Int $i, Int $j, Int $a, Int $b, Int $l, Int $r, Int $x) returns Int {
      if $i == $j || $r <= $a || $b <= $l { return 0 }
      my $mid = ($l + $r) +> 1;
      if $a <= $l && $r <= $b {
         return $j - $i;
      } else {
         my $left  = self.rangeFreqRecursive( @.B[$x].Rank0($i),
                                              @.B[$x].Rank0($j),
                                              $a, $b, $l, $mid, $x + 1);
         my $right = self.rangeFreqRecursive( @.pos[$x] + @.B[$x].Rank1($i),
                                              @.pos[$x] + @.B[$x].Rank1($j),
                                              $a, $b, $mid, $r, $x + 1);
         return $left + $right
       }
   }

   method rangeMinRecursive(Int $i, Int $j, Int $a, Int $b, Int $l, Int $r, Int $x, Int $val) returns Int {
      return -1   if $i == $j || $r <= $a || $b <= $l;
      return $val if $r - $l == 1;
      my $mid = ($l + $r) +> 1;
      my $res = self.rangeMinRecursive( @.B[$x].Rank0($i),
                                        @.B[$x].Rank0($j),
                                        $a, $b, $l, $mid, $x + 1, $val);
      if $res < 0 {
         return self.rangeMinRecursive( @.pos[$x] + @.B[$x].Rank1($i),
                                        @.pos[$x] + @.B[$x].Rank1($j),
                                        $a, $b, $mid, $r, $x + 1,
                                        $val + (1 +< ($.height - $x - 1)))
      } else {
         return $res
      }
   }
}

sub find(@arr, Int $x) returns Int {
   my ($left, $right) = 0, @arr.elems;

   while $left < $right {
      my $mid = ($left + $right) div 2;
      @arr[$mid] < $x ?? ( $left = $mid + 1 ) !! ( $right = $mid );
   }
   return $left
}

sub MAIN() {
   my $n = 5;
   my @a = 3374, 956, 2114, 3415, 3437;
   my @input = my @backup = @a;
   my @uniqueA = @a.sort.unique;

   for ^$n -> $i { @input[$i] = find(@uniqueA, @backup[$i]) }

   my @lrkVector = [ [2, 2, 1], [3, 4, 1], [4, 5, 1], [1, 2, 2], [4, 4, 1], ];

   my $wm = WaveletMatrix.new(@input);

   for @lrkVector -> [$l, $r, $k] {
      my $l_idx = $l - 1; # Convert to 0-indexed
      say @uniqueA[$wm.Quantile($k - 1, $l_idx, $r)];
   }
}
