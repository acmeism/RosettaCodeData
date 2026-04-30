type Price is delta 0.01 digits 3 range 0.0..1.0;
function Scale (Value : Price) return Price is
   X : constant array (1..19) of Price :=
          (  0.06, 0.11, 0.16, 0.21, 0.26,  0.31, 0.36, 0.41, 0.46, 0.51,
             0.56, 0.61, 0.66, 0.71, 0.76,  0.81, 0.86, 0.91, 0.96
          );
   Y : constant array (1..20) of Price :=
          (  0.10, 0.18, 0.26, 0.32, 0.38,  0.44, 0.50, 0.54, 0.58, 0.62,
             0.66, 0.70, 0.74, 0.78, 0.82,  0.86, 0.90, 0.94, 0.98, 1.0
          );
   Low    : Natural := X'First;
   High   : Natural := X'Last;
   Middle : Natural;
begin
   loop
      Middle := (Low + High) / 2;
      if Value = X (Middle) then
         return Y (Middle + 1);
      elsif Value < X (Middle) then
         if Low = Middle then
            return Y (Low);
         end if;
         High := Middle - 1;
      else
         if High = Middle then
            return Y (High + 1);
         end if;
         Low := Middle + 1;
      end if;
   end loop;
end Scale;
