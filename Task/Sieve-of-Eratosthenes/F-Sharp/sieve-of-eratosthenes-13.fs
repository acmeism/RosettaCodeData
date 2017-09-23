  let nmrtr() =
    let i = ref -2
    let rec nxti() = i:=!i + 1;if !i <= int lmtb && not buf.[!i] then nxti() else !i <= int lmtb
    let inline curr() = if !i < 0 then (if !i= -1 then 2u else failwith "Enumeration not started!!!")
                        else let v = uint32 !i in v + v + 3u
    { new System.Collections.Generic.IEnumerator<_> with
        member this.Current = curr()
      interface System.Collections.IEnumerator with
        member this.Current = box (curr())
        member this.MoveNext() = if !i< -1 then i:=!i+1;true else nxti()
        member this.Reset() = failwith "IEnumerator.Reset() not implemented!!!"a
      interface System.IDisposable with
        member this.Dispose() = () }
  { new System.Collections.Generic.IEnumerable<_> with
      member this.GetEnumerator() = nmrtr()
    interface System.Collections.IEnumerable with
      member this.GetEnumerator() = nmrtr() :> System.Collections.IEnumerator }
