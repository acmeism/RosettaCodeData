d := Date today.
d printOn:Stdout format:'%y-%m-%d'. Stdout cr.
d printOn:Stdout format:'%(DayName), %(MonthName) %d, %y' language:#en. Stdout cr.
d printOn:Stdout format:'%(DayName), %(MonthName) %d, %y' language:#de. Stdout cr.
d printOn:Stdout format:'%(DayName), %(MonthName) %d, %y' language:#fr. Stdout cr.
