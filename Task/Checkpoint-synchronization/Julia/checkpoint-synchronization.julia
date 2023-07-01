function runsim(numworkers, runs)
    for count in 1:runs
        @sync begin
            for worker in 1:numworkers
                @async begin
                    tasktime = rand()
                    sleep(tasktime)
                    println("Worker $worker finished after $tasktime seconds")
                end
            end
        end
        println("Checkpoint reached for run $count.")
    end
    println("Finished all runs.\n")
end

const trials = [[3, 2], [4, 1], [2, 5], [7, 6]]
for trial in trials
    runsim(trial[1], trial[2])
end
