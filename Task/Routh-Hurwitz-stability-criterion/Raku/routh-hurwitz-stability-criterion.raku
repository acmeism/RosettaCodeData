# 20260101 Raku programming solution

# Global epsilon for numerical stability checks
constant DEFAULT_TOLERANCE   = 1e-9;
# Epsilon value for replacing a zero in the first column
constant EPSILON_REPLACEMENT = 0.01;

sub routh-hurwitz( @coeff-vector is copy,
                   :$epss-replacement = EPSILON_REPLACEMENT,
                   :$tolerance = DEFAULT_TOLERANCE) {

   without my $first-non-zero-idx = @coeff-vector.first(*.abs > $tolerance,:k) {
      my $num-coeffs =   @coeff-vector.elems max 1;
      my $rh-cols    = ( $num-coeffs div 2 ) max 1;
      my @table      = [ 0e0 xx $rh-cols ] xx $num-coeffs;
      return @table, 0, False, "System has all zero coefficients, stability is ill-defined (considered unstable).";
   }

   # Trim leading zeros
   @coeff-vector = @coeff-vector[$first-non-zero-idx..*];
   my $coeff-length = @coeff-vector.elems;

   if $coeff-length == 0 {
      return [[0e0]], 0, False, "Coefficient vector is empty after trimming."
   }

   if $coeff-length == 1 {
      return @coeff-vector[0].abs < $tolerance
         ?? ( [[@coeff-vector[0]]], 0, False, "System is P(s)=0, unstable." )
         !! [[@coeff-vector[0]]], 0, True, "System is stable (0th order, non-zero constant).";
   }

   my $rh-table-column = ( $coeff-length / 2.0 ).ceiling max 1;
   my @rh-table        = [ 0e0 xx $rh-table-column ] xx $coeff-length;

   for @coeff-vector.kv -> $k, $val { # Fill Row 0 and Row 1 from coefficients
      my $row-idx = $k % 2;
      my $col-idx = $k div 2;
      if $col-idx < $rh-table-column { @rh-table[$row-idx][$col-idx] = $val }
   }

   my $had-row-zeros = False;

   if $coeff-length > 1 { # Special check for row 1 if all zeros
      my ($is-zero, $msg) = check-and-fix-zero-row(@rh-table, 1, $coeff-length, $tolerance);
      if $is-zero { $had-row-zeros = True }
   }

   for 2..^$coeff-length -> $i-py-row { # Calculate other elements of the table
      my $prev-row-py      = $i-py-row - 1;
      my $prev-prev-row-py = $i-py-row - 2;

      # Special case: row of all zeros in previous row
      my ($is-prev-zero, $msg-prev) = check-and-fix-zero-row(@rh-table, $prev-row-py, $coeff-length, $tolerance);
      if $is-prev-zero { $had-row-zeros = True }

      # Denominator for the current row's calculation
      my $denominator = @rh-table[$prev-row-py][0];

      if $denominator.abs < $tolerance {
         if $epss-replacement.abs < $tolerance {
            return @rh-table, $coeff-length, False, "System unstable or ill-defined: Division by zero, and epsilon ({$epss-replacement}) is zero.";
         }
         ($denominator, @rh-table[$prev-row-py][0]) = $epss-replacement xx 2
      }

      for ^($rh-table-column - 1) -> $j-col {
         my $next-col = $j-col + 1;
         my ($val1, $val2) = do if $next-col < $rh-table-column {
            @rh-table[$prev-prev-row-py][$next-col] // 0e0,
            @rh-table[$prev-row-py][$next-col] // 0e0
         }
         my $numerator = ($denominator * $val1) -
                         (@rh-table[$prev-prev-row-py][0] * $val2);
         @rh-table[$i-py-row][$j-col] = $numerator / $denominator;
      }

      # Snap small values to zero to handle floating point errors
      for ^$rh-table-column -> $j {
         given @rh-table[$i-py-row][$j] { $_ = 0e0 if .abs < $tolerance }
      }

      # Special case: row of all zeros after calculation
      my ($is-curr-zero, $msg-curr) = check-and-fix-zero-row(@rh-table, $i-py-row, $coeff-length, $tolerance);
      $had-row-zeros = True if $is-curr-zero;

      # Special case: zero in the first column
      given @rh-table[$i-py-row][0] { $_ = $epss-replacement if .abs < $tolerance }
   }

   # Compute number of right hand side poles
   my $unstable-poles = 0;
   my @first-column = ^$coeff-length .map: { @rh-table[$_][0] } ;
   for @first-column.rotor(2 => -1) {
      next if .[0].abs < $tolerance || .[1].abs < $tolerance; # close to zero
      $unstable-poles++ if .[0].sign * .[1].sign == -1
   }

   my $is-stable = $unstable-poles == 0;
   my $message = do if $is-stable {
      do if $had-row-zeros {
         "System is marginally stable (poles on the imaginary axis)."
      } elsif @coeff-vector[*-1].abs < $tolerance {
         "System is marginally stable (pole at origin)."
      } else {
         "System is STABLE."
      }
   } else {
      "System is UNSTABLE with $unstable-poles pole(s) in the RHP."
   }
   return @rh-table, $unstable-poles, $is-stable, $message
}

