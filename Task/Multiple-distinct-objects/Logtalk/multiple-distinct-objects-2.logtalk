| ?- create_object(state, [instantiates(state)], [public(state/1)], [state(0)]),
     findall(
         Id,
         (integer::between(1, 10, N),
          create_object(Id, [instantiates(state)], [], [state(N)])),
         Ids
     ).
Ids = [o1, o2, o3, o4, o5, o6, o7, o8, o9, o10].
