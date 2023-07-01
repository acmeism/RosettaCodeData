C=0

if: true false

true:
   @expr $(C) >/dev/null && exit 0 || exit 1
   @echo "was true."

false:
   @expr $(C) >/dev/null && exit 1 || exit 0
   @echo "was false."
