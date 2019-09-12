#!/usr/bin/env perl6

use v6.d;

my uint32 (@mm, @randrsl, $randcnt, $aa, $bb, $cc);
my \ϕ := 2654435769; constant MOD = 95; constant START = 32;

constant MAXINT = uint.Range.max;
enum CipherMode < ENCIPHER DECIPHER NONE >;

sub mix (\n) {
   sub mix1 (\i, \v) {
      n[i] +^= v;
      n[(i+3)%8] += n[i];
      n[(i+1)%8] += n[(i+2)%8];
   }
   mix1 0, n[1]+<11; mix1 1, n[2]+>2; mix1 2, n[3]+<8; mix1 3, n[4]+>16;
   mix1 4, n[5]+<10; mix1 5, n[6]+>4; mix1 6, n[7]+<8; mix1 7, n[0]+>9 ;
}

sub randinit(\flag) {
   $aa = $bb = $cc = 0;
   my uint32 @n = [^8].map({ ϕ });
   for ^4 { mix @n };
   for 0,8 … 255 -> $i {
      { for (0..7) { @n[$^j] += @randrsl[$i + $^j] } } if flag;
      mix @n;
      for (0..7) { @mm[$i + $^j] = @n[$^j] }
   }
   if flag {
      for 0,8 … 255 -> $i {
         for ^8 { @n[$^j] += @mm[$i + $^j] };
         mix @n;
         for ^8 { @mm[$i + $^j] = @n[$^j] };
      }
   }
   isaac;
   $randcnt = 0;
}

sub isaac() {
   $cc++;
   $bb += $cc;
   for ^256 -> $i {
      my $x = @mm[$i];
      given ($i % 4) {
         when 0 { $aa +^= ($aa +< 13) }
         when 1 { $aa +^= (($aa +& MAXINT) +>  6) }
         when 2 { $aa +^= ($aa +<  2) }
         when 3 { $aa +^= (($aa +& MAXINT) +> 16) }
      }
      $aa += @mm[($i + 128) % 256];
      my $y = @mm[(($x +& MAXINT) +> 2) % 256] + $aa + $bb;
      @mm[$i] = $y;
      $bb = @mm[(($y +& MAXINT) +> 10) % 256] + $x;
      @randrsl[$i] = $bb;
   }
   $randcnt = 0;
}

sub iRandom {
   my $result = @randrsl[$randcnt++];
   if ($randcnt > 255) {
      isaac;
      $randcnt = 0;
   }
   return $result;
}

sub iSeed(\seed, \flag) {
    @mm = [^256].race.map({0});
    my \m = seed.chars;
    @randrsl = [^256].hyper.map({ $^i ≥ m ?? 0 !! seed.substr($^i,1).ord });
    randinit(flag);
}

sub iRandA { return iRandom() % MOD + START };

sub vernam(\M) { ( map { (iRandA() +^ .ord ).chr }, M.comb ).join };

sub caesar(CipherMode \m, \ch, $shift is copy, \Modulo, \Start) {
    $shift = -$shift if m == DECIPHER;
    my $n = (ch.ord - Start) + $shift;
    $n %= Modulo;
    $n += Modulo if $n < 0;
    return (Start + $n).chr;
}

sub caesarStr(CipherMode \m, \msg, \Modulo, \Start) {
   my $sb = '';
   for msg.comb {
        $sb ~= caesar m, $^c, iRandA(), Modulo, Start;
   }
   return $sb;
}

multi MAIN () {
   my \msg = "a Top Secret secret";
   my \key = "this is my secret key";

   iSeed key, True ;
   my $vctx = vernam msg;
   my $cctx = caesarStr ENCIPHER, msg,  MOD, START;

   iSeed key, True ;
   my $vptx = vernam $vctx;
   my $cptx = caesarStr DECIPHER, $cctx, MOD, START;

   my $vctx2hex = ( map { .ord.fmt('%02X') }, $vctx.comb ).join('');
   my $cctx2hex = ( map { .ord.fmt('%02X') }, $cctx.comb ).join('');

   say "Message : ", msg;
   say "Key     : ", key;
   say "XOR     : ", $vctx2hex;
   say "XOR dcr : ", $vptx;
   say "MOD     : ", $cctx2hex;
   say "MOD dcr : ", $cptx;
}
