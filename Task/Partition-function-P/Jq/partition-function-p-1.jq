def partitions($n):
  def div2: (. - (.%2)) / 2;
  reduce range(1; $n + 1) as $i ( {p: ([1] + [range(0;$n)|0])};
    . + {k: 0, stop: false}
    | until(.stop;
        .k += 1
        | (((.k * (3*.k - 1)) | div2) ) as $j
        | if $j > $i then .stop=true
  	  else if (.k % 2) == 1
  	       then .p[$i] = .p[$i] + .p[$i - $j]
               else .p[$i] = .p[$i] - .p[$i - $j]
               end
          | (((.k * (3*.k + 1)) | div2)) as $j
          | if $j > $i then .stop=true
            elif (.k % 2) == 1
            then .p[$i] = .p[$i] + .p[$i - $j]
            else .p[$i] = .p[$i] - .p[$i - $j]
    	  end
  	end ))
    | .p[$n] ;

[partitions(range(1;15))]
