numbers <- c(0, 2, 11, 19, 28, 90)

two_sum <- function(numbers, s){
  all_sums <- outer(numbers, numbers, "+")==s
  all_sums[lower.tri(all_sums)] <- NA
  which(all_sums, arr.ind = TRUE)
  #first index is in the "row" column, and second index is in the "col" column
}

#In R, indices start at 1
two_sum(numbers, 21) #should return 2 4

two_sum(numbers, 24) #should return nothing

two_sum(numbers, 30) #should return 3 4 and 2 5
