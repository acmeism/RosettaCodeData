   function s = cipherCaesar(s, key)
          s = char( mod(s - 'A' + key, 25 ) + 'A');
   end; 	
   function s = decipherCaesar(s, key)
          s = char( mod(s - 'A' - key, 25 ) + 'A');
   end;
