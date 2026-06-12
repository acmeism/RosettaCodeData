# 20250709 Raku programming solution

my %WDICT = <CODE SEND ACK SUPP RV MSG GRID REQ> Z=> <κ σ α π ν μ γ ρ>;
my %SDICT = %WDICT.invert;

my @CT37w = [ # Original CT-37w checkerboard table
    ['',  'A', 'E', 'I', 'N', 'O', 'T', 'κ', '',  '',  ''],
    ['7', 'B', 'C', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M'],
    ['8', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'X', 'Y', 'Z'],
    ['9', ' ', '.', 'α', 'ρ', 'μ', 'ν', 'γ', 'σ', 'π', '/'],
];

my @CT37w_mod = |@CT37w[0..2], qww <9 " " . α ρ μ ν γ σ / π>; # Modified CT-37w

sub xcb-encode(Str $message, @table, Str $code = 'κ', %wdict = %WDICT --> Str) {
   my ($numericmode, $codemode, $codemodecount, @encoded) = False, False, 0;

   # Determine mode change code and digit repeats based on table
   my $nchangemode   = @table[3][10] eq '/' ?? 99 !! 98;
   my $digit_repeats = @table[3][10] eq '/' ??  3 !!  2;

   # Replace terms found in dictionary with single char symbols
   my $s = $message.uc;
   for %wdict.kv -> $k, $v { $s.trans: $k => $v }

   for $s.comb -> $c {
      if $c ~~ /\d/ {
         if $codemode { # symbols are preceded by CODE digit then as-is
            @encoded.push($c);
            $codemodecount++;
            if $codemodecount >= 3 { $codemode = False }
         } else {
            unless $numericmode {
               $numericmode = True;
               @encoded.push($nchangemode); # Enter numeric mode
            }
            @encoded.push($c x $digit_repeats);
         }
      } else {
         $codemode = False;
         if $numericmode { # End numeric mode
            @encoded.push($nchangemode);
            $numericmode = False;
         }
         if $c eq $code {
            $codemode = True;
            $codemodecount = 0;
         }
         my $found = False;
         for @table -> @row { # Find character in table
            if (my $k = @row.first($c, :k)).defined and $k > 0 {
               @encoded.push(@row[0] ~ ($k - 1));
               $found = True;
               last;
            }
         }
      }
   }
   return @encoded.join;
}

sub xcb-decode(Str $s, @table, Str $code = 'κ', %sdict = %SDICT --> Str) {
   # Get prefixes (row identifiers) sorted in reverse order (longest first)
   my @prefixes = @table.map(*[0]).grep(* ne '').sort: *.chars cmp *.chars;
   my ($numericmode, $codemode, $pos, @decoded) = False, False, 0;

   # Determine mode change code and digit repeats based on table
   my $nchangemode   = @table[3][10] eq '/' ?? 99 !! 98;
   my $digit_repeats = @table[3][10] eq '/' ??  3 !!  2;

   # Create numbers hash for numeric mode
   my %numbers = (0..9).map({$_ x $digit_repeats => $_}).Hash;

   while $pos < $s.chars {
      if $numericmode {
         my $num_str = $s.substr($pos, $digit_repeats);
         if %numbers{$num_str}:exists {
            @decoded.push(%numbers{$num_str});
            $pos += $digit_repeats - 1;
         } elsif $s.substr($pos, 2) eq $nchangemode {
            $numericmode = False;
            $pos += 1;
         } elsif @decoded.elems > 0 && @decoded[*-1] eq '9' {
            # Error, backtrack if last was 9
            @decoded.pop;
            $numericmode = False;
            $pos -= $digit_repeats - 1;
         }
      } elsif $codemode {
         if $pos + 2 < $s.chars && $s.substr($pos, 3) ~~ /^\d ** 3$/ {
            @decoded.push($s.substr($pos, 3));
            $pos += 2;
         }
         $codemode = False;
      } elsif $s.substr($pos, 2) eq $nchangemode {
         $numericmode = !$numericmode;
         $pos += 1;
      } else {
         my $found = False;
         for @prefixes -> $p { # Try to match prefixes (multi-digit codes)
            if $s.substr($pos).starts-with($p) {
               my $n = $p.chars;
               # Find the row index where first element matches prefix
               my $row_idx = gather for @table.kv -> $i, @row {
                  if @row[0] eq $p { take $i and last }
               }.first // Nil;
               if $row_idx.defined && $pos + $n < $s.chars {
                  if (my $next_digit = $s.substr($pos + $n, 1)) ~~ /\d/ {
                     if (my $col_idx = $next_digit.Int+1) < +@table[$row_idx] {
                        @decoded.push(my $c = @table[$row_idx][$col_idx]);
                        if $c eq $code { $codemode = True }
                     }
                     $pos += $n;
                     $found = True;
                     last;
                  }
               }
            }
         }
         if !$found { # If no prefix match, try single digit (row 0)
            my $digit = $s.substr($pos, 1);
            if $digit ~~ /\d/ {
               my $col_idx = $digit.Int + 1;
               if $col_idx < @table[0].elems {
                  my $c = @table[0][$col_idx] // '';
                  @decoded.push($c) if $c ne '';
                  if $c eq $code { $codemode = True }
               }
            }
         }
      }
      $pos++;
   }
   my $result = @decoded.join;
   return ( do for %sdict.kv -> $k, $v { $result.trans: $k => $v } ).first;
}

say "Original: ", my $message = 'Admin ACK your MSG. CODE291 SEND further 2000 SUPP to HQ by 1 March';

for @CT37w, @CT37w_mod -> $table {
   say "Encoded:  ", my $encoded = xcb-encode($message, $table);
   say "Decoded:  ", xcb-decode($encoded, $table);
}
