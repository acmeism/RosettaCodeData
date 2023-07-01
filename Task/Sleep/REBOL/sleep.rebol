REBOL [
    Title: "Sleep Main Thread"
    URL: http://rosettacode.org/wiki/Sleep_the_Main_Thread
]

naptime: to-integer ask "Please enter sleep time in seconds: "
print "Sleeping..."
wait naptime
print "Awake!"
