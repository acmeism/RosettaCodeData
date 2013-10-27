$ yes r | ./f                                                         # rock
rock, paper, scissors?  scoring computer choice (r) and your choice (r)
rock, paper, scissors?  scoring computer choice (s) and your choice (r)
rock, paper, scissors?  scoring computer choice (r) and your choice (r)
...
rock, paper, scissors?  scoring computer choice (p) and your choice (r)
 I'm bored out of my skull
 Who's keeping score anyway???
 25.5  4.5
yes: standard output: Broken pipe
yes: write error
$ yes p 2>/dev/null | ./f                                             # paper
rock, paper, scissors?  scoring computer choice (r) and your choice (p)
rock, paper, scissors?  scoring computer choice (s) and your choice (p)
rock, paper, scissors?  scoring computer choice (r) and your choice (p)
rock, paper, scissors?  scoring computer choice (s) and your choice (p)
...
rock, paper, scissors?  scoring computer choice (s) and your choice (p)
 I'm bored out of my skull
 Who's keeping score anyway???
 25.5  4.5
$ yes scissors 2>/dev/null | ./f                                      # scissors
rock, paper, scissors?  scoring computer choice (r) and your choice (s)
rock, paper, scissors?  scoring computer choice (r) and your choice (s)
...
rock, paper, scissors?  scoring computer choice (r) and your choice (s)
 I'm bored out of my skull
 Who's keeping score anyway???
 26.5  3.5
$
