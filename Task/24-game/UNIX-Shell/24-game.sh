gen_digits() {
    awk 'BEGIN { srand()
                 for(i = 1; i <= 4; i++) print 1 + int(9 * rand())
         }' | sort
}

same_digits() {
    [ "$(tr -dc 0-9 | sed 's/./&\n/g' | grep . | sort)" = "$*" ]
}

guessed() {
    [ "$(echo "$1" | tr -dc '\n0-9()*/+-' | bc 2>/dev/null)" = 24 ]
}


while :
do
    digits=$(gen_digits)
    echo
    echo Digits: $digits
    read -r expr

    echo " $expr" | same_digits "$digits" || \
        { echo digits should be: $digits; continue; }

    guessed "$expr" && message=correct \
                    || message=wrong

    echo $message
done
