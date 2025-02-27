##
function jortsort<T>(Self: sequence of T): boolean;
extensionmethod;
begin
  result := Self.SequenceEqual(Self.sorted);
end;

(1..10).jortsort.println;
[1,2,3].jortsort.println;
'abcdefgc'.jortsort.Println;
