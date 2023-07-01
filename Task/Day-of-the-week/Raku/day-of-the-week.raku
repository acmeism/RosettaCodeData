say join ' ', grep { Date.new($_, 12, 25).day-of-week == 7 }, 2008 .. 2121;
