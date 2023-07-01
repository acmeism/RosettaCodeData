cal_j:(_jd[19000101]+!(-/_jd 21010101 19000101)) / enumerate the calendar
is_we:(cal_j!7) _lin 4 5 6                       / identify friday saturdays and sundays
m:__dj[cal_j]%100                                / label the months
mi:&15=+/'is_we[=m]                              / group by month and sum the weekend days
`0:,"There are ",($#mi)," months with five weekends"
m5:(?m)[mi]
`0:$5#m5
`0:,"..."
`0:$-5#m5
y:1900+!201                                     / enumerate the years in the range
y5:?_ m5%100                                    / label the years of the months
yn5:y@&~y _lin y5                               / find any years not in the 5 weekend month list
`0:,"There are ",($#yn5)," years without any five-weekend months"
`0:,1_,/",",/:$yn5
