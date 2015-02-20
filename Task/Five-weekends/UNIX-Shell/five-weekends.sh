echo "Creating cal-file..."
echo > cal.txt
for ((y=1900; y <= 2100; y++)); do
  for ((m=1; m <= 12; m++)); do
   #echo $m $y
    cal -m $m $y >> cal.txt
  done
done
ls -la cal.txt

echo "Looking for month with 5 weekends:"
awk -f 5weekends.awk  cal.txt
