#!/usr/bin/env bash
main() {
  # Our ten males:
  local males=(abe bob col dan ed fred gav hal ian jon)

  # And ten females:
  local females=(abi bea cath dee eve fay gay hope ivy jan)

  # Everyone's preferences, ranked most to least desirable:
  local  abe=( abi  eve  cath ivy  jan  dee  fay  bea  hope gay )
  local  abi=( bob  fred jon  gav  ian  abe  dan  ed   col  hal )
  local  bea=( bob  abe  col  fred gav  dan  ian  ed   jon  hal )
  local  bob=(cath  hope abi  dee  eve  fay  bea  jan  ivy  gay )
  local cath=(fred  bob  ed   gav  hal  col  ian  abe  dan  jon )
  local  col=(hope  eve  abi  dee  bea  fay  ivy  gay  cath jan )
  local  dan=( ivy  fay  dee  gay  hope eve  jan  bea  cath abi )
  local  dee=(fred  jon  col  abe  ian  hal  gav  dan  bob  ed  )
  local   ed=( jan  dee  bea  cath fay  eve  abi  ivy  hope gay )
  local  eve=( jon  hal  fred dan  abe  gav  col  ed   ian  bob )
  local  fay=( bob  abe  ed   ian  jon  dan  fred gav  col  hal )
  local fred=( bea  abi  dee  gay  eve  ivy  cath jan  hope fay )
  local  gav=( gay  eve  ivy  bea  cath abi  dee  hope jan  fay )
  local  gay=( jon  gav  hal  fred bob  abe  col  ed   dan  ian )
  local  hal=( abi  eve  hope fay  ivy  cath jan  bea  gay  dee )
  local hope=( gav  jon  bob  abe  ian  dan  hal  ed   col  fred)
  local  ian=(hope  cath dee  gay  bea  abi  fay  ivy  jan  eve )
  local  ivy=( ian  col  hal  gav  fred bob  abe  ed   jon  dan )
  local  jan=( ed   hal  gav  abe  bob  jon  col  ian  fred dan )
  local  jon=( abi  fay  jan  gay  eve  bea  dee  cath ivy  hope)

  # A place to store the engagements:
  local -A engagements=()

  # Our list of free males, initially comprised of all of them:
  local freemales=( "${males[@]}" )

  # Now we use the Gale-Shapley algorithm to find a stable set of engagements

  # Loop over the free males. Note that we can't use for..in because the body
  # of the loop may modify the array we're looping over
  local -i m=0
  while (( m < ${#freemales[@]} )); do
    local male=${freemales[m]}
    let m+=1

    # This guy's preferences
    eval 'local his=("${'"$male"'[@]}")'

    # Starting with his favorite
    local -i f=0
    local female=${his[f]}

    # Find her preferences
    eval 'local hers=("${'"$female"'[@]}")'

    # And her current fiancé, if any
    local fiance=${engagements[$female]}

    # If she has a fiancé and prefers him to this guy, look for this guy's next
    # best choice
    while [[ -n $fiance ]] &&
      (( $(index "$male" "${hers[@]}") > $(index "$fiance" "${hers[@]}") )); do
      let f+=1
      female=${his[f]}
      eval 'hers=("${'"$female"'[@]}")'
      fiance=${engagements[$female]}
    done

    # If we're still on someone who's engaged, it means she prefers this guy
    # to her current fiancé. Dump him and put him at the end of the free list.
    if [[ -n $fiance ]]; then
      freemales+=("$fiance")
      printf '%-4s rejected %-4s\n' "$female" "$fiance"
    fi

    # We found a match! Record it
    engagements[$female]=$male
    printf '%-4s accepted %-4s\n' "$female" "$male"
  done

  # Display the final result, which should be stable
  print_couples engagements

  # Verify its stability
  print_stable engagements "${females[@]}"

  # Try a swap
  printf '\nWhat if cath and ivy swap partners?\n'
  local temp=${engagements[cath]}
  engagements[cath]=${engagements[ivy]}
  engagements[ivy]=$temp

  # Display the new result, which should be unstable
  print_couples engagements

  # Verify its instability
  print_stable engagements "${females[@]}"
}

# utility function - get index of an item in an array
index() {
  local needle=$1
  shift
  local haystack=("$@")
  local -i i
  for i in "${!haystack[@]}"; do
    if [[ ${haystack[i]} == $needle ]]; then
      printf '%d\n' "$i"
      return 0
    fi
  done
  return 1
}

# print the couples from the engagement array; takes name of array as argument
print_couples() {
  printf '\nCouples:\n'
  local keys
  mapfile -t keys < <(eval 'printf '\''%s\n'\'' "${!'"$1"'[@]}"' | sort)
  local female
  for female in "${keys[@]}"; do
    eval 'local male=${'"$1"'["'"$female"'"]}'
    printf '%-4s is engaged to %-4s\n' "$female" "$male"
  done
  printf '\n'
}

# print whether a set of engagements is stable; takes name of engagement array
# followed by the list of females
print_stable() {
  if stable "$@"; then
    printf 'These couples are stable.\n'
  else
    printf 'These couples are not stable.\n'
  fi
}

# determine if a set of engagements is stable; takes name of engagement array
# followed by the list of females
stable() {
  local dict=$1
  shift
  eval 'local shes=("${!'"$dict"'[@]}")'
  eval 'local hes=("${'"$dict"'[@]}")'
  local -i i
  local -i result=0
  for (( i=0; i<${#shes[@]}; ++i )); do
    local she=${shes[i]} he=${hes[i]}
    eval 'local his=("${'"$he"'[@]}")'
    local alt
    for alt in "$@"; do
      eval 'local fiance=${'"$dict"'["'"$alt"'"]}'
      eval 'local hers=("${'"$alt"'[@]}")'
      if (( $(index "$she" "${his[@]}") > $(index "$alt" "${his[@]}")
         && $(index "$fiance" "${hers[@]}") > $(index "$he" "${hers[@]}") ))
       then
        printf '%-4s is engaged to %-4s but prefers %4s, ' "$he" "$she" "$alt"
        printf 'while %-4s is engaged to %-4s but prefers %4s.\n' "$alt" "$fiance" "$he"
        result=1
      fi
    done
  done
  if (( result )); then printf '\n'; fi
  return $result
}

main "$@"
