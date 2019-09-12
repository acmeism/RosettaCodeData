actor Main
    let _env:Env
    new create(env:Env)=>
        _env=env
        env.input(object iso is InputNotify
            let _e:Main=this
            fun ref apply(data:Array[U8] iso)=>
                _e(consume data)
            fun ref dispose()=>
                None
        end,
            512)
    be apply(s:Array[U8] iso)=>
        let c=String.from_iso_array(consume s)
        let parts:Array[String]=c.split(" ",0)
        var sum:I32=0
        try
            for v in parts.values() do
                sum=sum+match v.read_int[I32](0)?
                |(let x:I32,_)=>x
                end
            end
        end
        _env.out.print(sum.string())
