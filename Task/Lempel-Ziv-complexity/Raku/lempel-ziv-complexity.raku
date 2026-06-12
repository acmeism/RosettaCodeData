# 20251001 Raku programming solution

say "want - got  as dotted notation";

for q:to/END/.lines
   "AZSEDRFTGYGUJIJOKB" 	16
   "ABCABCABCABCABCABC" 	4
   "111011111001111011111001" 	6
   "101001010010111110" 	5
   "1001111011000010" 	6
   "1010101010" 	3
   "1010101010101010" 	3
   "1001111011000010000010" 	7
   "100111101100001000001010" 	8
   "0001101001000101" 	6
   "1111111" 	2
   "0001" 	2
   "010" 	3
   "1" 	1
   "" (the empty string) 	0
   "01011010001101110010" 	7
   "ABCDEFGHIJKLMNOPQRSTUVWXYZ" 	26
   "HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!" 	11
END
-> $line {
   $line ~~ /\"(.*)\" \h* (\d+)/;
   my ($string, $want) = $0 // '', $1 // 0;
   if $string.chars == 0 { printf "%4d - %2d\n", 0, 0 andthen next }

   my $pos = 0;
   my @parts = gather while $pos < $string.chars {
      if $string ~~ m:pos($pos)/ (.+?) <!{
            my $target = ~$0;
	        my $prefix = $/.prematch ~ $target;
	        $prefix ~~ / $target . /}> / {
         take ~$0;
         $pos = $/.to;
      } else {
         take $string.substr($pos) andthen last
      }
   }
   printf "%4d - %2d   %s\n", $want, @parts.elems, @parts.join('.');
}
