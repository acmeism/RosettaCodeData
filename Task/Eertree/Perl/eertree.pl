$str = "eertree";

for $n (1 .. length($str)) {
   for $m (1 .. length($str)) {
      $strrev = "";
      $strpal = substr($str, $n-1, $m);
      if ($strpal ne "") {
         for $p (reverse 1 .. length($strpal)) {
            $strrev .= substr($strpal, $p-1, 1);
         }
         ($strpal eq $strrev) and push @pal, $strpal;
      }
   }
}

print join ' ', grep {not $seen{$_}++} @pal, "\n";
