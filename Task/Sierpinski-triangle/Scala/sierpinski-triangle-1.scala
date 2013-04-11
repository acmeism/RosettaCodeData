scala -e "for(y<-0 to 15){println(\" \"*(15-y)++(0 to y).map(x=>if((~y&x)>0)\"  \"else\" *\")mkString)}"
