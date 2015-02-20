echo "# ls:"
ls  -la  input.txt

echo "# stat:"
stat input.txt

echo "# Size:"
size1=$(ls -l input.txt | tr -s ' ' | cut -d ' ' -f 5)
size2=$(wc -c < input.txt | tr -d ' ')
echo $size1, $size2
