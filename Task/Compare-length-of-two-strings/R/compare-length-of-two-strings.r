length_of_strings <- function(list_of_strings){
 string_size = nchar(list_of_strings)
 string_order = order(string_size,decreasing = T)

 for (k in string_order){
  cat("\n")
  cat(paste0("string : ", list_of_strings[k]," | length : ", string_size[k] , " character(s)"))
 }
}

list_of_strings = c("abcd","123456789","abcdef","1234567")

length_of_strings(list_of_strings)
