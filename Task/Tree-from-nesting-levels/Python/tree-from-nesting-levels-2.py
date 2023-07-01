def to_tree(x: list) -> list:
   nested = []
   stack = [nested]
   for this in x:
       while this != len(stack):
           if this > len(stack):
               innermost = []               # new level
               stack[-1].append(innermost)  # nest it
               stack.append(innermost)      # push it
           else: # this < stack:
               stack.pop(-1)
       stack[-1].append(this)

   return nested
