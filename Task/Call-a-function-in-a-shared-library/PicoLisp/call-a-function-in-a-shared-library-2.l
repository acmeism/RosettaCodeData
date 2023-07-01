: (setq Display (native "/usr/lib/libX11.so.6" "XOpenDisplay" 'N ":0.0"))
-> 6502688
: (native "/usr/lib/libX11.so.6" "XCloseDisplay" 'I Display)
-> 0
