# POSIX requires "signed long" for shell arithmetic, so assume to have at
# least 31 bits available, which is sufficient to store (e - 1) * 10^9

declare -ir one=10**9
declare -i e n rfct=one

while (( rfct /= ++n ))
do e+=rfct
done

echo "$((e / one + 1)).$((e % one))"
