#!/usr/bin/env bash
# sort-args.sh

data() {
  cat <<EOF
   123  456  0789
   456 0789  123
  0789  123  456
EOF
}

# sort_table [column NUM | KIND | reverse] ... <INPUT >OUTPUT
# KIND = lexicographical | numeric | human

sort_table() {
  local opts='-b'
  local column=1
  while (( $# > 0 )) ; do
    case "$1" in
      column|col|c)          column=${2?Missing column number} ; shift ;;
      lexicographical|lex|l) opts+=' -d' ;;
      numeric|num|n)         opts+=' -g' ;;
      human|hum|h)           opts+=' -h' ;;
      reverse|rev|r)         opts+=' -r' ;;
    esac
    shift
  done
  eval "sort $opts -k $column,$column -"
}

echo sort defaults          ; data | sort_table
echo sort defaults reverse  ; data | sort_table reverse
echo sort column 2          ; data | sort_table col 2
echo sort column 2 reverse  ; data | sort_table col 2 reverse
echo sort numeric           ; data | sort_table numeric
echo sort numeric reverse   ; data | sort_table numeric reverse
