// Extend your language. Nigel Galloway: September 14th., 2021
type elsetf=TF
type elseft=FT
type elseff=FF
let elsetf,elseft,elseff=TF,FT,FF
let if2 n g tt (TF:elsetf)tf (FT:elseft)ft (FF:elseff)ff=match(n,g) with (true,true)->tt() |(true,false)->tf() |(false,true)->ft() |_->ff()
if2 (13<23) (23<42) (fun()->printfn "tt")
  elsetf (fun()->printfn "tf")
  elseft (fun()->printfn "ft")
  elseff (fun()->printfn "ff")
if2 (13<23) (42<23) (fun()->printfn "tt")
  elsetf (fun()->printfn "tf")
  elseft (fun()->printfn "ft")
  elseff (fun()->printfn "ff")
if2 (23<23) (23<42) (fun()->printfn "tt")
  elsetf (fun()->printfn "tf")
  elseft (fun()->printfn "ft")
  elseff (fun()->printfn "ff")
if2 (23<13) (42<23) (fun()->printfn "tt")
  elsetf (fun()->printfn "tf")
  elseft (fun()->printfn "ft")
  elseff (fun()->printfn "ff")
