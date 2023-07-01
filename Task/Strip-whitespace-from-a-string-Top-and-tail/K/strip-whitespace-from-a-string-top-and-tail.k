dlb: {((" "<x)?1)_x}
dtb: {(-(|" "<x)?1)_x}

dlb "    this is a test    "
"this is a test    "
dtb "    this is a test    "
"    this is a test"
dtb dlb "    this is a test    "
"this is a test"
dtb dlb "this is a test"
"this is a test"
