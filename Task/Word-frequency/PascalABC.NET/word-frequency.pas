##
ReadAllText('135-0.txt').ToLower.MatchValues('\w+').EachCount
  .OrderByDescending(w -> w.Value).Take(10).PrintLines
