function trim(str) {
    gsub(/^[[:blank:]]+/,"", str) # Remove leading
    gsub(/[[:blank:]]+$/,"", str) # Remove trailing
    gsub(/^[[:blank:]]+|[[:blank:]]+$/, "", str) # Remove both
    return str;
}
