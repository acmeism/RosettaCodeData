# 20220222 Updated Raku programming solution

my \PC1 = <
   56 48 40 32 24 16  8         0 57 49 41 33 25 17
    9  1 58 50 42 34 26        18 10  2 59 51 43 35
   62 54 46 38 30 22 14         6 61 53 45 37 29 21
   13  5 60 52 44 36 28        20 12  4 27 19 11  3
>; # Permuted choice 1 (PC-1) - Parity Drop Table, https://w.wiki/4yKS

my \PC2 = <
   13 16 10 23  0  4  2 27     14  5 20  9 22 18 11  3
   25  7 15  6 26 19 12  1     40 51 30 36 46 54 29 39
   50 44 32 47 43 48 38 55     33 52 45 41 49 35 28 31
>; # Permuted choice 2 (PC-2) - Key Compression Table, https://w.wiki/4yKR

my \IP = <
   57 49 41 33 25 17  9  1     59 51 43 35 27 19 11  3
   61 53 45 37 29 21 13  5     63 55 47 39 31 23 15  7
   56 48 40 32 24 16  8  0     58 50 42 34 26 18 10  2
   60 52 44 36 28 20 12  4     62 54 46 38 30 22 14  6
>; # Initial permutation (IP), https://w.wiki/4yKN

my \IP2 = <
   39  7 47 15 55 23 63 31     38  6 46 14 54 22 62 30
   37  5 45 13 53 21 61 29     36  4 44 12 52 20 60 28
   35  3 43 11 51 19 59 27     34  2 42 10 50 18 58 26
   33  1 41  9 49 17 57 25     32  0 40  8 48 16 56 24
>; # Final permutation (IP⁻¹), https://w.wiki/4yKP

my \S = ( <
   14 4 13 1 2 15 11 8 3 10 6 12 5 9 0 7   0 15 7 4 14 2 13 1 10 6 12 11 9 5 3 8
   4 1 14 8 13 6 2 11 15 12 9 7 3 10 5 0   15 12 8 2 4 9 1 7 5 11 3 14 10 0 6 13
> , <
   15 1 8 14 6 11 3 4 9 7 2 13 12 0 5 10   3 13 4 7 15 2 8 14 12 0 1 10 6 9 11 5
   0 14 7 11 10 4 13 1 5 8 12 6 9 3 2 15   13 8 10 1 3 15 4 2 11 6 7 12 0 5 14 9
> , <
   10 0 9 14 6 3 15 5 1 13 12 7 11 4 2 8   13 7 0 9 3 4 6 10 2 8 5 14 12 11 15 1
   13 6 4 9 8 15 3 0 11 1 2 12 5 10 14 7   1 10 13 0 6 9 8 7 4 15 14 3 11 5 2 12
> , <
   7 13 14 3 0 6 9 10 1 2 8 5 11 12 4 15   13 8 11 5 6 15 0 3 4 7 2 12 1 10 14 9
   10 6 9 0 12 11 7 13 15 1 3 14 5 2 8 4   3 15 0 6 10 1 13 8 9 4 5 11 12 7 2 14
> , <
   2 12 4 1 7 10 11 6 8 5 3 15 13 0 14 9   14 11 2 12 4 7 13 1 5 0 15 10 3 9 8 6
   4 2 1 11 10 13 7 8 15 9 12 5 6 3 0 14   11 8 12 7 1 14 2 13 6 15 0 9 10 4 5 3
> , <
   12 1 10 15 9 2 6 8 0 13 3 4 14 7 5 11   10 15 4 2 7 12 9 5 6 1 13 14 0 11 3 8
   9 14 15 5 2 8 12 3 7 0 4 10 1 13 11 6   4 3 2 12 9 5 15 10 11 14 1 7 6 0 8 13
> , <
   4 11 2 14 15 0 8 13 3 12 9 7 5 10 6 1   13 0 11 7 4 9 1 10 14 3 5 12 2 15 8 6
   1 4 11 13 12 3 7 14 10 15 6 8 0 5 9 2   6 11 13 8 1 4 10 7 9 5 0 15 14 2 3 12
> , <
   13 2 8 4 6 15 11 1 10 9 3 14 5 0 12 7   1 15 13 8 10 3 7 4 12 5 6 11 0 14 9 2
   7 11 4 1 9 12 14 2 0 6 10 13 15 3 5 8   2 1 14 7 4 10 8 13 15 12 9 0 3 5 6 11
> ); # S-Boxes, each replaces a 6-bit input with a 4-bit output, w.wiki/4yG8

my \P = <
   15 6 19 20   28 11 27 16     0 14 22 25     4 17 30  9
    1 7 23 13   31 26  2  8    18 12 29  5    21 10  3 24
>; # Permutation (P), shuffles the bits of a 32-bit half-block, w.wiki/4yKT

# Expansion function (E), expand 32-bit half-block to 48 bits, w.wiki/4yGC
my \E = flat 31,0..4,3..8,7..12,11..16,15..20,19..24,23..28,27..31,0;

