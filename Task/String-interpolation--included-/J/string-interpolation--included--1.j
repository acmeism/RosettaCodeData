   require 'printf'
   'Mary had a %s lamb.' sprintf <'little'
Mary had a little lamb.

   require 'strings'
   ('%s';'little') stringreplace 'Mary had a %s lamb.'
Mary had a little lamb.
   'Mary had a %s lamb.' rplc '%s';'little'
Mary had a little lamb.
