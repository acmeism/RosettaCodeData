use ntheory qw/forperm/;
for my $len (1..8) {
  my($pre, $post, $t) = ("","");
  forperm {
    $t = join "",@_;
    $post .= $t      unless index($post ,$t) >= 0;
    $pre = $t . $pre unless index($pre, $t) >= 0;
  } $len;
  printf "%2d: %8d %8d\n", $len, length($pre), length($post);
}
