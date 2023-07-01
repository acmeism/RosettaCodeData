actor Toggler
    let doors:Array[Bool]
    let env: Env
    new create(count:USize,_env:Env) =>
        var i:USize=0
        doors=Array[Bool](count)
        env=_env
        while doors.size() < count do
            doors.push(false)
        end
    be togglin(interval : USize)=>
        var i:USize=0
        try
            while i < doors.size() do
                doors.update(i,not doors(i)?)?
                i=i+interval
            end
        else
            env.out.print("Errored while togglin'!")
        end
    be printn(onlyOpen:Bool)=>
        try
            for i in doors.keys() do
                if onlyOpen and not doors(i)? then
                    continue
                end
                env.out.print("Door " + i.string() + " is " +
                    if doors(i)? then
                        "Open"
                    else
                        "closed"
                    end)
            end
        else
            env.out.print("Error!")
        end
        true

actor OptimizedToggler
    let doors:Array[Bool]
    let env:Env
    new create(count:USize,_env:Env)=>
        env=_env
        doors=Array[Bool](count)
        while doors.size()<count do
            doors.push(false)
        end
    be togglin()=>
        var i:USize=0
        if alreadydone then
            return
        end
        try
            doors.update(0,true)?
            doors.update(1,true)?
            while i < doors.size() do
                i=i+1
                let z=i*i
                let x=z*z
                if z > doors.size() then
                    break
                else
                    doors.update(z,true)?
                end
                if x < doors.size() then
                    doors.update(x,true)?
                end
            end
        end
    be printn(onlyOpen:Bool)=>
        try
            for i in doors.keys() do
                if onlyOpen and not doors(i)? then
                    continue
                end
                env.out.print("Door " + i.string() + " is " +
                    if doors(i)? then
                        "Open"
                    else
                        "closed"
                    end)
            end
        else
            env.out.print("Error!")
        end
        true
actor Main
    new create(env:Env)=>
        var count: USize =100
        try
            let index=env.args.find("-n",0,0,{(l,r)=>l==r})?
            try
            match env.args(index+1)?.read_int[USize]()?
                | (let x:USize, _)=>count=x
                end
            else
                env.out.print("You either neglected to provide an argument after -n or that argument was not an integer greater than zero.")
                return
            end
        end
        if env.args.contains("optimized",{(l,r)=>r==l}) then
            let toggler=OptimizedToggler(count,env)
            var i:USize = 1
            toggler.togglin()
            toggler.printn(env.args.contains("onlyopen", {(l,r)=>l==r}))
        else
            let toggler=Toggler(count,env)
            var i:USize = 1
            while i < count do
                toggler.togglin(i)
                i=i+1
            end
            toggler.printn(env.args.contains("onlyopen", {(l,r)=>l==r}))
        end
