  [range(1;8)]
  | combinations(3)
  | select( add == 12 and .[1] % 2 == 0)
  | {fire: .[0], police: .[1], sanitation: .[2]}
