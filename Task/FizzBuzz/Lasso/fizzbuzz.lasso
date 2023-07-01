with i in generateSeries(1, 100)
select ((#i % 3 == 0 ? 'Fizz' | '') + (#i % 5 == 0 ? 'Buzz' | '') || #i)
