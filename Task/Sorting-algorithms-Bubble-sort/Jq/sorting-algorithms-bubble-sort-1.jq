def bubble_sort:
  def swap(i;j): .[i] as $x | .[i]=.[j] | .[j]=$x;

  # input/output: [changed, list]
  reduce range(0; length) as $i
    ( [false, .];
      if $i > 0 and (.[0]|not) then .
      else reduce range(0; (.[1]|length) - $i - 1) as $j
        (.[0] = false;
        .[1] as $list
        | if $list[$j] > $list[$j + 1] then [true, ($list|swap($j; $j+1))]
          else .
          end )
      end  ) | .[1] ;
