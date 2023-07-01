package require Thread

# How to create a mutex
set m [thread::mutex create]

# This will block if the lock is already held unless the mutex is made recursive
thread::mutex lock $m
# Now locked...
thread::mutex unlock $m
# Unlocked again

# Dispose of the mutex
thread::mutex destroy $m
