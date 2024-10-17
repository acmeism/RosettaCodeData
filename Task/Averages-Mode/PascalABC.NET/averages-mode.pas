##
function modes<T>(s: sequence of T): sequence of T;
begin
  var count := s.EachCount;
  var best := count.Values.Max;
  result := new List<T>;
  foreach var k in count do
    if k.value = best then result := result + k.key;
end;

modes(|1, 3, 6, 6, 6, 6, 7, 7, 12, 12, 17|).Println;
modes(|1, 1, 2, 4, 4|).Println;
modes('sdsvdvddffffs').Println;
var a := new object[] (1, 'blue', 2, 7.5, 5, 'green', 'red', 5, 2, 'blue', 'white');
modes(a).Println;
