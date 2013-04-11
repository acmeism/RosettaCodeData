my \words = set slurp("unixdict.txt").lines;

my \sems = gather for words.list -> \word {
    my \drow = word.flip;
    take [word,drow] if drow ∈ words and drow lt word;
}

.say for +sems, sems.pick(5);
