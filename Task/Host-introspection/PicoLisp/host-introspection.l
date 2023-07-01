(in (cmd)                              # Inspect ELF header
   (rd 4)                              # Skip "7F" and 'E', 'L' and 'F'
   (prinl
      (case (rd 1)                     # Get EI_CLASS byte
         (1 "32 bits")
         (2 "64 bits")
         (T "Bad EI_CLASS") ) )
   (prinl
      (case (rd 1)                     # Get EI_DATA byte
         (1 "Little endian")
         (2 "Big endian")
         (T "Bad EI_DATA") ) ) )
