function boolVal {
    if (( ! $? )); then
        echo true
    else
        echo false
    fi
}

a=true
b=false
printf '%s and %s = %s\n' "$a" "$b" "$("$a" && "$b"; boolVal)"
printf '%s or %s = %s\n' "$a" "$b" "$("$a" || "$b"; boolVal)"
printf 'not %s = %s\n' "$a" "$(! "$a"; boolVal)"
