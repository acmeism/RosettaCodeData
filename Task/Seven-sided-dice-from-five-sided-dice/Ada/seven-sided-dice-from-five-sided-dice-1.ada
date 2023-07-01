package Random_57 is

   type Mod_7 is mod 7;

   function Random7 return Mod_7;
     -- a "fast" implementation, minimazing the calls to the Random5 generator
   function Simple_Random7 return Mod_7;
     -- a simple implementation

end Random_57;
