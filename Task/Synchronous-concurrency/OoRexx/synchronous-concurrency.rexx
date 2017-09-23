queue = .workqueue~new
input = .stream~new("jabberwocky.txt")
output = .output

reader = .filereader~new(input, queue)
writer = .filewriter~new(output, queue)

::class workQueue
::method init
  expose queue stopped actionpending
  queue = .queue~new
  stopped = .false
  actionPending = .false

-- add an item to the work queue.  This is a
-- guarded method, which means this is a synchronized access
::method addItem guarded
  expose queue actionPending
  use arg item
  -- add the item to the queue
  queue~queue(item)
  -- indicate there's something new.  This is a condition variable
  -- that any will wake up any thread that's waiting on access.  They'll
  -- be able to get access once we exit
  actionPending = .true

-- another method for coordinating access with the other thread.  This indicates
-- it is time to shut down
::method stop guarded
  expose actionPending stopped
  -- indicate this has been stopped and also flip the condition variable to
  -- wake up any waiters
  stopped = .true
  actionPending = .true

-- read the next item off of the queue.  .nil indicates we've reached
-- the last item on the queue.  This is also a guarded method, but we'll use
-- the GUARD ON instruction to wait for work if the queue is currently empty
::method nextItem
  expose queue stopped actionPending
  -- we might need to loop a little to get an item
  do forever
    -- if there's something on the queue, pull the front item and return
    if \queue~isEmpty then return queue~pull
    -- if the other thread says it is done sending is stuff, time to shut down
    if stopped then return .nil
    -- nothing on the queue, not stopped yet, so release the guard and wait until
    -- there's something pending to work on.
    guard on when actionPending
  end

-- one half of the synchronization effort.  This will read lines and
-- add them to the work queue.  The thread will terminate once we hit end-of-file
::class filereader
::method init
  -- accept a generic stream...the data source need not be a file
  use arg stream, queue

  reply   -- now multithreaded

  signal on notready
  loop forever
     queue~addItem(stream~linein)
  end
  -- we come here on an EOF condition.  Indicate we're done and terminate
  -- the thread
  notready:
  queue~stop

-- the other end of this.  This class will read lines from a work queue
-- and write it to a stream
::class filewriter
::method init
  -- accept a generic stream...the data source need not be a file
  use arg stream, queue

  reply   -- now multithreaded

  loop forever
     item = queue~nextItem
     -- .nil means last item received
     if item == .nil then return
     -- write to the stream
     stream~lineout(item)
  end
