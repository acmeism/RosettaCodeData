//Fill a knapsack optimally - Nigel Galloway: February 1st., 2015
let items = [("beef", 3.8, 36);("pork", 5.4, 43);("ham", 3.6, 90);("greaves", 2.4, 45);("flitch" , 4.0, 30);("brawn", 2.5, 56);("welt", 3.7, 67);("salami" , 3.0, 95);("sausage", 5.9, 98)]
            |> List.sortBy(fun(_,weight,value) -> float(-value)/weight)


let knap items maxW=
  let rec take(n,g,a) =
    match g with
      | i::e -> let name, weight, value = i
                let total = n + weight
                if total <= maxW then
                  printfn "Take all %s" name
                  take(total, e, a+float(value))
                else
                  printfn "Take %0.2f kg of %s\nTotal value of swag is %0.2f" (maxW - n) name (a + (float(value)/weight)*(maxW - n))
      | []   -> printfn "Everything taken! Total value of swag is £%0.2f; Total weight of bag is %0.2fkg" a n
  take(0.0, items, 0.0)
