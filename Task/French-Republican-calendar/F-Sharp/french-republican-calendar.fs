// French Republican Calander: Nigel Galloway. April 16th., 2021
let firstDay=System.DateTime.Parse("22/9/1792")
type monthsFRC= Vendemiaire =   0
               |Brumaire    =  30
               |Frimaire    =  60
               |Nivose      =  90
               |Pluviose    = 120
               |Ventose     = 150
               |Germinal    = 180
               |Floral      = 210
               |Prairial    = 240
               |Messidor    = 270
               |Thermidor   = 300
               |Fructidor   = 330
               |Virtue      = 360
               |Talent      = 361
               |Labour      = 362
               |Opinion     = 363
               |Honours     = 364
               |Revolution  = 365
type months= January    =  1
            |February   =  2
            |March      =  3
            |April      =  4
            |May        =  5
            |June       =  6
            |July       =  7
            |August     =  8
            |September  =  9
            |October    = 10
            |November   = 11
            |December   = 12
let frc2Greg n (g:monthsFRC) l=firstDay+System.TimeSpan.FromDays(float((l-1)*365+l/4+(int g)+n-1))
let rec fG n g=let i=match g with 3 |7 |11->366 |_->365 in if n<i then (n,g) else fG(n-i)(g+1)
let Greg2FRC n=let n,g=fG((n-firstDay).Days) 1
               match n/30,n%30 with (12,n)->(1,enum<monthsFRC>(360+n),g) |(n,l)->(l+1,enum<monthsFRC>(n*30),g)
let n=(frc2Greg 1 monthsFRC.Vendemiaire 1) in printfn "%d %s %d -> %d %A %d" 1 "Vendemiaire" 1 n.Day (enum<months> n.Month) n.Year
let n=(frc2Greg 27 monthsFRC.Messidor 7) in printfn "%d %s %d -> %d %A %d" 27 "Messidor" 7 n.Day (enum<months> n.Month) n.Year
let n=(frc2Greg 1 monthsFRC.Revolution 11) in printfn "%d %s %d -> %d %A %d" 1 "Revolution" 11 n.Day (enum<months> n.Month) n.Year
let n=(frc2Greg 10 monthsFRC.Nivose 14) in printfn "%d %s %d -> %d %A %d" 10 "Nivose" 14 n.Day (enum<months> n.Month) n.Year
let n,g,l=Greg2FRC(System.DateTime(1792,9,22)) in printfn "%d %s %d -> %d %A %d" 22 "September" 1792 n g l
let n,g,l=Greg2FRC(System.DateTime(1799,7,15)) in printfn "%d %s %d -> %d %A %d" 15 "July" 1799 n g l
let n,g,l=Greg2FRC(System.DateTime(1803,9,23)) in printfn "%d %s %d -> %d %A %d" 23 "September" 1803 n g l
let n,g,l=Greg2FRC(System.DateTime(1805,12,31)) in printfn "%d %s %d -> %d %A %d" 31 "December" 1805 n g l
