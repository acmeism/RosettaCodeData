my @rows = slurp("triangle.txt").lines.map: { [.words] }

while @rows > 1 {
    my @last := @rows.pop;
    @rows[*-1] = (@rows[*-1][] Z+ (@last Zmax @last[1..*])).List;
}

say @rows;
