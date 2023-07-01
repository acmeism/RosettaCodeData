q = .queue~of(2,4,6)   -- creates a queue containing 3 items
say q[1] q[3]          -- displays "2 6"
i = q~pull             -- removes the first item
q~queue(i)             -- adds it to the end
say q[1] q[3]          -- displays "4 2"
q[1] = q[1] + 1        -- updates the first item
say q[1] q[3]          -- displays "5 2"
