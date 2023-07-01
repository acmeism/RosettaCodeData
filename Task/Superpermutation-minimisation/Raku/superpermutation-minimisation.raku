for 1..8 -> $len {
  my $pre = my $post = my $t = '';
  for  ('a'..'z')[^$len].permutations -> @p {
     $t = @p.join('');
     $post ~= $t        unless index($post, $t);
     $pre   = $t ~ $pre unless index($pre,  $t);
  }
  printf "%1d: %8d %8d\n", $len, $pre.chars, $post.chars;
}
