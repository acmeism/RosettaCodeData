with ada.command_line, ada.containers.indefinite_vectors, ada.text_io;
procedure compare_lengths is
   package string_vector is new ada.containers.indefinite_vectors
     (index_type => Positive, element_type => String);

   function "<" (left, right : String) return Boolean is
   begin
      return left'length > right'length;
   end "<";

   package string_vector_sorting is new string_vector.generic_sorting;
   list : string_vector.Vector;
begin
   for i in 1 .. ada.command_line.argument_count loop
      list.append (ada.command_line.argument (i));
   end loop;
   string_vector_sorting.sort (list);
   for elem of list loop
      ada.text_io.put_line (elem'length'image & ": " & elem);
   end loop;
end compare_lengths;
