urldecode() { local u="${1//+/ }"; printf '%b' "${u//%/\\x}"; }
