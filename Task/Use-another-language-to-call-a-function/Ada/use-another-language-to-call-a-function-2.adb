package body Exported is
   function Query (Data : chars_ptr; Size : access size_t)
      return int is
      Result : char_array := "Here am I";
   begin
      if Size.all < Result'Length then
         return 0;
      else
         Update (Data, 0, Result);
         Size.all := Result'Length;
         return 1;
      end if;
   end Query;
end Exported;
