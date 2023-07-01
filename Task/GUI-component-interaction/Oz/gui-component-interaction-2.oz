declare
  [Roads] = {Module.link ['x-ozlib://wmeyer/roads/Roads.ozf']}

  MaxValue = 1000

  fun {Start Session}
     {Page 0}
  end

  fun {Page Val}
     html(
        body(
           %% numerical input with an HTML form
           local NewVal in
              form(
                 {NumberInput Val NewVal}
                 input(type:submit)
                 method:post
                 action:fun {$ _}
                           {Page NewVal}
                        end
                 )
           end
           %% link with button functionality
           a("Increase"
             href:fun {$ _}
                     {Page Val+1}
                  end)
           "&nbsp;"
           %% another "button-link"
           a("Random"
             href:fun {$ S}
                     p("Reset to random? - "
                       a("Yes" href:fun {$ _}
                                       Rnd = {OS.rand} * MaxValue div {OS.randLimits _}
                                    in
                                       {Page Rnd}
                                    end)
                       " "
                       a("No" href:fun {$ _} {Page Val} end)
                      )
                  end)
           ))
  end

  %% a "formlet", managing input of an integer value
  fun {NumberInput OldVal NewVal}
     input(type:text
           validate:int_in(0 MaxValue)
           value:{Int.toString OldVal}
           bind:proc {$ Str} NewVal = {String.toInt Str.escaped} end
          )
  end
in
  {Roads.registerFunction 'start' Start}
  {Roads.run}
