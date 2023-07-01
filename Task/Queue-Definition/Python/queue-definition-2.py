class FIFO:  ## NOT a new-style class, must not derive from "object"
   def __init__(self,*args):
       self.contents = list(args)
   def __call__(self):
       return self.pop()
   def empty(self):
       return bool(self.contents)
   def pop(self):
       return self.contents.pop(0)
   def __getattr__(self, attr):
       return getattr(self.contents,attr)
   def next(self):
       if not self:
           raise StopIteration
       return self.pop()
