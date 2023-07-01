# using ping to sleep #
INT milliseconds = read int; # ping uses milliseconds #
print ("Sleeping...");
VOID (system ("ping 0.0.0.1 -n 1 -w " + whole (milliseconds, 0) + " >NUL"));
# 0.0.0.1 is an invalid IP address and cannot be used, so this will never conflict with a real IP address #
# ping -n gives number of tries, -w timeout, and >NUL deletes output so the user does not see it #
print (new line);
print ("Awake!")
