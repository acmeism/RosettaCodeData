readconfig() (
    # redirect stdin to read from the given filename
    exec 0<"$1"

    declare -l varname
    while IFS=$' =\t' read -ra words; do
        # is it a comment or blank line?
        if [[ ${#words[@]} -eq 0 || ${words[0]} == ["#;"]* ]]; then
            continue
        fi

        # get the variable name
        varname=${words[0]}

        # split all the other words by comma
        value="${words[*]:1}"
        oldIFS=$IFS IFS=,
        values=( $value )
        IFS=$oldIFS

        # assign the other words to a "scalar" variable or array
        case ${#values[@]} in
            0) printf '%s=true\n' "$varname" ;;
            1) printf '%s=%q\n' "$varname" "${values[0]}" ;;
            *) n=0
               for value in "${values[@]}"; do
                   value=${value# }
                   printf '%s[%d]=%q\n' "$varname" $((n++)) "${value% }"
               done
               ;;
        esac
    done
)

# parse the config file and evaluate the output in the current shell
source <( readconfig config.file )

echo "fullname = $fullname"
echo "favouritefruit = $favouritefruit"
echo "needspeeling = $needspeeling"
echo "seedsremoved = $seedsremoved"
for i in "${!otherfamily[@]}"; do
    echo "otherfamily[$i] = ${otherfamily[i]}"
done
