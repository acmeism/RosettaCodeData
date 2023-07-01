actor Main
    new create(env:Env)=>
        var c=Array[String](2)
        c.push("apple")
        c.push("orange")
        env.out.print("Array c is " + c.size().string() + " elements long!")
