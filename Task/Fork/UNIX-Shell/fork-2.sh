(for ((i=0;i<10;i++)); do sleep 1; echo "Child process"; done) &
for ((i=0;i<5;i++)); do
  sleep 2
  echo "Parent process"
done
