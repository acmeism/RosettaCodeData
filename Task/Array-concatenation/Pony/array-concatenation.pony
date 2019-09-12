actor Main
    new create(env:Env)=>
        var a:Array[I32]=Array[I32](4)
        var b:Array[I32]=Array[I32](2)
        a.push(1)
        a.push(2)
        a.push(3)
        a.push(4)
        b.push(5)
        b.push(6)
        a.concat(b.values())
        for i in a.values() do
            env.out.print(i.string())
        end
