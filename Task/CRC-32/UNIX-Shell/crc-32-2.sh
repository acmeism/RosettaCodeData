#!/usr/bin/env sh
# POSIX Shell CRC32 of string
# @Name: crc32.sh
# @Version: 1.0.1
# @Author: Léa Gris <lea.gris@noiraude.net>
# @Date: Wed, 27 Mar 2019
# @License: WTFPL http://www.wtfpl.net/

# POSIX Shell has no array or string index
# Implementing a pre-computed CRC32 byte indexed look-up table
# would cost more CPU cycles calling external tools like
# awk or tr to index records from a string.

# Computes the CRC32 of the input data stream
# <&1: The input data stream
# >&1: The CRC32 integer of the input data stream
crc32_stream() {
  crc=0xFFFFFFFF # The Initial CRC32 value
  p=0xedb88320   # The CRC32 polynomial
  r=0            # The polynomial reminder
  c=''           # The current character
  byte=0         # The byte value of the current character
  # Iterates each character of the input stream
  while c="$(dd bs=1 count=1 2>/dev/null)" && [ -n "$c" ]; do
    byte=$(printf '%d' "'$c")  # Converts the character into its byte value
    r=$(((crc & 0xff) ^ byte)) # XOR LSB of CRC with current byte
    # 8-bit lsb shift with XOR polynomial reminder when odd
    for _ in _ _ _ _ _ _ _ _; do
      t=$((r >> 1))
      r=$(((r & 1) ? t ^ p : t))
    done
    crc=$(((crc >> 8) ^ r)) # XOR MSB of CRC with Reminder
  done

  # Output CRC32 integer XOR mask 32 bits
  echo $((crc ^ 0xFFFFFFFF))
}

# Computes the CRC32 of the argument string
# 1: The argument string
# >&1: The CRC32 integer of the argument string
crc32_string() {
  [ $# -eq 1 ] || return # argument required
  # Streams with printf to prevent suffixing the string
  # with a newline, since echo -n is not available in POSIX Shell
  printf '%s' "$1" | crc32_stream
}

printf 'The CRC32 of: %s\nis: %08x\n' "$1" "$(crc32_string "$1")"

# crc32_string "The quick brown fox jumps over the lazy dog"
# yields 414fa339
