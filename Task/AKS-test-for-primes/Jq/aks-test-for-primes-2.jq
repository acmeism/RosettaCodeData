def coefficients:
  def alternate_signs: . as $in
  | reduce range(0; length) as $i ([]; . + [$in[$i] * (if $i % 2 == 0 then 1 else -1 end )]);
  (.+1) | pascal | alternate_signs;
