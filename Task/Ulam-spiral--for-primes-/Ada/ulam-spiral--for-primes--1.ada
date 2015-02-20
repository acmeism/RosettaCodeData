generic
   Size: Positive;
      -- determines the size of the square
   with function Represent(N: Natural) return String;
      -- this turns a number into a string to be printed
      -- the length of the output should not change
      -- e.g., Represent(N) may return " #" if N is a prime
      -- and "  " else
   with procedure Put_String(S: String);
      -- outputs a string, no new line
   with procedure New_Line;
      -- the name says all
package Generic_Ulam is

   procedure Print_Spiral;
   -- calls Put_String(Represent(I)) N^2 times
   --       and New_Line N times

end Generic_Ulam;
