def builtinsort(x):
    x.sort()

def partition(seq, pivot):
   low, middle, up = [], [], []
   for x in seq:
       if x < pivot:
           low.append(x)
       elif x == pivot:
           middle.append(x)
       else:
           up.append(x)
   return low, middle, up
import random
def qsortranpart(seq):
   size = len(seq)
   if size < 2: return seq
   low, middle, up = partition(seq, random.choice(seq))
   return qsortranpart(low) + middle + qsortranpart(up)
