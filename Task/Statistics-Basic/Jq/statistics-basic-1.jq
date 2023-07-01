# Usage: prng N width
function prng {
  cat /dev/urandom | tr -cd '0-9' | fold -w "$2" | head -n "$1"
}
