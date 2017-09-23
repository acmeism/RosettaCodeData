def is_set:
  . as $in
  | type == "array" and
    reduce range(0;length-1) as $i
      (true; if . then $in[$i] < $in[$i+1] else false end);
