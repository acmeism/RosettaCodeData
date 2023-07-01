import fusion/matching
{.experimental: "caseStmtMacros".}

type
  Colour = enum Empty, Red, Black
  RBTree[T] = ref object
    colour: Colour
    left, right: RBTree[T]
    value: T

proc `[]`[T](r: RBTree[T], idx: static[FieldIndex]): auto =
  ## enables tuple syntax for unpacking and matching
  when idx == 0: r.colour
  elif idx == 1: r.left
  elif idx == 2: r.value
  elif idx == 3: r.right

template B[T](l: untyped, v: T, r): RBTree[T] =
  RBTree[T](colour: Black, left: l, value: v, right: r)

template R[T](l: untyped, v: T, r): RBTree[T] =
  RBTree[T](colour: Red, left: l, value: v, right: r)

template balImpl[T](t: typed): untyped =
  case t
  of (colour: Red | Empty): discard
  of (Black, (Red, (Red, @a, @x, @b), @y, @c), @z, @d) |
    (Black, (Red, @a, @x, (Red, @b, @y, @c)), @z, @d) |
    (Black, @a, @x, (Red, (Red, @b, @y, @c), @z, @d)) |
    (Black, @a, @x, (Red, @b, @y, (Red, @c, @z, @d))):
    t = R(B(a, x, b), y, B(c, z, d))

proc balance*[T](t: var RBTree[T]) = balImpl[T](t)

template insImpl[T](t, x: typed): untyped =
  template E: RBTree[T] = RBTree[T]()
  case t
  of (colour: Empty): t = R(E, x, E)
  of (value: > x): t.left.ins(x); t.balance()
  of (value: < x): t.right.ins(x); t.balance()

proc insert*[T](tt: var RBTree[T], xx: T) =
  proc ins(t: var RBTree[T], x: T) = insImpl[T](t, x)
  tt.ins(xx)
  tt.colour = Black
