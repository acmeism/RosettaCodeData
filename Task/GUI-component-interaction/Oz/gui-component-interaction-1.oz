declare
  [QTk] = {Module.link ['x-oz://system/wp/QTk.ozf']}

  proc {Main}
     MaxValue = 1000
     NumberWidget
     GUI = lr(
              numberentry(init:1 min:0 max:MaxValue handle:NumberWidget)
              button(text:"Increase"
                     action:proc {$}
                               OldVal = {NumberWidget get($)}
                            in
                               {NumberWidget set(OldVal+1)}
                            end)
              button(text:"Random"
                     action:proc {$}
                               if {Ask "Reset to random?"} then
                                  Rnd = {OS.rand} * MaxValue div {OS.randLimits _}
                               in
                                  {NumberWidget set(Rnd)}
                               end
                            end)
              )
     Window = {QTk.build GUI}
  in
     {Window show}
  end

  fun {Ask Msg}
     Result
     Box = {QTk.build
            td(message(init:Msg)
               lr(button(text:"Yes" action:proc {$} Result=true  {Box close} end)
                  button(text:"No"  action:proc {$} Result=false {Box close} end)
                 ))}
  in
     {Box show}
     {Box wait}
     Result
  end
in
  {Main}
