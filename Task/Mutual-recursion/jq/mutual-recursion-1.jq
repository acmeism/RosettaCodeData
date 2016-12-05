def F: 0;  # declare required signature

def M: if . == 0 then 0 else . - ((. - 1) | M | F) end;
def F: if . == 0 then 1 else . - ((. - 1) | F | M) end;
