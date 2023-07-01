def step_up1():
  """Straightforward implementation: keep track of how many level we
     need to ascend, and stop when this count is zero."""
  deficit = 1
  while deficit > 0:
    if step():
      deficit -= 1
    else:
      deficit += 1
