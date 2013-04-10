: (setq IntSpace 12345)          # Integer
-> 12345

: (setq Address (adr 'IntSpace)) # Encoded machine address
-> -2969166782547

: (set (adr Address) 65535)      # Set this address to a new value
-> 65535

: IntSpace                       # Show the new value
-> 65535
