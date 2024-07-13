begin
  var st := new Stack<integer>;
  var st1 := new Stack<integer>;
  st.Push(1);
  st.Push(2);
  st.Push(3);
  Println(st1,st);
  while st.Count <> 0 do
    st1.Push(st.Pop);
  Println(st1,st);
end.
