# make -f do.mk C=mycond if
C=0

if:
   -@expr $(C) >/dev/null && make -f do.mk true; exit 0
   -@expr $(C) >/dev/null || make -f do.mk false; exit 0

true:
   @echo "was true."

false:
   @echo "was false."
