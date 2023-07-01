declare
  fun {Expand RangeDesc}
     {Flatten
      {Map {ParseDesc RangeDesc}
       ExpandRange}}
  end

  fun {ParseDesc Txt}
     {Map {String.tokens Txt &,} ParseRange}
  end

  fun {ParseRange R}
     if {Member &- R.2} then
        First Second
     in
        {String.token R.2 &- ?First ?Second}
        {String.toInt R.1|First}#{String.toInt Second}
     else
        Singleton = {String.toInt R}
     in
        Singleton#Singleton
     end
  end

  fun {ExpandRange From#To}
     {List.number From To 1}
  end
in
  {System.showInfo
   {Value.toVirtualString {Expand "-6,-3--1,3-5,7-11,14,15,17-20"} 100 100}}