my \SHIFTS = flat 1, 1, 2 xx 6, 1, 2 xx 6, 1 ; # left shifts, w.wiki/4yKV

## Helper subs

# convert iso-8859-1 to hexadecimals(%02X)
sub b2h (\b) { b.ords.fmt('%02X','') }

# convert UTF8s to bytes
sub u2b (\u) { u.encode.list.chrs }

# convert hexadecimals(%02X) to UTF-8
sub h2u (\h) { Blob.new( h.comb(2)».&{ :16($_) } ).decode }

# convert quadbits to hex
sub q2h (\q) { [~] q.comb(4)».&{ :2($_).fmt('%X') } }

# convert every two quadbits to bytes
sub q2b (\q) { q.comb(8)».&{ :2($_) } }

# turn a 16 digit hexadecimal str to a 64 bits list
sub h2b (\h) { flat h.comb».&{ :16($_).base(2).fmt('%04s').comb } }

# convert hexadecimals to bytes
sub h2B (\h) { [~] h.comb(2)».&{ chr "0x$_" } }

# s is 16 digit hexadecimal str, M is a permuation matrix/vector
sub map64(\s,\M) { (h2b s)[M] }

## Core subs

sub get_subkeys(Str \key --> Seq) { # return a Seq with 16 bit vectors
   my (@C,@D) := { .rotor(.elems div 2)».Array }(map64 key, PC1); #w.wiki/4yKV
   my \CD = (^16)».&{ [ |@C.=rotate(SHIFTS[$_]), |@D.=rotate(SHIFTS[$_]) ] }
   # key compression rounds, https://w.wiki/4yKb
   return (^16).map: -> \row { (^48).map: -> \col { CD[row][ PC2[col] ] } }
}

sub ƒ (List \R, Seq \Kₙ --> List) {
   my @er = map { Kₙ[$_] +^ R[E[$_]] }, ^48;

   return ( flat (^8)».&{ # Sₙ(Bₙ) loop, process @er six bits at a time
      S[$_][ ([~] @er[$_*6   ,  $_*6+5]).parse-base(2)*16 +   # 2 bits
             ([~] @er[$_*6+1 .. $_*6+4]).parse-base(2)      ] # 4 bits
      .fmt('%04b').comb } # ((S[][] to binary).split)*8.flat
   )[P]
}

sub process_block(Str \message, Seq \K --> Str) { # return 8 quadbits
   my (@L,@R) := { .rotor(.elems div 2)».Array }(map64 (b2h message), IP);
   { my @Lₙ = @R; my @Rₙ = @L Z+^ ƒ @R, K[$_]; @L = @Lₙ; @R = @Rₙ } for ^16;

   return [~] (|@R, |@L)[IP2] # inverse of the initial permutation
}

sub des(Str \key, Str $msg is copy, Bool \DECODE --> Str) { # return hexdecimal

   my \length = $msg.encode('iso-8859-1').bytes;

   die "Message must be in multiples of 8 bytes" if ( DECODE and length % 8 );

   my \K = { DECODE ?? reverse $_ !! $_ }(get_subkeys key);

   # CMS style padding as per RFC 1423 & RFC 5652
   { $msg ~= (my \Pad = 8 - length % 8).chr x Pad } unless DECODE;

   my $quad = [~] ( 0, 8 … $msg.encode('iso-8859-1').bytes-8 ).map:
                 { process_block substr($msg,$_,8), K }

   DECODE ?? do { my @decrypt = q2b $quad; # quadbits to a byte code point list
                  @decrypt.pop xx @decrypt.tail; # remove padding
                  return b2h [~] @decrypt.chrs }
          !! do { return q2h $quad }
}

say "Encryption examples: ";
say des "133457799BBCDFF1", h2B("0123456789ABCDEF"), False;
say des "0E329232EA6D0D73", h2B("8787878787878787"), False;
say des "0E329232EA6D0D73", "Your lips are smoother than vaseline", False;
say des "0E329232EA6D0D73", "Your lips are smoother than vaseline\r\n", False;
say des "0E329232EA6D0D73", u2b("BMP: こんにちは ; Astral plane: 𝒳𝒴𝒵"), False;

say "\nDecryption examples: ";
say des "133457799BBCDFF1", h2B("85E813540F0AB405FDF2E174492922F8"), True;
say des "0E329232EA6D0D73", h2B("0000000000000000A913F4CB0BD30F97"), True;
say h2B des "0E329232EA6D0D73", h2B("C0999FDDE378D7ED727DA00BCA5A84EE47F269A4D6438190D9D52F78F535849980A2E7453703513E"), True;
say h2B des "0E329232EA6D0D73", h2B("C0999FDDE378D7ED727DA00BCA5A84EE47F269A4D6438190D9D52F78F53584997F922CCB5B068D99"), True;
say h2u des "0E329232EA6D0D73", h2B("C040FB6A6E72D7C36D60CA9B9A35EB38D3194468AD808103C28E33AEF0B268D0E0366C160B028DDACF340003DCA8969343EBBD289DB94774"), True;
