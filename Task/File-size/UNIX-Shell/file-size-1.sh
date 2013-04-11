size1=$(ls -l input.txt | tr -s ' ' | cut -d ' ' -f 5)
size2=$(ls -l /input.txt | tr -s ' ' | cut -d ' ' -f 5)
