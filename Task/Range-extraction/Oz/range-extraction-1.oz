declare
  fun {Extract Xs}
     {CommaSeparated
      {Map {ExtractRanges Xs} RangeToString}}
  end

  fun {ExtractRanges Xs}
     fun {Loop Ys Start End}
        case Ys
        of Y|Yr andthen Y == End+1 then {Loop Yr Start Y}
        [] Y|Yr                    then Start#End|{Loop Yr Y Y}
        [] nil                     then [Start#End]
        end
     end
  in
     case Xs
     of X|Xr then {Loop Xr X X}
     [] nil then nil
     end
  end

  fun {RangeToString S#E}
     if E-S >= 2 then
        {VirtualString.toString S#"-"#E}
     else
        {CommaSeparated
         {Map {List.number S E 1} Int.toString}}
     end
  end

  fun {CommaSeparated Xs}
     {Flatten {Intersperse "," Xs}}
  end

  fun {Intersperse Sep Xs}
     case Xs of X|Y|Xr then
        X|Sep|{Intersperse Sep Y|Xr}
     else
        Xs
     end
  end
in
  {System.showInfo
   {Extract [ 0 1 2 4 6 7 8 11 12 14
              15 16 17 18 19 20 21 22 23 24
              25 27 28 29 30 31 32 33 35 36
              37 38 39 ]}}
