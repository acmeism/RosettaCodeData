mutable struct Philosopher
    name::String
    hungry::Bool
    righthanded::Bool
    rightforkheld::Channel
    leftforkheld::Channel
    function Philosopher(name, leftfork, rightfork)
        this = new()
        this.name = name
        this.hungry = rand([false, true]) # not specified so start as either
        this.righthanded   = (name == "Aristotle") ? false : true
        this.leftforkheld  = leftfork
        this.rightforkheld = rightfork
        this
    end
end

mutable struct FiveForkTable
    fork51::Channel
    fork12::Channel
    fork23::Channel
    fork34::Channel
    fork45::Channel
    function FiveForkTable()
        this = new()
        this.fork51 = Channel(1); put!(this.fork51, "fork") # start with one fork per channel
        this.fork12 = Channel(1); put!(this.fork12, "fork")
        this.fork23 = Channel(1); put!(this.fork23, "fork")
        this.fork34 = Channel(1); put!(this.fork34, "fork")
        this.fork45 = Channel(1); put!(this.fork45, "fork")
        this
    end
end


table = FiveForkTable();
tasks = [Philosopher("Aristotle", table.fork12, table.fork51),
         Philosopher("Kant", table.fork23, table.fork12),
         Philosopher("Spinoza", table.fork34, table.fork23),
         Philosopher("Marx", table.fork45, table.fork34),
         Philosopher("Russell", table.fork51, table.fork45)]

function dine(t,p)
    if p.righthanded
       take!(p.rightforkheld); println("$(p.name) takes right fork")
       take!(p.leftforkheld); println("$(p.name) takes left fork")
    else
       take!(p.leftforkheld); println("$(p.name) takes left fork")
       take!(p.rightforkheld); println("$(p.name) takes right fork")
    end
end

function leavetothink(t, p)
    put!(p.rightforkheld, "fork"); println("$(p.name) puts down right fork")
    put!(p.leftforkheld, "fork");  println("$(p.name) puts down left fork")
end

contemplate(t) = sleep(t)

function dophil(p, t, fullaftersecs=2.0, hungryaftersecs=10.0)
    while true
        if p.hungry
            println("$(p.name) is hungry")
            dine(table, p)
            sleep(fullaftersecs)
            p.hungry = false
            leavetothink(t, p)
        else
            println("$(p.name) is out of the dining room for now.")
            contemplate(hungryaftersecs)
            p.hungry = true
        end
    end
end

function runall(tasklist)
    for p in tasklist
        @async dophil(p, table)
    end
    while true begin sleep(5) end end
end

runall(tasks)
