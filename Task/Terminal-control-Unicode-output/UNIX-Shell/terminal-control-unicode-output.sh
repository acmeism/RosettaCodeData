unicode_tty() {
  # LC_ALL supersedes LC_CTYPE, which supersedes LANG.
  # Set $1 to environment value.
  case y in
  ${LC_ALL:+y})		set -- "$LC_ALL";;
  ${LC_CTYPE:+y})	set -- "$LC_CTYPE";;
  ${LANG:+y})		set -- "$LANG";;
  y)			return 1;;  # Assume "C" locale not UTF-8.
  esac
  # We use 'case' to perform pattern matching against a string.
  case "$1" in
  *UTF-8*)		return 0;;
  *)			return 1;;
  esac
}

if unicode_tty; then
  # printf might not know \u or \x, so use octal.
  # U+25B3 => UTF-8 342 226 263
  printf "\342\226\263\n"
else
  echo "HW65001 This program requires a Unicode compatible terminal" >&2
  exit 252    # Incompatible hardware
fi
