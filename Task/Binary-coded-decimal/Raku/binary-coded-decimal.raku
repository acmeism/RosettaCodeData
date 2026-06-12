# 20220930 Raku programming solution

class Bcd64 { has uint64 $.bits }

multi infix:<⊞> (Bcd64 \p, Bcd64 \q) {
   my $t1 = p.bits + 0x0666_6666_6666_6666;
   my $t2 = ( $t1 + q.bits ) % uint64.Range.max ;
   my $t3 = $t1 +^ q.bits;
   my $t4 = +^($t2 +^ $t3) +& 0x1111_1111_1111_1110;
   my $t5 = ($t4 +> 2) +| ($t4 +> 3);
   Bcd64.new: bits => ($t2 - $t5)
}

multi prefix:<⊟> (Bcd64 \p) {
   my $t1 = uint64.Range.max + 1 - p.bits ;
   my $t2 = ( $t1 + 0xFFFF_FFFF_FFFF_FFFF ) % uint64.Range.max;
   my $t3 = $t2 +^ 1;
   my $t4 = +^($t2 +^ $t3) +& 0x1111_1111_1111_1110;
   my $t5 = ($t4 +> 2) +| ($t4 +> 3);
   Bcd64.new: bits => ($t1 - $t5)
}

multi infix:<⊟> (Bcd64 \p, Bcd64 \q) { p ⊞ ( ⊟q ) }

my ($one,$n19,$n30,$n99) = (0x01,0x19,0x30,0x99).map: { Bcd64.new: bits=>$_ };

{ .bits.base(16).say } for ($n19 ⊞ $one,$n30 ⊟ $one,$n99 ⊞ $one);

