let is_leap_year ~year =
  let tm =
    Unix.mktime {
      (Unix.gmtime (Unix.time())) with
        Unix.tm_year = (year - 1900);
        tm_mon = 1 (* feb *);
        tm_mday = 29
      }
  in
  (tm.Unix.tm_mday = 29)
