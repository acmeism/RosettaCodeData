with Ada.Text_IO;          use Ada.Text_IO;
with Unbounded_Unsigneds;  use Unbounded_Unsigneds;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Modular_Exponent is
begin
   Put_Line
   (  Image
      (  Mod_Pow
         (  Value ("2988348162058574136915891421498819466320163312926952423791023078876139"),
            Value ("2351399303373464486466122544523690094744975233415544072992656881240319"),
            From_Half_Word (10) ** 40
   )  )  );
end Modular_Exponent;
