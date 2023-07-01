SimpleMovingAverage create averager3
SimpleMovingAverage create averager5 5
foreach n {1 2 3 4 5 5 4 3 2 1} {
    puts "Next number = $n, SMA_3 = [averager3 val $n], SMA_5 = [averager5 val $n]"
}
