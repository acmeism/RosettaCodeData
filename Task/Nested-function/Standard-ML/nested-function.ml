fun make_list separator =
  let
    val counter = ref 1;
    fun make_item item =
      let
        val result = Int.toString (!counter) ^ separator ^ item ^ "\n"
      in
        counter := !counter + 1;
        result
      end
  in
    make_item "first" ^ make_item "second" ^ make_item "third"
  end;

print (make_list ". ")
