from itertools import chain

def f_rec_tailfail(values=[0, 1], combine=sum):
  """
  This fails with `RecursionError: maximum recursion depth exceeded`
  when the number of consumed elements surpasses maximum stack size
  (by default 1000 call frames -- `sys.getrecursionlimit()`),
  due to the fact that Python does not have tail call optimization.
  """
  yield values[0]
  yield from f_rec_tailfail(values[1:] + [combine(values)], combine)


def f_rec_gen_func(values=[0, 1], combine=sum):
  """
  This function does not suffer from `RecursionError` per se, but stack overflow
  nevertheless does happen in the underlying C code when too many elements are
  consumed from the generator.

  One possible reason for this is because `chain` is implemented in C,
  and the chain consists of another `chain` object, which in turn contains
  another `chain` object, etc. The effect of this is that all the recursive
  calls happen on the C call stack (where recursion depth is not checked
  against the limit), not on the Python call stack. As a result, it is possible
  to achieve much greater recursion depth -- over 40,000 recursive calls
  instead of mere 1000. When a stack overflow eventually happens, the Python
  interpreter crashes quietly without any error message (CPython 3.11.3 AMD64).
  """
  def generate_values():
    yield [values[0]]
    yield f_rec_gen_func(values[1:] + [combine(values)], combine)
  return chain.from_iterable(generate_values())


def f_rec_gen_lambdas(values=[0, 1], combine=sum):
  """
  Similar to `f_rec_gen_func`; also does not suffer from `RecursionError`
  but crashes when many values are consumed.
  """
  return chain.from_iterable(
    f()
    for f in (
      lambda: [values[0]],
      lambda: f_rec_gen_lambdas(values[1:] + [combine(values)], combine),
    )
  )
