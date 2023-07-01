(* Call:  yearsOfSundayXmas(2008, 2121)   *)
fun yearsOfSundayXmas(fromYear, toYear) =
  if fromYear>toYear then
    ()
  else
    let
      val d = Date.date {year=fromYear, month=Date.Dec, day=25,
              hour=0, minute=0, second=0,
                      offset=SOME Time.zeroTime}
      val wd = Date.weekDay d
    in
      if wd=Date.Sun then
        (
          print(Int.toString fromYear ^ "\n");
          yearsOfSundayXmas(fromYear+1, toYear)
        )
      else
        yearsOfSundayXmas(fromYear+1, toYear)
    end;
