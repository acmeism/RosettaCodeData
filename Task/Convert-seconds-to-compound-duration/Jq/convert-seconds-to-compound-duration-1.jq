def seconds_to_time_string:
  def nonzero(text): floor | if . > 0 then "\(.) \(text)" else empty end;
  if . == 0 then "0 sec"
  else
  [(./60/60/24/7    | nonzero("wk")),
   (./60/60/24 % 7  | nonzero("d")),
   (./60/60    % 24 | nonzero("hr")),
   (./60       % 60 | nonzero("min")),
   (.          % 60 | nonzero("sec"))]
  | join(", ")
  end;
