say callit(.routines~fib, 10)
say callit(.routines~fact, 6)
say callit(.routines~square, 13)
say callit(.routines~cube, 3)
say callit(.routines~reverse, 721)
say callit(.routines~sumit, 1, 2)
say callit(.routines~sumit, 2, 4, 6, 8)

-- call the provided routine object with the provided variable number of arguments
::routine callit
  use arg function
  args = arg(2, 'a')   -- get all arguments after the first to pass along
  return function~callWith(args)  -- and pass along the call

::routine cube
  use arg n
  return n**3

::routine square
  use arg n
  return n**2

::routine reverse
  use arg n
  return reverse(n)

::routine fact
   use arg n
   accum = 1
   loop j = 2 to n
     accum = accum * j
   end
   return accum

::routine sumit
  use arg n
  accum = 0
  do i over arg(1, 'a')  -- iterate over the array of args
     accum += i
  end
  return accum

::routine fib
  use arg n
  if n == 0 then
     return n
  if n == 1 then
     return n
  last = 0
  next = 1
  loop j = 2 to n;
    current = last + next
    last = next
    next = current
  end
  return current
