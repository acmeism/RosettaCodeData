case ${.sh.version} in
    *93[[:alpha:]]+*) :;; #this appears to be ksh93, we're OK
    *)  echo "version appears to be too old"
        exit              # otherwise, bail out
        ;;
esac

if [[ -z ${bloop+bloop has a value} ]]; then
    print "no bloop variable"
elsif (( abs(1) )); then
    print -- $(( abs(bloop) ))
fi

typeset -a int_vars
set | while IFS='=' read -r var value; do
    if [[ $value == +([[:digit:]]) ]]; then
        int_vars[n++]=$var
        let sum += $value
    fi
done
print "${int_vars[*]}"
print -- $sum
