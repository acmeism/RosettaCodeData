func isalphanum c$ .
   c = strcode c$
   return if c >= 65 and c <= 90 or c >= 97 and c <= 122 or c >= 48 and c <= 57
.
func$ exext path$ .
   for i = len path$ downto 1
      c$ = substr path$ i 1
      if isalphanum c$ = 1
         ex$ = c$ & ex$
      elif c$ = "."
         return ex$
      else
         break 1
      .
   .
.
for s$ in [ "http://example.com/download.tar.gz" "CharacterModel.3DS" ".desktop" "document" "document.txt_backup" "/etc/pam.d/login" ]
   print s$ & " -> " & exext s$
.
