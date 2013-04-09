>>> for s in ['0', '00', '123', '-123.', '-123e-4', '0123', '0x1a1', '-123+4.5j', '0b0101', '0.123', '-0xabc', '-0b101']:
    print "%14s -> %-14s %s" % ('"'+s+'"', is_numeric(s), type(is_numeric(s)))

           "0" -> 0              <type 'int'>
          "00" -> 0              <type 'int'>
         "123" -> 123            <type 'int'>
       "-123." -> -123.0         <type 'float'>
     "-123e-4" -> -0.0123        <type 'float'>
        "0123" -> 83             <type 'int'>
       "0x1a1" -> 417            <type 'int'>
   "-123+4.5j" -> (-123+4.5j)    <type 'complex'>
      "0b0101" -> 5              <type 'int'>
       "0.123" -> 0.123          <type 'float'>
      "-0xabc" -> -2748          <type 'int'>
      "-0b101" -> -5             <type 'int'>
>>>
