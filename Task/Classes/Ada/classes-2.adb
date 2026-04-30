 package body My_Package is
    procedure Some_Procedure(Item : out My_Type) is
    begin
       Item := 2 * Item;
    end Some_Procedure;

    function Set(Value : Integer) return My_Type is
       Temp : My_Type;
    begin
       Temp.Variable := Value;
       return Temp;
    end Set;
end My_Package;
