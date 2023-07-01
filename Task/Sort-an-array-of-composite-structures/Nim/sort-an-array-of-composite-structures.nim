import algorithm, sugar

var people = @{"joe": 120, "foo": 31, "bar": 51}
sort(people, (x,y) => cmp(x[0], y[0]))
echo people
