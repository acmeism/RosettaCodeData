# Output: {a: sortedInput, write: numberOfSwaps}
def cycleSort:
  def swap(f;g): g as $t | g = f | f = $t | .writes += 1;

  { a: ., writes: 0, len: length }
  | reduce range(0; .len - 1) as $cs (.;
         .item = .a[$cs]
        | .pos = $cs
        | reduce range($cs+1; .len) as $i (.;
            if .a[$i] < .item then .pos += 1 else . end )
        | if .pos != $cs
          then until (.item != .a[.pos]; .pos += 1)
          | swap(.a[.pos]; .item)
          | until (.pos == $cs;
                .pos = $cs
                | reduce range($cs+1; .len) as $i (.;
                    if .a[$i] < .item then .pos += 1 else . end)
                | until (.item != .a[.pos]; .pos += 1)
                | swap(.a[.pos]; .item) )
          else .
	  end )
  | {a, writes} ;
