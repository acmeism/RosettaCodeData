procedure echo(sequence s)
    puts(1,s)
    puts(1,'\n')
end procedure

atom task1,task2,task3

task1 = task_create(routine_id("echo"),{"Enjoy"})
task_schedule(task1,1)

task2 = task_create(routine_id("echo"),{"Rosetta"})
task_schedule(task2,1)

task3 = task_create(routine_id("echo"),{"Code"})
task_schedule(task3,1)

task_yield()
