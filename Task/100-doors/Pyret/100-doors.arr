data Door:
  | open
  | closed
end

fun flip-door(d :: Door) -> Door:
  cases(Door) d:
    | open => closed
    | closed => open
  end
end


fun flip-doors(doors :: List<Door>) -> List<Door>:
  doc:```Given a list of door positions, repeatedly switch the positions of
      every nth door for every nth pass, and return the final list of door
      positions```
  for fold(flipped-doors from doors, n from range(1, doors.length() + 1)):
    for map_n(m from 1, d from flipped-doors):
      if num-modulo(m, n) == 0:
        flip-door(d)
      else:
        d
      end
    end
  end
where:
    flip-doors([list: closed, closed, closed]) is
  [list: open, closed, closed]

  flip-doors([list: closed, closed, closed, closed]) is
  [list: open, closed, closed, open]

  flip-doors([list: closed, closed, closed, closed, closed, closed]) is
  [list: open, closed, closed, open, closed, closed]

  closed-100 = for map(_ from range(1, 101)): closed end
  answer-100 = for map(n from range(1, 101)):
    if num-is-integer(num-sqrt(n)): open
    else: closed
    end
  end

  flip-doors(closed-100) is answer-100
end

fun find-indices<A>(pred :: (A -> Boolean), xs :: List<A>) -> List<Number>:
    doc:```Given a list and a predicate function, produce a list of index
      positions where there's a match on the predicate```
  ps = map_n(lam(n,e): if pred(e): n else: -1 end end, 1, xs)
  ps.filter(lam(x): x >= 0 end)
where:
  find-indices((lam(i): i == true end), [list: true,false,true]) is [list:1,3]
end


fun run(n):
  doc:```Given a list of doors that are closed, make repeated passes
      over the list, switching the positions of every nth door for
      each nth pass. Return a list of positions in the list where the
      door is Open.```
  doors = repeat(n, closed)
  ys = flip-doors(doors)
  find-indices((lam(y): y == open end), ys)
where:
  run(4) is [list: 1,4]
end

run(100)
