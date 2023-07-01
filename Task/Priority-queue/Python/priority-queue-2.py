>>> import queue
>>> help(queue.PriorityQueue)
Help on class PriorityQueue in module queue:

class PriorityQueue(Queue)
 |  Variant of Queue that retrieves open entries in priority order (lowest first).
 |
 |  Entries are typically tuples of the form:  (priority number, data).
 |
 |  Method resolution order:
 |      PriorityQueue
 |      Queue
 |      builtins.object
 |
 |  Methods inherited from Queue:
 |
 |  __init__(self, maxsize=0)
 |
 |  empty(self)
 |      Return True if the queue is empty, False otherwise (not reliable!).
 |
 |      This method is likely to be removed at some point.  Use qsize() == 0
 |      as a direct substitute, but be aware that either approach risks a race
 |      condition where a queue can grow before the result of empty() or
 |      qsize() can be used.
 |
 |      To create code that needs to wait for all queued tasks to be
 |      completed, the preferred technique is to use the join() method.
 |
 |  full(self)
 |      Return True if the queue is full, False otherwise (not reliable!).
 |
 |      This method is likely to be removed at some point.  Use qsize() >= n
 |      as a direct substitute, but be aware that either approach risks a race
 |      condition where a queue can shrink before the result of full() or
 |      qsize() can be used.
 |
 |  get(self, block=True, timeout=None)
 |      Remove and return an item from the queue.
 |
 |      If optional args 'block' is true and 'timeout' is None (the default),
 |      block if necessary until an item is available. If 'timeout' is
 |      a positive number, it blocks at most 'timeout' seconds and raises
 |      the Empty exception if no item was available within that time.
 |      Otherwise ('block' is false), return an item if one is immediately
 |      available, else raise the Empty exception ('timeout' is ignored
 |      in that case).
 |
 |  get_nowait(self)
 |      Remove and return an item from the queue without blocking.
 |
 |      Only get an item if one is immediately available. Otherwise
 |      raise the Empty exception.
 |
 |  join(self)
 |      Blocks until all items in the Queue have been gotten and processed.
 |
 |      The count of unfinished tasks goes up whenever an item is added to the
 |      queue. The count goes down whenever a consumer thread calls task_done()
 |      to indicate the item was retrieved and all work on it is complete.
 |
 |      When the count of unfinished tasks drops to zero, join() unblocks.
 |
 |  put(self, item, block=True, timeout=None)
 |      Put an item into the queue.
 |
 |      If optional args 'block' is true and 'timeout' is None (the default),
 |      block if necessary until a free slot is available. If 'timeout' is
 |      a positive number, it blocks at most 'timeout' seconds and raises
 |      the Full exception if no free slot was available within that time.
 |      Otherwise ('block' is false), put an item on the queue if a free slot
 |      is immediately available, else raise the Full exception ('timeout'
 |      is ignored in that case).
 |
 |  put_nowait(self, item)
 |      Put an item into the queue without blocking.
 |
 |      Only enqueue the item if a free slot is immediately available.
 |      Otherwise raise the Full exception.
 |
 |  qsize(self)
 |      Return the approximate size of the queue (not reliable!).
 |
 |  task_done(self)
 |      Indicate that a formerly enqueued task is complete.
 |
 |      Used by Queue consumer threads.  For each get() used to fetch a task,
 |      a subsequent call to task_done() tells the queue that the processing
 |      on the task is complete.
 |
 |      If a join() is currently blocking, it will resume when all items
 |      have been processed (meaning that a task_done() call was received
 |      for every item that had been put() into the queue).
 |
 |      Raises a ValueError if called more times than there were items
 |      placed in the queue.
 |
 |  ----------------------------------------------------------------------
 |  Data descriptors inherited from Queue:
 |
 |  __dict__
 |      dictionary for instance variables (if defined)
 |
 |  __weakref__
 |      list of weak references to the object (if defined)

>>>
