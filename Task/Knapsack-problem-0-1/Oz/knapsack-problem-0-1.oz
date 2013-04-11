declare
  %% maps items to pairs of Weight(hectogram) and Value
  Problem = knapsack('map':9#150
                     'compass':13#35
                     'water':153#200
                     'sandwich':50#160
                     'glucose':15#60
                     'tin':68#45
                     'banana':27#60
                     'apple':39#40
                     'cheese':23#30
                     'beer':52#10
                     'suntan cream':11#70
                     'camera':32#30
                     't-shirt':24#15
                     'trousers':48#10
                     'umbrella':73#40
                     'waterproof trousers':42#70
                     'waterproof overclothes':43#75
                     'note-case':22#80
                     'sunglasses':7#20
                     'towel':18#12
                     'socks':4#50
                     'book':30#10
                    )

  %% item -> Weight
  Weights = {Record.map Problem fun {$ X} X.1 end}
  %% item -> Value
  Values =  {Record.map Problem fun {$ X} X.2 end}

  proc {Knapsack Solution}
     %% a solution maps items to finite domain variables
     %% with the domain {0,1}
     Solution = {Record.map Problem fun {$ _} {FD.int 0#1} end}
     %% no more than 400 hectograms
     {FD.sumC Weights Solution '=<:' 400}
     %% search through valid solutions
     {FD.distribute naive Solution}
  end

  proc {PropagateLargerValue Old New}
     %% propagate that new solutions must yield a higher value
     %% than previously found solutions (essential for performance)
     {FD.sumC Values New '>:' {Value Old}}
  end

  fun {Value Candidate}
     {Record.foldL {Record.zip Candidate Values Number.'*'} Number.'+' 0}
  end

  fun {Weight Candidate}
     {Record.foldL {Record.zip Candidate Weights Number.'*'} Number.'+' 0}
  end

  [Best] = {SearchBest Knapsack PropagateLargerValue}
in
  {System.showInfo "Items: "}
  {ForAll
     {Record.arity {Record.filter Best fun {$ T} T == 1 end}}
     System.showInfo}
  {System.printInfo "\n"}
  {System.showInfo "total value: "#{Value Best}}
  {System.showInfo "total weight: "#{Weight Best}}
