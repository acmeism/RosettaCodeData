sub jortsort {
  my @s=sort @_;  # Default standard string comparison
  for (0..$#s) {
    return 0 unless $_[$_] eq $s[$_];
  }
  1;
}
