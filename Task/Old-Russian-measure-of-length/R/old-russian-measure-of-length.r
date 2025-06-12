#Create a vector containing the value of each Russian unit in metres
russian_units <- c(1066.8, 2.1336, 0.7112, 0.04445)
names(russian_units) <- c("verst", "sazhen", "arshin", "vershok")

#Expand this vector to a matrix with one column each for values in km, m, and cm
metric_expand <- function(x){
  return(cbind(x/1000, x, x*100))
}

conv_matrix <- metric_expand(russian_units)
colnames(conv_matrix) <- c("km", "m", "cm")

#This function displays values in all units other than the one that is input
convert_units <- function(value, unit){
  if(unit %in% rownames(conv_matrix)){
    conv_metric <- conv_matrix[unit,]
    conv_russian <- conv_matrix[unit,2]/conv_matrix[-which(rownames(conv_matrix)==unit),2]
  }
  else if(unit %in% colnames(conv_matrix)){
    conv_metric <- conv_matrix[2,-which(colnames(conv_matrix)==unit)]/conv_matrix[2,unit]
    conv_russian <- 1/conv_matrix[,unit]
  }
  return(value*c(conv_metric, conv_russian))
}

#Test inputs
convert_units(1, "m")
convert_units(1, "arshin")
