def digits: tostring | explode;

first(range(1; infinite)
      | . as $i
      | (digits|sort) as $reference
      | select(all(range(2;7); $reference == ((. * $i) | digits | sort))) )
