open System

let y'(t,y) = t * sqrt(y)

let RungeKutta4 t0 y0 t_max dt =

    let dy1(t,y) = dt * y'(t,y)
    let dy2(t,y) = dt * y'(t+dt/2.0, y+dy1(t,y)/2.0)
    let dy3(t,y) = dt * y'(t+dt/2.0, y+dy2(t,y)/2.0)
    let dy4(t,y) = dt * y'(t+dt, y+dy3(t,y))

    (t0,y0) |> Seq.unfold (fun (t,y) ->
        if ( t <= t_max) then Some((t,y), (Math.Round(t+dt, 6), y + ( dy1(t,y) + 2.0*dy2(t,y) + 2.0*dy3(t,y) + dy4(t,y))/6.0))
        else None
        )

let y_exact t = (pown (pown t 2 + 4.0) 2)/16.0

RungeKutta4 0.0 1.0 10.0 0.1
    |> Seq.filter (fun (t,y) -> t % 1.0 = 0.0 )
    |> Seq.iter (fun (t,y) -> Console.WriteLine("y({0})={1}\t(relative error:{2})", t, y, (y / y_exact(t))-1.0) )
