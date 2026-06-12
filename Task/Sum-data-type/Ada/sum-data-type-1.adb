type Ret_Val (Found : Boolean) is record
   case Found is
      when True =>
         Position : Positive;
      when False =>
         null;
   end case;
end record;
