def minimum_integer_multiple:
  def digitSum:
    def add(s): reduce s as $_ (0; .+$_);
      add(tostring | explode[] | . - 48);

  . as $n
  | 1 | until((. * $n) | digitSum == $n; . + 1);
