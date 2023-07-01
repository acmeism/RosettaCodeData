type Person (Gender : Gender_Type) is record
   Name   : Name_String;
   Age    : Natural;
   Weight : Float;
   Case Gender is
      when Male =>
         Beard_Length : Float;
      when Female =>
         null;
   end case;
end record;
