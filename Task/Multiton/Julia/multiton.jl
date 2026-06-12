struct Multiton{T}
    data::T
    function Multiton(registry, refnum, data)
        lock(registry.spinlock)
        if 0 < refnum <= registry.max_instances && registry.instances[refnum] isa Nothing
            multiton = new{typeof(data)}(data)
            registry.instances[refnum] = multiton
            unlock(registry.spinlock)
            return multiton
        else
            unlock(registry.spinlock)
            error("Cannot create instance with instance reference number $refnum")
        end
    end
    function Multiton(registry, refnum)
        if 0 < refnum <= registry.max_instances && registry.instances[refnum] isa Multiton
            return registry.instances[refnum]
        else
            error("Cannot find a Multiton in registry with instance reference number $refnum")
        end
    end
end

struct Registry
        spinlock::Threads.SpinLock
        max_instances::Int
        instances::Vector{Union{Nothing, Multiton}}
        Registry(maxnum) = new(Threads.SpinLock(), maxnum, fill(nothing, maxnum))
end

reg = Registry(3)
m0 = Multiton(reg, 1, "zero")
m1 = Multiton(reg, 2, 1.0)
m2 = Multiton(reg, 3, [2])
m3 = Multiton(reg, 1)
m4 = Multiton(reg, 2)


for m in [m0, m1, m2, m3, m4]
   println("Multiton is $m")
end

# produce error
# m3 = Multiton(reg, 4, "three")

# produce error
m5 = Multiton(reg, 5)
