using Base.Collections

test = ["Clear drains" 3;
        "Feed cat" 4;
        "Make tea" 5;
        "Solve RC tasks" 1;
        "Tax return" 2]

task = PriorityQueue(Base.Order.Reverse)
for i in 1:size(test)[1]
    enqueue!(task, test[i,1], test[i,2])
end

println("Tasks, completed according to priority:")
while !isempty(task)
    (t, p) = peek(task)
    dequeue!(task)
    println("    \"", t, "\" has priority ", p)
end
