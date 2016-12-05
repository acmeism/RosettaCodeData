: fcopy(in, out)
| f g |
   File newMode(in,  File.BINARY) dup open(File.READ) ->f
   File newMode(out, File.BINARY) dup open(File.WRITE) ->g

   while(f >> dup notNull) [ g addChar ] drop
   f close g close ;
