# acquire a lock -- block execution until it becomes free
an_object.mu_lock

# acquire a lock -- return immediately even if not acquired
got_lock = an_object.mu_try_lock

# have a lock?
if an_object.mu_locked? then ...

# release the lock
an_object.mu_unlock

# wrap a lock around a block of code -- block execution until it becomes free
an_object.my_synchronize do
  do critical stuff
end
