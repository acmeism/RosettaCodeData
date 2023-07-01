knapsack<- function(Value, Weight, Objects, Capacity){
  Fraction = rep(0, length(Value))
  Cost = Value/Weight
  #print(Cost)
  W = Weight[order(Cost, decreasing = TRUE)]
  Obs = Objects[order(Cost, decreasing = TRUE)]
  Val = Value[order(Cost, decreasing = TRUE)]
  #print(W)
  RemainCap = Capacity
  i = 1
  n = length(Cost)
  if (W[1] <= Capacity){
    Fits <- TRUE
  }
  else{
    Fits <- FALSE
  }
  while (Fits && i <= n ){
    Fraction[i] <- 1
    RemainCap <- RemainCap - W[i]
    i <- i+1
    #print(RemainCap)
    if (W[i] <= RemainCap){
      Fits <- TRUE
    }
    else{
      Fits <- FALSE
    }
  }
  #print(RemainCap)
  if (i <= n){
    Fraction[i] <- RemainCap/W[i]
  }
  names(Fraction) = Obs
  Quantity_to_take = W*Fraction
  Total_Value = sum(Val*Fraction)
  print("Fraction of available quantity to take:")
  print(round(Fraction, 3))
  print("KG of each to take:")
  print(Quantity_to_take)
  print("Total value of tasty meats:")
  print(Total_Value)
}
