# 20231102 Raku programming solution

sub encode($data where $data.Bool, $delim = 0x00) {
   my ($ins,$code,$addLastCode,@enc) = 0,1,True,-1;
   for $data.list -> $byte {
      if $byte != 0 { @enc.push($byte) andthen $code++ }
      $addLastCode = True;
      if $byte == 0 || $code == 255 {
         $addLastCode = False if $code == 255;
         @enc[$ins] = $code;
         $code = 1;
         $ins = @enc.elems;
         @enc.push(-1);
      }
   }
   if $addLastCode {
      @enc[$ins] = $code;
      if $delim != 0 { @enc >>^=>> $delim }
      @enc.push($delim)
   } else {
      if $delim != 0 { @enc >>^=>> $delim }
      @enc[$ins] = $delim
   }
   return @enc;
}

sub decode($data where $data.Bool, $delim = 0x00) {
   my $length = ( my @enc2 = $data.list[0..*-2] ).elems;
   if $delim != 0 { @enc2 >>^=>> $delim }
   my ($block,$code,@dec) = 0,255;
   for @enc2.kv -> $i,$byte {
      if $block != 0 {
         @dec.push($byte)
      } else {
         die "marker pointing beyond the end of the packet." if $i + $byte > $length;
         @dec.push(0) if $code != 255;
         $block = $code = $byte;
         last if $code == 0
      }
      $block--;
   }
   return @dec;
}

for ( [0x00], [0x00,0x00], [0x00,0x11,0x00], [0x11,0x22,0x00,0x33],
      [0x11,0x22,0x33,0x44], [0x11,0x00,0x00,0x00], # 0x01..0xfe, 0x00..0xfe,
#      [0x02..0xff].append(0x00), [0x03..0xff].append(0x00, 0x01),
) { # https://crccalc.com/bytestuffing.php
#   say encode( $_ )>>.&{.fmt("0x%x")};
   say decode(encode( $_ ))>>.&{.fmt("0x%x")}
}
