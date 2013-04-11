say substr('knight', 1);       # strip first character - sub
say 'knight'.substr(1);        # strip first character - method

say substr('socks', 0, -1);    # strip last character - sub
say 'socks'.substr( 0, -1);    # strip last character - method

say substr('brooms', 1, -1);   # strip both first and last characters - sub
say 'brooms'.substr(1, -1);    # strip both first and last characters - method
