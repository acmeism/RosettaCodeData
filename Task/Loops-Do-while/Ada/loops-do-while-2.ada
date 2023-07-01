for Value in 0..Integer'Last loop
   Put (Value);
   exit when Value mod 6 = 0;
end loop;