# Helper to detect a row of zeros and replace it with the derivative of the Auxiliary Polynomial (Previous Row)
sub check-and-fix-zero-row(@table, $row-idx, $total-rows, $tolerance) {
   # 1. Check if row is all zeros
    return (False, "") if @table[$row-idx].first: *.abs >= $tolerance;

   # 2. Get Previous Row (Auxiliary Polynomial)
   my $prev-row-idx = $row-idx - 1;
   return (False, "Error: First row cannot be zero derived.") if $prev-row-idx < 0;
   # 3. Calculate Derivative
   my $order = ($total-rows - 1) - $prev-row-idx;

   my $all-zeros-generated = True;
   for @table[$prev-row-idx].kv -> $key,$value {
      my $current-power = $order - 2 * $key;
      my $coeff = $value // 0e0;

      if $current-power > 0 {
         @table[$row-idx][$key] = my $new-val = $coeff * $current-power;
         $all-zeros-generated = False if $new-val.abs >= $tolerance;
      } else {
         @table[$row-idx][$key] = 0e0
      }
   }
   if $all-zeros-generated {
      return (True, "Repeated poles on imaginary axis (Unstable).")
   }
   return (True, "")
}

sub print-routh-details(Str $coeff-str, @rh-table is copy, $unstable-poles,
                        $is-stable, Str $message, Bool :$show-roots = False,
                        :@original-coeffs, :$tolerance = DEFAULT_TOLERANCE) {
   say "\nFor coefficient vector: $coeff-str";
   say "Routh-Hurwitz Table:";

   if @rh-table.Bool { # non-empty
      # Check if the table is properly structured
      unless @rh-table[0] ~~ Positional && @rh-table[0].Bool { # not valid table
         say "(Table generation failed or system trivial/empty)";
         say "\n$message";
         return;
      }
      # Replace very small numbers with 0
      for @rh-table -> @row {
         for @row.kv -> $key, $value {
            @row[$key] = 0e0 if $value.abs < $tolerance * 10
         }
      }
      my $max-char-len = 0;
      my @str-table-rows = @rh-table.map: -> @row {
         my $last-sig-idx = @row.first: *.abs > $tolerance, :end, :k;
         my $effective-cols = (($last-sig-idx // 0) + 1) max 1;

         [ gather for @row[^$effective-cols] {
            $max-char-len max= chars take sprintf("%.4g", $_)
         } ]
      }
      for @str-table-rows { say $_.map(*.fmt("%{$max-char-len}s")).join: " | " }
   } else {
      say "(Table generation failed or system trivial/empty)";
   }

   say "\n$message";

   if $show-roots && @original-coeffs {
      my @coeffs = @original-coeffs;

      # Trim leading zeros
      my $first-nz-idx = ( @coeffs.first: * > $tolerance, :k ) // 0;
      @coeffs = @coeffs[$first-nz-idx..*];

      # Check if we have any coefficients left and they're not all zero
      if @coeffs.elems == 0 || @coeffs.all == 0 {
         say "\nPolynomial is trivial (e.g., 0 or empty), roots are undefined or infinite.";
         return;
      }

      if @coeffs.elems > 1 {
         say "\nRoots of the polynomial:";
         my @roots = find-polynomial-roots(@coeffs);
         for @roots -> $r {
            # Handle both Complex and Num types
            my $r-real = $r ~~ Complex ?? $r.re !! $r;
            my $r-imag = $r ~~ Complex ?? $r.im !! 0;

            # Clean up near-zero values
            $r-real = 0e0 if $r-real.abs < $tolerance;
            $r-imag = 0e0 if $r-imag.abs < $tolerance;

            if $r-imag.abs > $tolerance { # Format with proper sign handling
               my $sign = $r-imag >= 0 ?? '+' !! '-';
               printf(" %.4f %s %.4fi\n", $r-real, $sign, $r-imag.abs);
            } else {
               printf(" %.4f\n", $r-real)
            }
         }
      } elsif @coeffs.elems == 1 && @coeffs[0].abs > $tolerance {
         say "\nPolynomial is a non-zero constant (0th order), no roots in finite plane."
      } else {
         say "\nPolynomial is trivial (e.g., 0 or empty), roots are undefined or infinite."
      }
   }
}

# Polynomial root finding using Durand-Kerner method
sub find-polynomial-roots(@coeffs-in, :$tol = 1e-8, :$max-iter = 100) {
   return () if @coeffs-in.elems < 2;

   my @coeffs = @coeffs-in>>.Complex;
   my $n = @coeffs.elems - 1;

   # Normalize to monic polynomial
   return () if ( my $leading = @coeffs[0] ).abs < 1e-9;
   @coeffs = @coeffs.map: * / $leading;

   # Initial guesses on a circle in complex plane
   my @roots = ^$n .map: { (0.4 + 0.9i) ** $_ };

   for ^$max-iter {
      my ($max-delta, @new-roots) = 0e0, @roots;
      for ^$n -> $k {
         my $p-val = eval-polynomial(@coeffs, @roots[$k]);
         my $denom = 1e0 + 0i;

         for ^$n -> $j { $j==$k ?? (next) !! $denom *= @roots[$k] - @roots[$j] }

         $denom = $tol + 0i if $denom.abs < $tol ; # Avoid division by zero

         @new-roots[$k] = @roots[$k] - my $delta = $p-val / $denom;
         $max-delta max= $delta.abs
      }
      @roots = @new-roots;
      last if $max-delta < $tol
   }
   # Sort and return roots by real part (descending), then imag part (ascending)
   return @roots.sort: { -.re, .im }
}

sub eval-polynomial(@coeffs, $x) { [+] @coeffs Z* ($x X**(@coeffs.elems^...0)) }

my $show-all-roots = True;

for my @test-cases = (
   ("Stable: s^3 + 6s^2 + 11s + 6", [1, 6, 11, 6]),
   ("Unstable: s^3 - 6s^2 + 11s - 6", [1, -6, 11, -6]),
   ("Marginally Stable (jw-axis, Row of Zeros): s^3 + s^2 + s + 1", [1, 1, 1, 1]),
   ("Marginally Stable (jw-axis, Row of Zeros): s^2 + 1", [1, 0, 1]),
   ("Marginally Stable (epsilon case): s^3 + 2s^2 + s + 2", [1, 2, 1, 2]),
   ("Unstable (row of zeros & RHP): s^5 + 2s^4 + 3s^3 + 6s^2 + 5s + 10", [1, 2, 3, 6, 5, 10]),
   ("Stable: s + 1", [1, 1]),
   ("Stable: s^2 + 2s + 1", [1, 2, 1]),
   ("Unstable: s^2 - 1", [1, 0, -1]),
   ("Marginally Stable (all jw-axis): s^4 + 3s^2 + 2", [1, 0, 3, 0, 2]),
   ("All Zero Coefficients", [0, 0, 0]),
   ("Single Zero Coefficient", [0]),
   ("Single Non-Zero Coefficient (Stable)", [5]),
   ("Leading Zeros: 0s^3 + s^2 + 2s + 1", [0, 1, 2, 1]),
   ("Unstable (2 RHP): s^4 - s^3 -7s^2 + s + 6", [1, -1, -7, 1, 6]),
   ("Marginally Stable (Ogata Example): s^6+2s^5+8s^4+12s^3+20s^2+16s+16", [1, 2, 8, 12, 20, 16, 16]),
   ("Marginally Stable (User Example): s^5+s^4+2s^3+2s^2+s+1", [1, 1, 2, 2, 1, 1]),
   ("Simplest s", [1, 0]), # s=0 -> one pole at origin (marginally stable)
   ("Order 0: constant", [10]), # stable
   ("Order 0: zero", [0]), # unstable
   ("Test case leading to problems with aux poly (constant aux poly)", [1, 1, 0, 0]), # s^3+s^2
) -> ($desc, @coeffs) {
   say "--- Testing Case: $desc ---";
   try {
      my ($rh-table, $unstable-poles, $is-stable, $message) = routh-hurwitz(@coeffs);
      print-routh-details(@coeffs.raku, $rh-table, $unstable-poles,
                          $is-stable, $message, :show-roots($show-all-roots),
                          :original-coeffs(@coeffs));
      CATCH {
         default { say "Error during Routh-Hurwitz calculation: {.message}" }
      }
   }
   say "-" x 60, "\n";
}
