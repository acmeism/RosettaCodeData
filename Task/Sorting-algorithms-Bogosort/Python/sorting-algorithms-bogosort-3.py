import random
def bogosort(lst):
   random.shuffle(lst)  # must shuffle it first or it's a bug if lst was pre-sorted! :)
   while lst != sorted(lst):
       random.shuffle(lst)
   return lst
