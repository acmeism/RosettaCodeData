library(rgenoud)

fitness= function(x= rep(1, nrow(task_table))){
  total_value= sum(task_table$value * x)
  total_weight= sum(task_table$weight * x)
  ifelse(total_weight <= 400, total_value, 400-total_weight)
}

allowed= matrix(c(rep(0, nrow(task_table)), task_table$pieces), ncol = 2)
set.seed(42)
evolution= genoud(fn= fitness,
                  nvars= nrow(allowed),
                  max= TRUE,
                  pop.size= 10000,
                  data.type.int= TRUE,
                  Domains= allowed)

cat("Value: ", evolution$value, "\n")
cat("Weight:", sum(task_table$weight * evolution$par), "dag", "\n")
data.frame(item= task_table$items, pieces= as.integer(solution)) %>%
  filter(solution> 0)
