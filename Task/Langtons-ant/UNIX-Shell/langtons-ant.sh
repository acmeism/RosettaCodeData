function main {
  typeset -i width=$(tput cols)
  typeset -i height=$(tput lines)
  typeset -a grid
  typeset -i i
  for (( i=0; i<height; ++i )); do
    grid+=("$(printf "%${width}s" ' ')")
  done
  typeset -i x=$(( width / 2 )) y=$(( height / 2 ))
  (( dx=0, dy = 1 - 2*RANDOM%2 ))
  if (( RANDOM % 2 )); then
    (( dy=0, dx = 1 - 2*RANDOM%2 ))
  fi
  printf '\e[H';
  printf '%s\n' "${grid[@]}"
  tput civis
  while (( x>=0 && x < width && y >=0 && y< height)); do
     (( i=y ))
     if [[ -n $ZSH_VERSION ]]; then
        (( i += 1 ))
     fi
     ch=${grid[i]:$x:1}
    if [[ $ch == '#' ]]; then
      (( t=dx, dx=dy, dy=-t ))
      grid[i]=${grid[i]:0:$x}' '${grid[i]:$x+1}
    else
      (( t=dx, dx=-dy, dy=t ))
      grid[i]=${grid[i]:0:$x}'#'${grid[i]:$x+1}
    fi
    (( x += dx, y += dy ))
    tput cup $y 0 && printf '%s' "${grid[i]}"
  done
  tput cnorm
  read line
  return
}

main "$@"
