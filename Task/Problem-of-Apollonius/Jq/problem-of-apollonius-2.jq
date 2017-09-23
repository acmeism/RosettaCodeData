def task:
     ([0, 0, 1] | circle) as $c1
  |  ([4, 0, 1] | circle) as $c2
  |  ([2, 4, 2] | circle) as $c3
  | ( ap($c1; $c2; $c3; true),      # interior
      ap($c1; $c2; $c3; false) )    # exterior
;
