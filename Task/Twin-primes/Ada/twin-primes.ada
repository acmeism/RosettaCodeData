     1	-- Rosetta Code Task written in Ada
     2	-- Twin primes
     3	-- https://rosettacode.org/wiki/Twin_primes
     4	-- Using GNAT Big Integers, GNAT version 14.1, MacOS 14.6.1, M1 chip
     5	-- Brute-force method; I tried several other methods...results about the same: very slow after 10^7
     6	-- I terminated the execution after 10^7, I lost patience for 10^8 and 10^9
     7	-- September 2024, R. B. E.
     8	
     9	pragma Ada_2022;
    10	with Ada.Text_IO; use Ada.Text_IO;
    11	with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
    12	with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;
    13	with Ada.Real_Time; use Ada.Real_Time;
    14	
    15	procedure Twin_Primes is
    16	
    17	  function Is_Prime (N : in Big_Integer) return Boolean is
    18	    Big_0 : Big_Natural := To_Big_Integer (0);
    19	    Big_2 : Big_Natural := To_Big_Integer (2);
    20	    Big_3 : Big_Natural := To_Big_Integer (3);
    21	    Big_Temp : Big_Natural := To_Big_Integer (5);
    22	  begin
    23	    if N < Big_2 then
    24	      return False;
    25	    end if;
    26	    if N mod Big_2 = Big_0 then
    27	      return N = Big_2;
    28	    end if;
    29	    if N mod Big_3 = Big_0 then
    30	      return N = Big_3;
    31	    end if;
    32	    while Big_Temp * Big_Temp <= N loop
    33	      if N mod Big_Temp = Big_0 then
    34	        return False;
    35	      end if;
    36	      Big_Temp := Big_Temp + Big_2;
    37	      if N mod Big_Temp = Big_0 then
    38	        return False;
    39	      end if;
    40	      Big_Temp := Big_Temp + 4;
    41	    end loop;
    42	    return True;
    43	  end Is_Prime;
    44	
    45	  procedure Display_Results (Limit : Big_Positive; Total : Natural; Elapsed_Time : Time_Span) is
    46	  begin
    47	    Put ("There are ");
    48	    Put (Total, 10);
    49	    Put (" Twin Primes under ");
    50	    Put (To_String (Limit));
    51	    Put (" CPU Time spent so far ");
    52	    Put (Duration'Image (To_Duration (Elapsed_Time)) & " seconds");
    53	    New_Line;
    54	  end Display_Results;
    55	
    56	  Limit_1 : Big_Positive := To_Big_Integer (10);
    57	  Limit_2 : Big_Positive := Limit_1 ** 2;
    58	  Limit_3 : Big_Positive := Limit_1 ** 3;
    59	  Limit_4 : Big_Positive := Limit_1 ** 4;
    60	  Limit_5 : Big_Positive := Limit_1 ** 5;
    61	  Limit_6 : Big_Positive := Limit_1 ** 6;
    62	  Limit_7 : Big_Positive := Limit_1 ** 7;
    63	  Limit_8 : Big_Positive := Limit_1 ** 8;
    64	  Limit_9 : Big_Positive := Limit_1 ** 9;
    65	  Max : Big_Positive := Limit_1 ** 10;
    66	
    67	  Big_One :  Big_Positive := To_Big_Integer (1);
    68	  Big_Two :  Big_Positive := To_Big_Integer (2);
    69	  Big_Three :  Big_Positive := To_Big_Integer (3);
    70	  Candidate : Big_Positive := Big_Three;
    71	  Twin_Prime_Count : Natural := 0;
    72	  Run_Display : Natural := 0;
    73	  Start_Time, Stop_Time : Time;
    74	  Elapsed_Time          : Time_Span;
    75	
    76	begin
    77	  Start_Time := Clock;
    78	  loop
    79	    if (Is_Prime (Candidate) and (Is_Prime (Candidate + Big_Two))) then
    80	      Twin_Prime_Count := Twin_Prime_Count + 1;
    81	    end if;
    82	    Candidate := Candidate + Big_Two;
    83	    if (Candidate - Big_One = Limit_1) then
    84	      Stop_Time := Clock;
    85	      Elapsed_Time := Stop_Time - Start_Time;
    86	      Display_Results (Limit_1, Twin_Prime_Count, Elapsed_Time);
    87	    elsif (Candidate - Big_One = Limit_2) then
    88	      Stop_Time := Clock;
    89	      Elapsed_Time := Stop_Time - Start_Time;
    90	      Display_Results (Limit_2, Twin_Prime_Count, Elapsed_Time);
    91	    elsif (Candidate - Big_One = Limit_3) then
    92	      Stop_Time := Clock;
    93	      Elapsed_Time := Stop_Time - Start_Time;
    94	      Display_Results (Limit_3, Twin_Prime_Count, Elapsed_Time);
    95	    elsif (Candidate - Big_One = Limit_4) then
    96	      Stop_Time := Clock;
    97	      Elapsed_Time := Stop_Time - Start_Time;
    98	      Display_Results (Limit_4, Twin_Prime_Count, Elapsed_Time);
    99	    elsif (Candidate - Big_One = Limit_5) then
   100	      Stop_Time := Clock;
   101	      Elapsed_Time := Stop_Time - Start_Time;
   102	      Display_Results (Limit_5, Twin_Prime_Count, Elapsed_Time);
   103	    elsif (Candidate - Big_One = Limit_6) then
   104	      Stop_Time := Clock;
   105	      Elapsed_Time := Stop_Time - Start_Time;
   106	      Display_Results (Limit_6, Twin_Prime_Count, Elapsed_Time);
   107	    elsif (Candidate - Big_One = Limit_7) then
   108	      Stop_Time := Clock;
   109	      Elapsed_Time := Stop_Time - Start_Time;
   110	      Display_Results (Limit_7, Twin_Prime_Count, Elapsed_Time);
   111	    elsif (Candidate - Big_One = Limit_8) then
   112	      Stop_Time := Clock;
   113	      Elapsed_Time := Stop_Time - Start_Time;
   114	      Display_Results (Limit_8, Twin_Prime_Count, Elapsed_Time);
   115	    elsif (Candidate - Big_One = Limit_9) then
   116	      Stop_Time := Clock;
   117	      Elapsed_Time := Stop_Time - Start_Time;
   118	      Display_Results (Limit_9, Twin_Prime_Count, Elapsed_Time);
   119	    elsif (Candidate - Big_One = Max) then
   120	      Stop_Time := Clock;
   121	      Elapsed_Time := Stop_Time - Start_Time;
   122	      Display_Results (Max, Twin_Prime_Count, Elapsed_Time);
   123	    else
   124	      null;
   125	    end if;
   126	--    exit when (Candidate > Max);
   127	    exit when (Candidate > Limit_7);
   128	  end loop;
   129	end Twin_Primes;
