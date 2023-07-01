declare
  fun {BinarySearch Arr Val}
     Low = {NewCell {Array.low Arr}}
     High = {NewCell {Array.high Arr}}
  in
     for while:@Low =< @High  return:Return  default:nil do
        Mid = (@Low + @High) div 2
     in
        if Val < Arr.Mid then High := Mid-1
        elseif Val > Arr.Mid then Low := Mid+1
        else {Return [Mid]}
        end
     end
  end

  A = {Tuple.toArray unit(2 3 5 6 8)}
in
  {System.printInfo "searching 4: "} {Show {BinarySearch A 4}}
  {System.printInfo "searching 8: "} {Show {BinarySearch A 8}}
