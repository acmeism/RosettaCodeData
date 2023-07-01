let rnd : int -> int =
  let gen = new System.Random()
  fun max -> gen.Next(max)

// randomly choose an element of a list
let choose (xs:_ list) = xs.[rnd xs.Length]

type Maze(width, height) =
  // (x,y) -> have we been here before?
  let visited = Array2D.create width height false
  // (x,y) -> is there a wall between (x,y) and (x+1,y)?
  let horizWalls = Array2D.create width height true
  // (x,y) -> is there a wall between (x,y) and (x,y+1)?
  let vertWalls = Array2D.create width height  true

  let isLegalPoint (x,y) =
    x >= 0 && x < width && y >= 0 && y < height

  let neighbours (x,y) =
    [(x-1,y);(x+1,y);(x,y-1);(x,y+1)] |> List.filter isLegalPoint

  let removeWallBetween (x1,y1) (x2,y2) =
    if x1 <> x2 then
      horizWalls.[min x1 x2, y1] <- false
    else
      vertWalls.[x1, min y1 y2] <- false

  let rec visit (x,y as p) =
    let rec loop ns =
      let (nx,ny) as n = choose ns
      if not visited.[nx,ny] then
        removeWallBetween p n
        visit n
      match List.filter ((<>) n) ns with
      | [] -> ()
      | others -> loop others

    visited.[x,y] <- true
    loop (neighbours p)

  do visit (rnd width, rnd height)

  member x.Print() =
    ("+" + (String.replicate width "-+")) ::
    [for y in 0..(height-1) do
       yield "\n|"
       for x in 0..(width-1) do
         yield if horizWalls.[x,y] then " |" else "  "
       yield "\n+"
       for x in 0..(width-1) do
         yield if vertWalls.[x,y] then "-+" else " +"
    ]
    |> String.concat ""
    |> printfn "%s"

let m = new Maze(10,10)
m.Print()
