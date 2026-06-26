local fd=${2:-200}

# create lock file
eval "exec $fd>/tmp/my_lock.lock"

# acquire the lock, or fail
flock -nx $fd \
&& # do something if you got the lock \
|| # do something if you did not get the lock
