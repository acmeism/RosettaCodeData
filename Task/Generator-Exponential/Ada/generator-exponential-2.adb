package Generator.Filtered is

   type Filtered_Generator is new Generator with private;
   procedure Reset (Gen : in out Filtered_Generator);
   function Get_Next (Gen : access Filtered_Generator) return Natural;

   procedure Set_Source (Gen    : in out Filtered_Generator;
                         Source : access Generator);
   procedure Set_Filter (Gen    : in out Filtered_Generator;
                         Filter : access Generator);

private

   type Filtered_Generator is new Generator with record
      Last_Filter : Natural := 0;
      Source, Filter : access Generator;
   end record;

end Generator.Filtered;
