declare
  fun {BinarySearch Arr Val}
     fun {Search Low High}
        if Low > High then nil
        else
           Mid = (Low+High) div 2
        in
           if Val < Arr.Mid then {Search Low Mid-1}
           elseif Val > Arr.Mid then {Search Mid+1 High}
           else [Mid]
           end
        end
     end
  in
     {Search {Array.low Arr} {Array.high Arr}}
  end

  A = {Tuple.toArray unit(2 3 5 6 8)}
in
  {System.printInfo "searching 4: "} {Show {BinarySearch A 4}}
  {System.printInfo "searching 8: "} {Show {BinarySearch A 8}}
