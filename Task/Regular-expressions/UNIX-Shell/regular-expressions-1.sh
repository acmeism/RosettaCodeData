s="I am a string"
if [[ $s =~ str..g$ ]]; then
    echo "the string ends with 'str..g'"
fi
