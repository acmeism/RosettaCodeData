leap() {
  if expr $1 % 4 >/dev/null; then return 1; fi
  if expr $1 % 100 >/dev/null; then return 0; fi
  if expr $1 % 400 >/dev/null; then return 1; fi
  return 0;
}
