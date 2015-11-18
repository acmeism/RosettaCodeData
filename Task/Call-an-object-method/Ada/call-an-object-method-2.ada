   package body My_Class is
      procedure Primitive(Self: Object) is
      begin
	 Put_Line("Hello World!");
      end Primitive;

      procedure Dynamic(Self: Object'Class) is
      begin
	 Put("Hi there! ... ");
	 Self.Primitive; -- dispatching call: calls different subprograms,
                         -- depending on the type of Self
      end Dynamic;

      procedure Static is
      begin
	 Put_Line("Greetings");
      end Static;
   end My_Class;
