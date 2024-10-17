##
var ms: integer -> sequence of BigInteger := m -> 0.Step.Select(i -> BigInteger(i)**m);
var squares := ms(2);
var cubes := ms(3);
var filtered := squares.Where(square -> cubes.First(cube -> cube >= square) <> square);
filtered.Skip(20).Take(10).Println;
