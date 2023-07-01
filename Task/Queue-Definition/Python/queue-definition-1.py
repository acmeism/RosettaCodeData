   class FIFO(object):
       def __init__(self, *args):
           self.contents = list(args)
       def __call__(self):
           return self.pop()
       def __len__(self):
           return len(self.contents)
       def pop(self):
           return self.contents.pop(0)
       def push(self, item):
           self.contents.append(item)
       def extend(self,*itemlist):
           self.contents += itemlist
       def empty(self):
           return bool(self.contents)
       def __iter__(self):
           return self
       def next(self):
           if self.empty():
               raise StopIteration
           return self.pop()

if __name__ == "__main__":
    # Sample usage:
    f = FIFO()
    f.push(3)
    f.push(2)
    f.push(1)
    while not f.empty():
        print f.pop(),
    # >>> 3 2 1
    # Another simple example gives the same results:
    f = FIFO(3,2,1)
    while not f.empty():
        print f(),
    # Another using the default "truth" value of the object
    # (implicitly calls on the length() of the object after
    # checking for a __nonzero__ method
    f = FIFO(3,2,1)
    while f:
        print f(),
    # Yet another, using more Pythonic iteration:
    f = FIFO(3,2,1)
    for i in f:
        print i,
