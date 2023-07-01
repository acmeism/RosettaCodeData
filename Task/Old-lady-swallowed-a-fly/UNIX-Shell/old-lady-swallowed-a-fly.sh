animals=(fly spider bird cat dog pig goat cow donkey horse)
comments=("I don't know why she swallowed that fly"
          "That wriggled and jiggled and tickled inside her"
          "Quite absurd, to swallow a bird"
          "How about that, to swallow a cat"
          "What a hog, to swallow a dog"
          "Her mouth was so big to swallow a pig"
          "She just opened her throat to swallow a goat."
          "I don't know how she swallowed a cow."
          "It was rather wonky to swallow a donkey"
          "She's dead, of course!")
include=(2 2 1 1 1 1 1 1 1 0)

for (( i=0; i<${#animals[@]}; ++i )); do
   echo "There was an old lady who swallowed a ${animals[i]}"
   echo "${comments[i]}"
   if (( include[i] )); then
     if (( i )); then
       for (( j=i-1; j>=0; --j )); do
         echo "She swallowed the ${animals[j+1]} to catch the ${animals[j]}"
         if (( include[j] > 1 )); then
           echo "${comments[j]}"
         fi
       done
     fi
     echo "Perhaps she'll die"
     echo
   fi
done
