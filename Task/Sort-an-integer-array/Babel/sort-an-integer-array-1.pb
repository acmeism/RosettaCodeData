babel> nil { zap {1 randlf 100 rem} 20 times collect ! } nest dup lsnum ! --> Create a list of random numbers
( 20 47 69 71 18 10 92 9 56 68 71 92 45 92 12 7 59 55 54 24 )
babel> ls2lf                                                              --> Convert list to array for sorting
babel> dup {fnord} merge_sort                                             --> The internal sort operator
babel> ar2ls lsnum !                                                      --> Display the results
( 7 9 10 12 18 20 24 45 47 54 55 56 59 68 69 71 71 92 92 92 )
