given [**] 5, 4, 3, 2 {
  use Test;
  ok /^ 62060698786608744707 <digit>* 92256259918212890625 $/,
     '5**4**3**2 has expected first and last twenty digits';
  printf 'This number has %d digits', .chars;
}
