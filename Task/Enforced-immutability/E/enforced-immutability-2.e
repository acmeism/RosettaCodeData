var y := 1

def things :DeepFrozen := [&x, 2, 3]  # This is OK

def funnyThings :DeepFrozen := [&y, 2, 3]  # Error: y's slot is not immutable
