#!/usr/bin/env bash
mapfile -t name <<EOF
Aimhacks
EOF

main() {
  banner3d_1 "${name[@]}"
  echo
  banner3d_2 "${name[@]}"
  echo
  banner3d_3 "${name[@]}"
}

space() {
  local -i n i
  (( n=$1 )) || n=1
  if (( n < 1 )); then n=1; fi
  for ((i=0; i<n; ++i)); do
    printf ' '
  done
  printf '\n'
}

banner3d_1() {
  local txt i
  mapfile -t txt < <(printf '%s\n' "$@" | sed -e 's,#,__/,g' -e 's/ /   /g')
  for i in "${!txt[@]}"; do
    printf '%s%s\n' "$(space $(( ${#txt[@]} - i )))" "${txt[i]}"
  done
}

banner3d_2() {
  local txt i line line2
  mapfile -t txt < <(printf '%s \n' "$@")
  for i in "${!txt[@]}"; do
    line=${txt[i]}
    line2=$(printf '%s%s' "$(space $(( 2 * (${#txt[@]} - i) )))" "$(sed -e 's, ,   ,g' -e 's,#,///,g' -e 's,/ ,/\\,g' <<<"$line")")
    printf '%s\n%s\n' "$line2" "$(tr '/\\' '\\/' <<<"$line2")"
  done
}

banner3d_3() {
  # hard-coded fancy one
  cat <<'EOF'
  ______________      ___________    ___________   ____       ____␣
 /             /\    /          |\  /|          \ |\   \     |\   \
/_____________/  /| /___________||  ||___________\| \___\    |  \___\␣
|             \ / |/             \  /             | |   |    |  |   |
|   ________   |  |   ________   |  |    _________| |   |    |  |   |
|   |  |___|   |  |   | |____|   |  |   |_______  | |   |____|  |   |
|   | /    |   | /|   | /    |   |  |   |       \ | |   |     \ |   |
|   |/_____|   |/ |   |/_____|   |  |   |________\| |   |______\|   |
|              / /|              |  |             \ |               |
|    ______   \ / |    _______   |  \_________    | |    ________   |
|   |  |___|   |  |   | |    |   |  _________/|   | |   |    |  |   |
|   | /    |   |  |   | |    |   | |         ||   | |   |    |  |   |
|   |/_____|   | /|   | |    |   | |_________|/   | |   |     \ |   |
|              |/ |   | |    |   | |              | |   |      \|   |
|_____________/   |___|/     |___| |_____________/ \|___|       |___|
EOF
}

main "$@"
