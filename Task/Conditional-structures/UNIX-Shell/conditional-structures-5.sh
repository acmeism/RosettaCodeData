# This is a while loop
l=1
while [ l -le 5 ]; do
  echo $l
done

# This is an until loop
l=1
until [ l -eq 5 ]; do
  echo $l
done
