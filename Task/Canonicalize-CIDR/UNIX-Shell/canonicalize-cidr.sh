function inet_aton {
  typeset -i addr byte
  typeset -a bytes
  if [[ -n $BASH_VERSION ]]; then
    IFS=. read -a bytes <<<"$1"
  elif [[ -n $ZSH_VERSION ]]; then
    IFS=. bytes=($=1)
  else
    IFS=. bytes=($1)
  fi
  addr=0
  for byte in "${bytes[@]}"; do
    (( addr = 256 * addr + byte ))
  done
  printf '%s\n' "$addr"
}

function inet_ntoa {
  typeset -i addr=$1
  typeset dotted i
  for (( i=0; i<4; ++i )); do
    dotted=$(( addr & 255 ))${dotted:+.$dotted}
    (( addr >>= 8 ))
  done
  printf '%s\n' "$dotted"
}

function canonicalize_cidr {
  typeset ip prefix fixed
  typeset -i netmask  addr
  while (( $# )); do
    IFS=/ read ip prefix <<<"$1"
    netmask=$(( (-1 << (32-prefix)) & -1 ))
    addr=$(inet_aton "$ip")
    fixed=$(( addr & netmask ))
    printf '%s/%s\n' "$(inet_ntoa $fixed)" "$prefix"
    shift
  done
}

# demo code
if (( ! $# )); then
  set -- 36.18.154.103/12 62.62.197.11/29 67.137.119.181/4 161.214.74.21/24 184.232.176.184/18
fi
canonicalize_cidr "$@"
