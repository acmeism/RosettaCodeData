use strict;
use feature 'say';

my @Example = ();

sub checkSeq {
   my($pos, $n, $minLen, @seq) = @_;
   if ($pos > $minLen || $seq[0] > $n) {
      return $minLen, 0;
   } elsif ($seq[0] == $n) {
      @Example = @seq;
      return $pos, 1;
   } elsif ($pos < $minLen) {
      return tryPerm(0, $pos, $n, $minLen, @seq);
   } else {
      return $minLen, 0;
   }
}

sub tryPerm {
   my($i, $pos, $n, $minLen, @seq) = @_;
   return $minLen, 0 if $i > $pos;
   my @res1 = checkSeq($pos+1, $n, $minLen, ($seq[0]+$seq[$i],@seq));
   my @res2 = tryPerm($i+1, $pos, $n, $res1[0], @seq);
   if ($res2[0] < $res1[0]) {
      return $res2[0], $res2[1];
   } elsif ($res2[0] == $res1[0]) {
      return $res2[0], $res1[1]+$res2[1];
   } else {
      say "Error in tryPerm";
      return 0, 0;
   }
}

sub initTryPerm {
   my($x, $minLen) = @_;
   return tryPerm(0, 0, $x, $minLen, (1));
}

sub findBrauer {
   my($num, $minLen, $nbLimit) = @_;
   my ($actualMin, $brauer) = initTryPerm($num, $minLen);
   say "\nN = ". $num;
   say "Minimum length of chains : L($num) = $actualMin";
   say "Number of minimum length Brauer chains : ". $brauer;
   say "Brauer example : ". join ' ', reverse @Example if $brauer > 0;
   @Example = ();
   if ($num <= $nbLimit) {
      my $nonBrauer = findNonBrauer($num, $actualMin+1, $brauer);
      say "Number of minimum length non-Brauer chains : ". $nonBrauer;
      say "Non-Brauer example : ". join ' ', @Example if $nonBrauer > 0;
      @Example = ();
   } else {
      say "Non-Brauer analysis suppressed";
   }
}

sub isAdditionChain {
   my(@a) = @_;
   for my $i (2 .. $#a) {
      return 0 if $a[$i] > $a[$i-1]*2;
      my $ok = 0;
      for my $j (reverse 0 .. $i-1) {
          for my $k (reverse 0 .. $j) {
            $ok = 1, last if $a[$j]+$a[$k] == $a[$i];
         }
      }
      return 0 unless $ok;
   }
   @Example = @a if !isBrauer(@a) and !@Example;
   return 1;
}

sub isBrauer {
   my(@a) = @_;
   for my $i (2 .. $#a) {
      my $ok = 0;
      for my $j (reverse 0 .. $i-1) {
         $ok = 1, last if $a[$i-1]+$a[$j] == $a[$i];
      }
      return 0 unless $ok;
   }
   return 1;
}

sub findNonBrauer {
   our($num, $len, $brauer) = @_;
   our @seq = 1 .. $len-1; push @seq, $num;
   our $count = isAdditionChain(@seq) ? 1 : 0;

   sub nextChains {
      my($index) = @_;
      while () {
         nextChains($index+1) if $index < $len-1;
         return if ($seq[$index]+$len-1-$index >= $seq[$len-1]);
         $seq[$index]++;
         for ($index+1 .. $len-2) { $seq[$_] = $seq[$_-1] + 1;}
         $count++ if isAdditionChain(@seq);
      }
   }

   nextChains(2);
   return $count - $brauer;
}

my @nums = (7, 14, 21, 29, 32, 42, 64);  # unlock below for extra credits,
                                         # 47, 79, 191, 382, 379, 379, 12509);
say "Searching for Brauer chains up to a minimum length of 12:";
for (@nums) { findBrauer $_, 12, 79 }
