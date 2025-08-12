stack = .queue~of(123, 234)  -- creates a stack with a couple of items
stack~push("Abc")   -- pushing
value = stack~pull  -- popping
say 'popped:' value
value = stack~peek  -- peeking
say 'peeked:' value
-- the is empty test
if stack~isEmpty then say "The stack is empty"
Else say stack~items 'items are on the stack'
