REBOL [
    Title: "Sleep Main Thread"
    Date: 2009-12-15
    Author: oofoe
    URL: http://rosettacode.org/wiki/Sleep_the_Main_Thread
]

naptime: to-integer ask "Please enter sleep time in seconds: "
print "Sleeping..."
wait naptime
print "Awake!"
