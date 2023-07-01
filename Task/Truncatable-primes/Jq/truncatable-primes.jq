def is_left_truncatable_prime:
    def removeleft: recurse(if length <= 1 then empty else .[1:] end);
    tostring
    | index("0") == null and
      all(removeleft|tonumber; is_prime);

def is_right_truncatable_prime:
    def removeright: recurse(if length <= 1 then empty else .[:-1] end);
    tostring
    | index("0") == null and
      all(removeright|tonumber; is_prime);

first( range(999999; 1; -2) | select(is_left_truncatable_prime)),

first( range(999999; 1; -2) | select(is_right_truncatable_prime))
