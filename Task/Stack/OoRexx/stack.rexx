stack = .queue~of(123, 234)  -- creates a stack with a couple of items
stack~push("Abc")   -- pushing
value = stack~pull  -- popping
value = stack~peek  -- peeking
-- the is empty test
if stack~isEmpty then say "The stack is empty"
