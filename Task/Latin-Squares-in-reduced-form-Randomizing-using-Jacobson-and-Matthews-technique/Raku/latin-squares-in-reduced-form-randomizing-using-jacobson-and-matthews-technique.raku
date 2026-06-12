# 20210729 Raku programming solution

#!/usr/bin/env raku

sub makeCube(\from, Int \n) {
   my @c = [[[ 0 xx n ] xx n ] xx n ];
   from.Bool ?? do race for ^n X ^n -> (\i,\j) { @c[i;j; { from[i;j]-1 } ] = 1 }
             !! do race for ^n X ^n -> (\i,\j) { @c[i;j; {   (i+j)%n   } ] = 1 }
   return @c
}

sub shuffleCube(@c) {
   my ($rx, $ry, $rz); my \n = +@c; my Bool \proper = $ = True;

   repeat { ($rx ,$ry, $rz) = (^n).roll: 3 } until @c[$rx;$ry;$rz] == 0;
   loop {
      my ($ox, $oy, $oz);
      for ^n { last if @c[ $ox = $_ ;$ry;$rz] == 1 }
      if !proper and (^3).roll==0 {
         for $ox^…^n { last if @c[ $ox = $_ ;$ry;$rz] == 1 }
      }
      for ^n { last if @c[$rx; $oy = $_ ;$rz] == 1 }
      if !proper and (^3).roll==0 {
         for $oy^…^n { last if @c[$rx; $oy = $_ ;$rz] == 1 }
      }
      for ^n { last if @c[$rx;$ry;  $oz = $_ ] == 1 }
      if !proper and (^3).roll==0 {
         for $oz^…^n { last if @c[$rx;$ry; $oz = $_ ] == 1 }
      }

      (@c[$rx;$ry;$rz],@c[$rx;$oy;$oz],@c[$ox;$ry;$oz],@c[$ox;$oy;$rz]) »+=»1;
      (@c[$rx;$ry;$oz],@c[$rx;$oy;$rz],@c[$ox;$ry;$rz],@c[$ox;$oy;$oz]) »-=»1;

      @c[$ox;$oy;$oz] < 0 ?? (($rx,$ry,$rz) = ($ox,$oy,$oz)) !! last ;
      proper = False
   }
}

sub toMatrix(@c) {
   my \n = +@c;
   my @m = [[0 xx n] xx n];
   for ^n X ^n -> (\i,\j) {
      for ^n -> \k { if @c[i;j;k] != 0 { @m[i;j] = k and last } }
   }
   return @m
}

sub toReduced(@m is copy) {
   my \n = +@m;
   for 0…(n-2) -> \j {
      if ( @m[0;j] != j ) {
         for j^…^n -> \k {
            if ( @m[0;k] == j ) {
               for 0…^n -> \i { (@m[i;j], @m[i;k]) = (@m[i;k], @m[i;j]) }
               last
            }
         }
      }
   }
   for 1…(n-2) -> \i {
      if ( @m[i;0] != i ) {
         for i^…^n -> \k {
            if ( @m[k;0] == i ) {
               for 0…^n -> \j { (@m[i;j], @m[k;j]) = (@m[k;j], @m[i;j]) }
               last
            }
         }
      }
   }
   return @m
}

sub printAs1based { say ($_ »+» 1).Str for @_.rotor: @_.elems.sqrt }

my (%freq, @c, @in);

say "Part 1: 10,000 latin Squares of order 4 in reduced form:\n";
@in = [[1, 2, 3, 4], [2, 1, 4, 3], [3, 4, 1, 2], [4, 3, 2, 1]];
@c = makeCube(@in, 4);
for ^10_000 {
   shuffleCube @c ;
   %freq{@c.&toMatrix.&toReduced».List.flat.Str}++
}
for %freq.kv -> $k, $v {
   printAs1based $k.split(' ');
   say "\nOccurs $v times.\n"
}

say "Part 2: 10,000 latin Squares of order 5 in reduced form:\n";
@in = [ [1,2,3,4,5], [2,3,4,5,1], [3,4,5,1,2], [4,5,1,2,3], [5,1,2,3,4] ];
%freq = ();
@c = makeCube(@in, 5);
for ^10_000 {
   shuffleCube @c ;
   %freq{@c.&toMatrix.&toReduced».List.flat.Str}++
}
for %freq.values.kv -> $i, $j { printf "%2d(%3d)%s", $i+1, $j, ' ' }

say "\n\nPart 3: 750 latin squares of order 42, showing the last one:\n";
@c = makeCube([], 42); # (1..42).pick(*)
( for ^750 { shuffleCube @c } ) and printAs1based @c.&toMatrix».List.flat ;

say "\nPart 4: 100 latin squares of order 256:\n";
my $snapshot = now;
@c = makeCube([], 256);
for ^100 { shuffleCube @c } # without hyper, will do only 100 cycles
say "Generated in { now - $snapshot } seconds."
