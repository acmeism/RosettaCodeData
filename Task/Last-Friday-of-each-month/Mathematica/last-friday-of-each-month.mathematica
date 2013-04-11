Needs["Calendar`"]
FridaysOfTheYear[Y_] := Cases[Map[{#,DayOfWeek[#]}&,DaysPlus[{Y,1,2}, #]&/@Range[365],{1}],{x_,Friday}->x];
Last[SortBy[Cases[FridaysOfTheYear[2011], {_,#,_}], #[[3]] &]]& /@ Range[12] // Column
