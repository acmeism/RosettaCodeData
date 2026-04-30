#!/usr/bin/env bash
declare -i -a CRC32_LOOKUP_TABLE

__generate_crc_lookup_table() {
  local -i -r LSB_CRC32_POLY=0xEDB88320 # The CRC32 polynomal LSB order
  local -i index byte lsb
  for index in {0..255}; do
    ((byte = 255 - index))
    for _ in {0..7}; do # 8-bit lsb shift
      ((lsb = byte & 0x01, byte = ((byte >> 1) & 0x7FFFFFFF) ^ (lsb == 0 ? LSB_CRC32_POLY : 0)))
    done
    ((CRC32_LOOKUP_TABLE[index] = byte))
  done
}
__generate_crc_lookup_table
typeset -r CRC32_LOOKUP_TABLE

crc32_string() {
  [[ ${#} -eq 1 ]] || return
  local -i i byte crc=0xFFFFFFFF index
  for ((i = 0; i < ${#1}; i++)); do
    byte=$(printf '%d' "'${1:i:1}") # Get byte value of character at i
    ((index = (crc ^ byte) & 0xFF, crc = (CRC32_LOOKUP_TABLE[index] ^ (crc >> 8)) & 0xFFFFFFFF))
  done
  echo $((crc ^ 0xFFFFFFFF))
}

printf 'The CRC32 of: %s\nis: 0x%08x\n' "${1}" "$(crc32_string "${1}")"

# crc32_string "The quick brown fox jumps over the lazy dog"
# yields 414fa339
