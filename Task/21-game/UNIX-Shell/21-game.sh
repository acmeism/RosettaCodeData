shopt -s expand_aliases
alias bind_variables='
{
  local -ri goal_count=21
  local -ri player_human=0
  local -ri player_computer=1
  local -i turn=1
  local -i total_count=0
  local -i input_number=0
  local -i choose_turn=0
}
'
whose_turn() {
  case $(( ( turn + choose_turn ) % 2 )) in
   ${player_human}) echo "player";;
   ${player_computer}) echo "computer";;
  esac
}
next_turn() {
  let turn++
}
validate_number() {
  ! test ${input_number} -ge 1 -a ${input_number} -le $( max_guess )
}
prompt_number() {
  local prompt_str
  test $( max_guess ) -eq 1 && {
    prompt_str="enter the number 1 to win"
  true
  } || {
    prompt_str="enter a number between 1 and $( max_guess )"
  }
  while [ ! ]
  do
   read -p "${prompt_str} (or quit): "
   input_number=${REPLY}
   case ${REPLY} in
    "quit") {
      false
      return
    } ;;
   esac
   validate_number || break
   echo "try again"
  done
}
update_count() {
  let total_count+=input_number
}
remaining_count() {
  echo $(( goal_count - total_count ))
}
max_guess() {
  local -i remaining_count
  remaining_count=$( remaining_count )
  case $( remaining_count ) in
    1|2|3) echo ${remaining_count} ;;
    *) echo 3 ;;
  esac
}
iter() {
  update_count
  next_turn
}
on_game_over() {
  test ! ${input_number} -eq $( remaining_count ) || {
    test ! "$( whose_turn )" = "player" && {
      echo -ne "\nYou won!\n\n"
    true
    } || {
      echo -ne "\nThe computer won!\nGAME OVER\n\n"
    }
    false
  }
}
on_game_start() {
  echo 21 Game
  read -p "Press enter key to start"
}
choose_turn() {
  let choose_turn=${RANDOM}%2
}
choose_number() {
  local -i remaining_count
  remaining_count=$( remaining_count )
  case ${remaining_count} in
   1|2|3) {
     input_number=${remaining_count}
   } ;;
   5|6|7) {
     let input_number=remaining_count-4
   } ;;
   *) {
     let input_number=${RANDOM}%$(( $( max_guess ) - 1 ))+1
   }
  esac
}
game_play() {
  choose_turn
  while [ ! ]
  do
    echo "Total now ${total_count} (remaining: $( remaining_count ))"
    echo -ne "Turn: ${turn} ("
    test ! "$( whose_turn )" = "player" && {
      echo -n "Your"
    true
    } || {
      echo -n "Computer"
    }
    echo " turn)"
    test ! "$( whose_turn )" = "player" && {
      prompt_number || break
    true
    } || {
      choose_number
      sleep 2
      echo "Computer chose ${input_number}"
    }
    on_game_over || break
    sleep 1
    iter
  done
}
21_Game() {
  bind_variables
  on_game_start
  game_play
}
if [ ${#} -eq 0 ]
then
 true
else
 exit 1
fi
21_Game
