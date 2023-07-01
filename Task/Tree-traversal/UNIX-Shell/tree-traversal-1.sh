left=()
right=()
value=()

# node node#, left#, right#, value
#
# if value is empty, use node#

node() {
  nx=${1:-'Missing node index'}
  leftx=${2}
  rightx=${3}
  val=${4:-$1}
  value[$nx]="$val"
  left[$nx]="$leftx"
  right[$nx]="$rightx"
}

# define the tree

node 1 2 3
node 2 4 5
node 3 6
node 4 7
node 5
node 6 8 9
node 7
node 8
node 9

# walk NODE# ORDER

walk() {
  local nx=${1-"Missing index"}
  shift
  for branch in "$@" ; do
    case "$branch" in
      left)  if [[ "${left[$nx]}" ]];      then walk ${left[$nx]}  $@ ; fi ;;
      right) if [[ "${right[$nx]}" ]];     then walk ${right[$nx]} $@ ; fi ;;
      self)  printf "%d " "${value[$nx]}"  ;;
    esac
  done
}

apush() {
  local var="$1"
  eval "$var=( \"\${$var[@]}\" \"$2\" )"
}

showname() {
  printf "%-12s " "$1:"
}

showdata() {
  showname "$1"
  shift
  walk "$@"
  echo ''
}

preorder()  { showdata $FUNCNAME $1 self left right ; }
inorder()   { showdata $FUNCNAME $1 left self right ; }
postorder() { showdata $FUNCNAME $1 left right self ; }
levelorder() {
  showname 'level-order'
  queue=( $1 )
  x=0
  while [[ $x < ${#queue[*]} ]]; do
    value="${queue[$x]}"
    printf "%d " "$value"
    for more in "${left[$value]}" "${right[$value]}" ; do
      if [[ -n "$more" ]]; then
	apush queue "$more"
      fi
    done
    : $((x++))
  done
  echo ''
}

preorder   1
inorder    1
postorder  1
levelorder 1
