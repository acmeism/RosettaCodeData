package body URL is
   function Decode (URL : in String) return String is
      Buffer   : String (1 .. URL'Length);
      Filled   : Natural := 0;
      Position : Positive := URL'First;
   begin
      while Position in URL'Range loop
         Filled := Filled + 1;

        case URL (Position) is
            when '+' =>
               Buffer (Filled) := ' ';
               Position := Position + 1;
            when '%' =>
               Buffer (Filled) :=
                 Character'Val
                   (Natural'Value
                      ("16#" & URL (Position + 1 .. Position + 2) & "#"));
               Position := Position + 3;
            when others =>
               Buffer (Filled) := URL (Position);
               Position := Position + 1;
         end case;
      end loop;

      return Buffer (1 .. Filled);
   end Decode;
end URL;
