use "assert"
class Accumulator
    var value:(I64|F64)
    new create(v:(I64|F64))=>
        value=v
    fun ref apply(v:(I64|F64)=I64(0)):(I64|F64)=>
        value=match value
        | let x:I64=>match v
            | let y:I64=>x+y
            | let y:F64=>x.f64()+y
            end
        | let x:F64=>match v
            | let y:I64=>x+y.f64()
            | let y:F64=>x+y
            end
        end
        value

actor Main
    new create(env:Env)=>
        var r:Accumulator=Accumulator(I64(0))
        r(I64(5))
        r(I64(2))
        try
        Fact(match r()
            |let x:I64=>x==7
            |let y:F64=>y==7.0
            end)?
        env.out.print("The value I have so far is " + r().string())
        else
            env.out.print("An error of some sort happened!")
        end
        r(F64(5.5))
        env.out.print("This is okay..." + r().string())
