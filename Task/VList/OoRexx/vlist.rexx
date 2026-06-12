-- show how to use the queue class
q = .queue~of(1, 2, 3, 4)

-- show indexed access to item
say q[4]

-- update an item
q[2] = "Fred"

-- show update and that other indexes are unchanged
say q[2] q[4]

-- push an item on the front and show the change in positions
q~push("Mike")
say q[1] q[2] q[4]

-- pop an item and show the change again
q~pull
say q[1] q[2] q[4]

