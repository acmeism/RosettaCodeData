declare
  proc {Stupid X}
     choice
        X = 8
        {System.showInfo "choosing 8"}
     [] X = 9
        {System.showInfo "choosing 9"}
     [] X = 10
        {System.showInfo "choosing 10"}
     end

     2 * X = 18
  end
in
  {Show {SearchOne Stupid}}
