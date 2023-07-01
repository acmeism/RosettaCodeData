import Control.Parallel

data Task a = Idle | Make a
type TaskList a = [a]
type Results a = [a]
type TaskGroups a = [TaskList a]
type WorkerList a = [Worker a]
type Worker a = [Task a]

-- run tasks in parallel and collect their results
-- the function doesn't return until all tasks are done, therefore
-- finished threads wait for the others to finish.
runTasks :: TaskList a -> Results a
runTasks [] = []
runTasks (x:[]) = x : []
runTasks (x:y:[]) = y `par` x : y : []
runTasks (x:y:ys) = y `par` x : y : runTasks ys

-- take a list of workers with different numbers of tasks and group
-- them: first the first task of each worker, then the second one etc.
groupTasks :: WorkerList a -> TaskGroups a
groupTasks [] = []
groupTasks xs
    | allWorkersIdle xs = []
    | otherwise =
        concatMap extractTask xs : groupTasks (map removeTask xs)

-- return a task as a plain value
extractTask :: Worker a -> [a]
extractTask [] = []
extractTask (Idle:_) = []
extractTask (Make a:_) = [a]

-- remove the foremost task of each worker
removeTask :: Worker a -> Worker a
removeTask = drop 1

-- checks whether all workers are idle in this task
allWorkersIdle :: WorkerList a -> Bool
allWorkersIdle = all null . map extractTask

-- the workers must calculate big sums. the first sum of each worker
-- belongs to the first task, and so on.
-- because of laziness, nothing is computed yet.

-- worker1 has 5 tasks to do
worker1 :: Worker Integer
worker1 = map Make [ sum [1..n*1000000] | n <- [1..5] ]

-- worker2 has 4 tasks to do
worker2 :: Worker Integer
worker2 = map Make [ sum [1..n*100000] | n <- [1..4] ]

-- worker3 has 3 tasks to do
worker3 :: Worker Integer
worker3 = map Make [ sum [1..n*1000000] | n <- [1..3] ]

-- worker4 has 5 tasks to do
worker4 :: Worker Integer
worker4 = map Make [ sum [1..n*300000] | n <- [1..5] ]

-- worker5 has 4 tasks to do, but starts at the second task.
worker5 :: Worker Integer
worker5 = [Idle] ++ map Make [ sum [1..n*400000] | n <- [1..4] ]

-- group the workers' tasks
tasks :: TaskGroups Integer
tasks = groupTasks [worker1, worker2, worker3, worker4, worker5]

-- a workshop: take a function to operate the results and a group of tasks,
-- execute the tasks showing the process and process the results
workshop :: (Show a, Num a, Show b, Num b) => ([a] -> b) -> [[a]] -> IO ()
workshop func a = mapM_ doWork $ zip [1..length a] a
    where
        doWork (x, y) = do
            putStrLn $ "Doing task " ++ show x ++ "."
            putStrLn $ "There are " ++ show (length y) ++ " workers for this task."
            putStrLn "Waiting for all workers..."
            print $ func $ runTasks y
            putStrLn $ "Task " ++ show x ++ " done."

main = workshop sum tasks
