def solve(r11; r31; r52; r54):
  range(1;r31 - 1) as $X
  | range(1; r31 - 1) as $Y
  | (($Y - $X) | select(. > 0)) as $Z
  | (r52 + $X) as $R41
  | (r52 + $Y) as $R42
  | select($R41 + $R42 == r31)
  | ($Y + r54) as $R43
  | (r54 + $Z) as $R44
  | ($R42 + $R43) as $R32
  | ($R43 + $R44) as $R33
  | (r31 + $R32) as $R21
  | ($R32 + $R33) as $R22
  | select($R21 + $R22 == r11)
  | [$X, $Y, $Z];

solve(151; 40; 11; 4),
