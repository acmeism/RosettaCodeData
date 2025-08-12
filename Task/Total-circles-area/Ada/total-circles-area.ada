with Ada.Text_IO;

procedure Circles_Area is
   type Point is record
      X, Y : Float;
   end record;

   type Circle is record
      P : Point;
      R : Float;
   end record;

   type Box is record
      P1, P2 : Point;
   end record;

   type Circle_Array is array (1 .. 25) of Circle;

   Circles : constant Circle_Array :=
     (
       ((1.6417233788, 1.6121789534), 0.0848270516),
       ((-1.4944608174, 1.2077959613), 1.1039549836),
       ((0.6110294452, -0.6907087527), 0.9089162485),
       ((0.3844862411, 0.2923344616), 0.2375743054),
       ((-0.2495892950, -0.3832854473), 1.0845181219),
       ((1.7813504266, 1.6178237031), 0.8162655711),
       ((-0.1985249206, -0.8343333301), 0.0538864941),
       ((-1.7011985145, -0.1263820964), 0.4776976918),
       ((-0.4319462812, 1.4104420482), 0.7886291537),
       ((0.2178372997, -0.9499557344), 0.0357871187),
       ((-0.6294854565, -1.3078893852), 0.7653357688),
       ((1.7952608455, 0.6281269104), 0.2727652452),
       ((1.4168575317, 1.0683357171), 1.1016025378),
       ((1.4637371396, 0.9463877418), 1.1846214562),
       ((-0.5263668798, 1.7315156631), 1.4428514068),
       ((-1.2197352481, 0.9144146579), 1.0727263474),
       ((-0.1389358881, 0.1092805780), 0.7350208828),
       ((1.5293954595, 0.0030278255), 1.2472867347),
       ((-0.5258728625, 1.3782633069), 1.3495508831),
       ((-0.1403562064, 0.2437382535), 1.3804956588),
       ((0.8055826339, -0.0482092025), 0.3327165165),
       ((-0.6311979224, 0.7184578971), 0.2491045282),
       ((1.4685857879, -0.8347049536), 1.3670667538),
       ((-0.6855727502, 1.6465021616), 1.0593087096),
       ((0.0152957411, 0.0638919221), 0.9771215985)
     );

   function Bounding_Box return Box is
      C : Circle := Circles (1);
      Left : Float := C.P.X - C.R;
      Right : Float := C.P.X + C.R;
      Down : Float := C.P.Y - C.R;
      Up : Float := C.P.Y + C.R;
   begin
      for I in Circles'Range loop
         C := Circles (I);
         Left := Float'Min (Left, C.P.X - C.R);
         Right := Float'Max (Right, C.P.X + C.R);
         Down := Float'Min (Down, C.P.Y - C.R);
         Up := Float'Max (Up, C.P.Y + C.R);
      end loop;

      return ((Left, Down), (Right, Up));
   end Bounding_Box;

   function Distance2 (P1, P2 : Point) return Float is
     ((P2.X - P1.X) ** 2 + (P2.Y - P1.Y) ** 2);

   function Is_Inside (P : Point) return Boolean is
      C : Circle;
   begin
      for I in Circles'Range loop
         C := Circles (I);
         if Distance2 (C.P, P) < C.R ** 2 then
            return True;
         end if;
      end loop;

      return False;
   end Is_Inside;

   --  Use grid sampling
   function Area return Float is
      Bounds : constant Box := Bounding_Box;
      X_Span : constant Float := (Bounds.P2.X - Bounds.P1.X);
      Y_Span : constant Float := (Bounds.P2.Y - Bounds.P1.Y);
      Grid_Area : constant Float := X_Span * Y_Span;
      Steps : constant Integer := 1000;
      Points_In, Points_Out : Integer := 0;
      P : Point;
   begin
      for I in 1 .. Steps loop
         for J in 1 .. Steps loop
            P.X := Bounds.P1.X + X_Span * Float (I) / Float (Steps);
            P.Y := Bounds.P1.Y + Y_Span * Float (J) / Float (Steps);
            if Is_Inside (P) then
               Points_In := Points_In + 1;
            else
               Points_Out := Points_Out + 1;
            end if;
         end loop;
      end loop;

      return Grid_Area * Float (Points_In) / Float (Points_In + Points_Out);
   end Area;

begin
   Ada.Text_IO.Put ("Circles area is " & Area'Image);
end Circles_Area;
