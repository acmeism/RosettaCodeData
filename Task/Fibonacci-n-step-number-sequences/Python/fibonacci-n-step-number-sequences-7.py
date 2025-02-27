from dataclasses import dataclass, field
from functools import wraps
from typing import Callable, Generator

GeneratorFunc = Callable[..., Generator]

@dataclass
class RecursiveCall:
  args:   tuple = ()
  kwargs: dict  = field(default_factory=dict)

def tail_recursive_generator(fun: GeneratorFunc) -> GeneratorFunc:
  @wraps(fun)
  def decorated(*args, **kwargs):
    while True:
      it = fun(*args, **kwargs)
      try:
        while True:
          yield next(it)
      except StopIteration as e:
        if not isinstance(res := e.value, RecursiveCall):
          return res
        args, kwargs = res.args, res.kwargs

  return decorated

@tail_recursive_generator
def f_rec_tail(values=(0, 1), combine=sum):
  """
  Does not crash or throw RecursionError! Yay!
  """
  yield values[0]
  # determining why we cannot call `f_rec_tail` directly
  # is left as an exercise for the reader...
  return RecursiveCall(args=(values[1:] + (combine(values),), combine))
