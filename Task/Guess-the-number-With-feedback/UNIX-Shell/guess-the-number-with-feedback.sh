function guess {
  [[ -n $BASH_VERSION ]] && shopt -s extglob
  [[ -n $ZSH_VERSION ]] && set -o KSH_GLOB
  local -i max=${1:-100}
  local -i number=RANDOM%max+1
  local -i guesses=0

  local guess
  while true; do
    echo -n "Guess my number! (range 1 - $max): "
    read guess
    if [[ "$guess" != +([0-9]) ]] || (( guess < 1 || guess > max )); then
      echo "Guess must be a number between 1 and $max."
      continue
    fi
    let guesses+=1
    if (( guess < number )); then
      echo "Too low!"
    elif (( guess == number )); then
      echo "You got it in $guesses guesses!"
      break
    else
      echo "Too high!"
    fi
  done
}
