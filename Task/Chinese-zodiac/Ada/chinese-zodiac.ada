with Ada.Text_IO; 	    use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
procedure Main is

	type Element_Index is mod 5;
	type Animal_Index  is mod 12;
	type Stem_Index    is mod 10;
	
	type Animal_Array  is array(Animal_Index  range <>) of Unbounded_String;
	type Element_Array is array(Element_Index range <>) of Unbounded_String;
	type Stem_Array    is array(Stem_Index    range <>) of Unbounded_String;

	
	Ani_Arr : 	Animal_Array 	:= 	(To_Unbounded_String ("Rat"),
						 To_Unbounded_String ("Ox"),
						 To_Unbounded_String ("Tiger"),
						 To_Unbounded_String ("Rabbit"),
						 To_Unbounded_String ("Dragon"),
						 To_Unbounded_String ("Snake"),
						 To_Unbounded_String ("Horse"),
						 To_Unbounded_String ("Sheep"),
						 To_Unbounded_String ("Monkey"),
						 To_Unbounded_String ("Rooster"),
						 To_Unbounded_String ("Dog"),
						 To_Unbounded_String ("Pig"));
								
	Bra_Arr :	Animal_Array	:=      (To_Unbounded_String ("子"),
					         To_Unbounded_String ("丑"),
					         To_Unbounded_String ("寅"),
				                 To_Unbounded_String ("卯"),
					         To_Unbounded_String ("辰"),
					         To_Unbounded_String ("巳"),
					         To_Unbounded_String ("午"),
					         To_Unbounded_String ("未"),
					         To_Unbounded_String ("申"),
					         To_Unbounded_String ("酉"),
					         To_Unbounded_String ("戌"),
					         To_Unbounded_String ("亥"));
	
	Ele_Arr : 	Element_Array 	:= 	(To_Unbounded_String ("Wood"),
						 To_Unbounded_String ("Fire"),
						 To_Unbounded_String ("Earth"),
						 To_Unbounded_String ("Metal"),
						 To_Unbounded_String ("Water"));
							
	Ste_Arr :	Stem_Array	:= 	(To_Unbounded_String ("甲"),
						 To_Unbounded_String ("乙"),
						 To_Unbounded_String ("丙"),
						 To_Unbounded_String ("丁"),
						 To_Unbounded_String ("戊"),
						 To_Unbounded_String ("己"),
						 To_Unbounded_String ("庚"),
						 To_Unbounded_String ("辛"),
						 To_Unbounded_String ("壬"),
						 To_Unbounded_String ("癸"));
									
	procedure Sexagenary (Year : Positive) is
		Base_Year : Positive := 1984;
		Temp      : Natural  := abs (Base_Year - Year);
		Temp_Float: Float    := 0.0;
		
		Ele_Idx   : Element_Index    := Element_Index'First;
		Ani_Idx   : Animal_Index     := Animal_Index'First;
		Ste_Idx   : Stem_Index       := Stem_Index'First;
		Result    : Unbounded_String := Null_Unbounded_String;
		begin
			Result := Result & Year'Image & " is the year of ";
			
			if Year >= Base_Year then
				Temp_Float := Float'Floor (Float (Temp) / Float (2));
				Ele_Idx    := Element_Index (Natural (Temp_Float) mod 5);
				Result     := Result & Ele_Arr (Ele_Idx) & " ";
				
				Ani_Idx := Animal_Index (Temp mod 12);
				Result  := Result & Ani_Arr (Ani_Idx) & " ";
			elsif Year < Base_Year then
				Temp_Float := Float'Ceiling (Float (Temp) / Float (2));
				Ele_Idx    := Ele_Idx - Element_Index (Natural (Temp_Float) mod 5);
				Result     := Result & Ele_Arr (Ele_Idx) & " ";
				
				Ani_Idx := Ani_Idx - Animal_Index (Temp mod 12);
				Result  := Result & Ani_Arr (Ani_Idx) & " ";
			end if;
			
			if Year mod 2 = 0 then
				Result := Result & "(yang). ";
			else
				Result := Result & "(yin). ";
			end if;

			Ani_Idx := Animal_Index'First;

			if Year >= Base_Year then
				Ste_Idx := Stem_Index (Temp mod 10);
				Result  := Result & Ste_Arr (Ste_Idx);
				
				Ani_Idx := Animal_Index (Temp mod 12);
				Result  := Result & Bra_Arr (Ani_Idx);			
			elsif Year < Base_Year then
				Ste_Idx := Ste_Idx - Stem_Index (Temp mod 10);
				Result  := Result & Ste_Arr (Ste_Idx);			
			
				Ani_Idx := Ani_Idx - Animal_Index (Temp mod 12);
				Result  := Result & Bra_Arr (Ani_Idx);
			end if;
			
			Put (To_String (Result));
	end Sexagenary;
	
    arr : array(Positive range <>) of Positive := (1935, 1938, 1968, 1972, 1976, 1984, 1985, 2017);
begin
    for I of arr loop
        Sexagenary (I);
        New_Line;
    end loop;
end Main;
