#!/bin/bash
# michaeltd	2019-11-29 https://github.com/michaeltd/dots/blob/master/dot.files/.bashrc.d/.var/morse.sh
# https://en.wikipedia.org/wiki/Morse_code
# International Morse Code
# 1. Length of dot is 1 unit
# 2. Length of dash is 3 units
# 3. The space between parts of the same letter is 1 unit
# 4. The space between letters is 3 units.
# 5. The space between words is 7 units.
################################################################################

alpha2morse() {
  local -A alpha_assoc=(    [A]='.-'    [B]='-...'   [C]='-.-.' [D]='-..' [E]='.' \
    [F]='..-.'  [G]='--.'   [H]='....'  [I]='..'     [J]='.---' \
    [K]='-.-'   [L]='.-..'  [M]='--'    [N]='-.'     [O]='---' \
    [P]='.--.'  [Q]='--.-'  [R]='.-.'   [S]='...'    [T]='-' \
    [U]='..-'   [V]='...-'  [W]='.--'   [X]='-..-'   [Y]='-.--' [Z]='--..' \
    [0]='-----' [1]='.----' [2]='..---' [3]='...--'  [4]='....-' \
    [5]='.....' [6]='-....' [7]='--...' [8]='----..' [9]='----.' )

  if [[ "${#}" -lt "1" ]]; then
     echo -ne "Usage: ${FUNCNAME[0]} arguments...\n \
        ${FUNCNAME[0]} is an IMC transmitter. \n \
        It'll transmit your messages to International Morse Code.\n" >&2
     return 1
  fi

  while [[ -n "${1}" ]]; do
        for (( i = 0; i < ${#1}; i++ )); do
            local letter="${1:${i}:1}"
            for (( y = 0; y < ${#alpha_assoc[${letter^^}]}; y++ )); do
                case "${alpha_assoc[${letter^^}]:${y}:1}" in
                     ".") echo -n "dot "; play -q -n -c2 synth .1 2> /dev/null || sleep .1 ;;
                     "-") echo -n "dash "; play -q -n -c2 synth .3 2> /dev/null || sleep .3 ;;
                esac
                sleep .1
            done
            echo
            sleep .3
        done
        echo
        sleep .7
        shift
  done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
   alpha2morse "${@}"
fi
