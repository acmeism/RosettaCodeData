if [[ "${text}" == "$(rev <<< "${text}")" ]]; then
   echo "Palindrome"
else
   echo "Not a palindrome"
fi
