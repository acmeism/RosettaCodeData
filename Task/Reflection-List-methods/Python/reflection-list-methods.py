import inspect

# Sample classes for inspection
class Super(object):
  def __init__(self, name):
    self.name = name

  def __str__(self):
    return "Super(%s)" % (self.name,)

  def doSup(self):
    return 'did super stuff'

  @classmethod
  def cls(cls):
    return 'cls method (in sup)'

  @classmethod
  def supCls(cls):
    return 'Super method'

  @staticmethod
  def supStatic():
    return 'static method'

class Other(object):
  def otherMethod(self):
    return 'other method'

class Sub(Other, Super):
  def __init__(self, name, *args):
    super(Sub, self).__init__(name);
    self.rest = args;
    self.methods = {}

  def __dir__(self):
    return list(set( \
        sum([dir(base) for base in type(self).__bases__], []) \
        + type(self).__dict__.keys() \
        + self.__dict__.keys() \
        + self.methods.keys() \
      ))

  def __getattr__(self, name):
    if name in self.methods:
      if callable(self.methods[name]) and self.methods[name].__code__.co_argcount > 0:
        if self.methods[name].__code__.co_varnames[0] == 'self':
          return self.methods[name].__get__(self, type(self))
        if self.methods[name].__code__.co_varnames[0] == 'cls':
          return self.methods[name].__get__(type(self), type)
      return self.methods[name]
    raise AttributeError("'%s' object has no attribute '%s'" % (type(self).__name__, name))

  def __str__(self):
    return "Sub(%s)" % self.name

  def doSub():
    return 'did sub stuff'

  @classmethod
  def cls(cls):
    return 'cls method (in Sub)'

  @classmethod
  def subCls(cls):
    return 'Sub method'

  @staticmethod
  def subStatic():
    return 'Sub method'

sup = Super('sup')
sub = Sub('sub', 0, 'I', 'two')
sub.methods['incr'] = lambda x: x+1
sub.methods['strs'] = lambda self, x: str(self) * x

# names
[method for method in dir(sub) if callable(getattr(sub, method))]
# instance methods
[method for method in dir(sub) if callable(getattr(sub, method)) and hasattr(getattr(sub, method), '__self__') and getattr(sub, method).__self__ == sub]
#['__dir__', '__getattr__', '__init__', '__str__', 'doSub', 'doSup', 'otherMethod', 'strs']
# class methods
[method for method in dir(sub) if callable(getattr(sub, method)) and hasattr(getattr(sub, method), '__self__') and getattr(sub, method).__self__ == type(sub)]
#['__subclasshook__', 'cls', 'subCls', 'supCls']
# static & free dynamic methods
[method for method in dir(sub) if callable(getattr(sub, method)) and type(getattr(sub, method)) == type(lambda:nil)]
#['incr', 'subStatic', 'supStatic']

# names & values; doesn't include wrapped, C-native methods
inspect.getmembers(sub, predicate=inspect.ismethod)
# names using inspect
map(lambda t: t[0], inspect.getmembers(sub, predicate=inspect.ismethod))
#['__dir__', '__getattr__', '__init__', '__str__', 'cls', 'doSub', 'doSup', 'otherMethod', 'strs', 'subCls', 'supCls']
