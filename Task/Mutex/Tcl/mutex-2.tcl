set rw [thread::rwmutex create]

# Get and drop a reader lock
thread::rwmutex rlock $rw
thread::rwmutex unlock $rw

# Get and drop a writer lock
thread::rwmutex wlock $rw
thread::rwmutex unlock $rw

thread::rwmutex destroy $rw
