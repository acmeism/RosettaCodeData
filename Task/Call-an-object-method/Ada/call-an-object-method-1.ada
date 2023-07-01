   package My_Class is
      type Object is tagged private;
      procedure Primitive(Self: Object); -- primitive subprogram
      procedure Dynamic(Self: Object'Class);
      procedure Static;
   private
      type Object is tagged null record;
   end My_Class;
