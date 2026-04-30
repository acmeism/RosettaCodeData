with Ada.Text_IO;

procedure Longest_Strings is
   use Ada.Text_IO;

   -- first, in order to strictly use integer, I use integer in
   -- place of an enumeration type: -1 => not-equal
   --                                0 => shorter - ignore, no print current string
   --                                1 => equal - print current and up-stream
   --                                2 => longer - no print upstream, only current and equal subsequent
   --                           others => null; -- must never happen.
   --
   -- Anything else that is tested or used that is not a string or integer
   -- is not used explicitly by me, but is a standard part of the language
   -- as provided in the standard libraries (like boolean "End_Of_File").

   function Measure_And_Print_N (O : String := ""; -- original/old string
                                 N : String := ""  -- next/new string
                                ) return Integer is
      T1 : String := O;
      T2 : String := N;
      L  : Integer := 1; -- Length defaults to the same;
      function Test_Length (O : in out String; -- original/old string
                            N : in out String) -- new/test-subject string
                            return Integer is
         function Test_Equal (O : in out String; N : in out String)
                              return Integer is
         begin
            O := N;
            return 1;
         exception
            when Constraint_Error =>
               return -1;
         end;
      begin
         case Test_Equal (O, N) is
         when -1 =>
            O (N'Range) := N;
            return 0;
         when 1 =>
            return 1;
         when others =>
            return -1;
         end case;
      exception
         when Constraint_Error =>
            return 2;
      end;
   begin
         case Test_Length (T1, T2) is
         when 0 =>

            -- N < O, so return "shorter"  do not print N

            if End_Of_File
            then
               return 0;
            else
               case Measure_And_Print_N (O, Get_Line) is
                  when 0 =>
                     return 0;
                  when 1 =>
                     return 0;
                  when 2 =>
                     return 2; -- carry up any subsequent canceling of print.
                  when others =>
                     raise Numeric_Error;
               end case;
            end if;
         when 1 =>

            -- O = N, so return "equal"  print N if all subsequent values are
            -- less than or equal to N

            if End_Of_File
            then
               Put_Line (N);
               return 1;
            else
               case Measure_And_Print_N (O, Get_Line) is
                  when 0 =>
                     Put_Line (N);
                     return 1;
                  when 1 =>
                     Put_Line (N);
                     return 1;
                  when 2 =>  -- carry up the subsequent canceling of print.
                     null;
                     return 2;
                  when others =>
                     raise Numeric_Error;
               end case;
            end if;
         when 2 =>

            -- N > O, so return "longer" to cancel printing all previous values
            -- and print N if it is also equal to or greater than descendant
            -- values.

            if End_Of_File
            then
               Put_Line (N);
               return 2;
            else
               case Measure_And_Print_N (N, Get_Line) is
                  when 0 =>
                     Put_Line (N);
                     return 2;
                  when 1 =>
                     Put_Line (N);
                     return 2;
                  when 2 =>  -- printing N cancelled by subsequent input.
                     null;
                     return 2;
                  when others =>
                     raise Numeric_Error;
               end case;
            end if;
         when others =>

            -- This should never happen - raise exception

            raise Numeric_Error;
         end case;
   end;
begin
   if End_Of_File
   then
      null;
   else
      case Measure_And_Print_N ("", Get_Line) is
         when 0 =>
            Put_Line (Current_Error,
                      "Error, Somehow the input line is calculated as less than zero!");
         when 1 =>
            Put_Line (Current_Error,
                      "All input lines appear to be blank.");
         when 2 =>
            null;
         when others =>
            raise Numeric_Error;
      end case;
   end if;
end;
