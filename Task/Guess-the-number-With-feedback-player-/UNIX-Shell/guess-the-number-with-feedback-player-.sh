read -p "Lower bound: " lower
read -p "Upper bound: " upper
moves=0
PS3="> "
while :; do
    ((moves++))
    guess=$(( lower + (upper-lower)/2 ))
    echo "Is it $guess?"
    select ans in "too small" "too big" "got it!"; do
        case $ans in
            "got it!")   break 2 ;;
            "too big")   upper=$(( upper==guess ? upper-1 : guess )); break ;;
            "too small") lower=$(( lower==guess ? lower+1 : guess )); break ;;
        esac
    done
    ((lower>upper)) && echo "you must be cheating!"
done
echo "I guessed it in $moves guesses"
