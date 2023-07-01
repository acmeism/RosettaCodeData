library(combinat)

col <- factor(c("Red","Green","White","Yellow","Blue"))
own <- factor(c("English","Swedish","Danish","German","Norwegian"))
pet <- factor(c("Dog","Birds","Cats","Horse","Zebra"))
drink <- factor(c("Coffee","Tea","Milk","Beer","Water"))
smoke <- factor(c("PallMall", "Blend", "Dunhill", "BlueMaster", "Prince"))

col_p <- permn(levels(col))
own_p <- permn(levels(own))
pet_p <- permn(levels(pet))
drink_p <- permn(levels(drink))
smoke_p <- permn(levels(smoke))

imright <- function(h1,h2){
  return(h1-h2==1)
}

nextto <- function(h1,h2){
  return(abs(h1-h2)==1)
}

house_with <- function(f,val){
  return(which(levels(f)==val))
}

for (i in seq(length(col_p))){
  col <- factor(col, levels=col_p[[i]])

  if (imright(house_with(col,"Green"),house_with(col,"White"))) {
    for (j in seq(length(own_p))){
      own <- factor(own, levels=own_p[[j]])

      if(house_with(own,"English") == house_with(col,"Red")){
        if(house_with(own,"Norwegian") == 1){
          if(nextto(house_with(own,"Norwegian"),house_with(col,"Blue"))){
            for(k in seq(length(drink_p))){
              drink <- factor(drink, levels=drink_p[[k]])

              if(house_with(drink,"Coffee") == house_with(col,"Green")){
                if(house_with(own,"Danish") == house_with(drink,"Tea")){
                  if(house_with(drink,"Milk") == 3){
                    for(l in seq(length(smoke_p))){
                      smoke <- factor(smoke, levels=smoke_p[[l]])

                      if(house_with(smoke,"Dunhill") == house_with(col,"Yellow")){
                        if(house_with(smoke,"BlueMaster") == house_with(drink,"Beer")){
                          if(house_with(own,"German") == house_with(smoke,"Prince")){
                            if(nextto(house_with(smoke,"Blend"),house_with(drink,"Water"))){
                              for(m in seq(length(pet_p))){
                                pet <- factor(pet, levels=pet_p[[m]])

                                if(house_with(own,"Swedish") == house_with(pet,"Dog")){
                                  if(house_with(smoke,"PallMall") == house_with(pet,"Birds")){
                                    if(nextto(house_with(smoke,"Blend"),house_with(pet,"Cats"))){
                                      if(nextto(house_with(smoke,"Dunhill"),house_with(pet,"Horse"))){
                                        res <- sapply(list(own,col,pet,smoke,drink),levels)
                                        colnames(res) <- c("Nationality","Colour","Pet","Drink","Smoke")
                                        print(res)
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

}
