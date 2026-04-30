   package Other_Class is
      type Object is new My_Class.Object with null record;
      overriding procedure Primitive(Self: Object);
   end Other_Class;

   package body Other_Class is
      procedure Primitive(Self: Object) is
      begin
	 Put_Line("Hello Universe!");
      end Primitive;
   end Other_Class;
