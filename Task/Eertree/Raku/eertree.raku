my $str = "eertree";
my @pal = ();
my ($strrev,$strpal);

for (1 .. $str.chars) -> $n {
   for (1 .. $str.chars) -> $m {
      $strrev = "";
      $strpal = $str.substr($n-1, $m);
      if ($strpal ne "") {
         for ($strpal.chars ... 1) -> $p {
            $strrev ~= $strpal.substr($p-1,1);
         }
         ($strpal eq $strrev) and @pal.push($strpal);
      }
   }
}

say @pal.unique;
