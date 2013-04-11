./foo.sh &
sleep 5
mv .fc .fc2 2>/dev/null
wc -l .fc2 2>/dev/null
rm .fc2
sleep 5
mv .fc .fc2 2>/dev/null
wc -l .fc2 2>/dev/null
sleep 5
mv .fc .fc2 2>/dev/null
wc -l .fc2 2>/dev/null
sleep 5
killall foo.sh
wc -l .fc 2>/dev/null
rm .fc
