proc trim &s$ .
   a = 1
   while substr s$ a 1 = " " : a += 1
   b = len s$
   while substr s$ b 1 = " " : b -= 1
   s$ = substr s$ a (b - a + 1)
.
func$ rev s$ .
   a$[] = strchars s$
   for i to len a$[] div 2
      swap a$[i] a$[len a$[] - i + 1]
   .
   return strjoin a$[] ""
.
func$ invert s$ .
   for c$ in strchars s$
      if c$ = " "
         r$ &= "#"
      else
         r$ &= " "
      .
   .
   return r$
.
digs$[] = [ "   ## #" "  ##  #" "  #  ##" " #### #" " #   ##" " ##   #" " # ####" " ### ##" " ## ###" "   # ##" ]
func[] decode_upc upc$ .
   subr getdigs
      for i to 6
         h$ = substr upc$ pos 7
         for dig to 10
            d$ = digs$[dig]
            if isright = 1 : d$ = invert d$
            if h$ = d$ : break 1
         .
         if dig = 11 : return [ ]
         dig -= 1
         digs[] &= dig
         sum += dig * sumf
         sumf = 4 - sumf
         pos = pos + 7
      .
   .
   if len upc$ <> 95 : return [ ]
   if substr upc$ 1 3 <> "# #" : return [ ]
   pos = 4
   sumf = 3
   getdigs
   if substr upc$ pos 5 <> " # # " : return [ ]
   pos += 5
   isright = 1
   getdigs
   if substr upc$ 1 3 <> "# #" : return [ ]
   if sum mod 10 <> 0 : return [ ]
   return digs[]
.
barcodes$[] = [ "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       " "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         " "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         " "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        " "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          " "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         " "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        " "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         " "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       " "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         " ]
for s$ in barcodes$[]
   trim s$
   r[] = decode_upc s$
   if r[] = [ ]
      r[] = decode_upc rev s$
   .
   print r[]
.
