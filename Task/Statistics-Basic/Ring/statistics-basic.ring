# Project : Statistics/Basic

decimals(9)
sample(100)
sample(1000)
sample(10000)

func sample(n)
       samp = list(n)
       for i =1 to n
           samp[i] =random(9)/10
       next
       sum = 0
       sumSq = 0
       for i = 1 to n
            sum = sum + samp[i]
            sumSq	= sumSq +pow(samp[i],2)
       next
       see n + " Samples used." + nl
       mean = sum / n
       see "Mean    = " + mean + nl
       see "Std Dev = " + pow((sumSq /n -pow(mean,2)),0.5) + nl
       bins2 = 10
       bins = list(bins2)
       for i = 1 to n
            z = floor(bins2 * samp[i])
            if z != 0
               bins[z] = bins[z] +1
            ok
       next
       for b = 1 to bins2
            see b + " " + nl
            for j = 1 to floor(bins2 *bins[b]) /n *70
                see "*"
            next
            see nl
       next
       see nl
