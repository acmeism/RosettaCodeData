Dim sem As New Semaphore(5, 5) 'Indicates that up to 5 resources can be aquired
sem.WaitOne() 'Blocks until a resouce can be aquired
Dim oldCount = sem.Release() 'Returns a resource to the pool
'oldCount has the Semaphore's count before Release was called
