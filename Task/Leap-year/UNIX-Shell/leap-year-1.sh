is_leap() {
  return $((${1%00} & 3))
}
