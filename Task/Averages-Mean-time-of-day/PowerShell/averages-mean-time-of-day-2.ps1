[timespan]$meanTimeOfDay = "23:00:17","23:40:20","00:12:45","00:17:19" | Get-MeanTimeOfDay
"Mean time is {0}" -f (Get-Date $meanTimeOfDay.ToString()).ToString("hh:mm:ss tt")
