mydata <- read.table( file("stdin"), header=TRUE, sep=",")

x = mydata$A                        # x-axis
y = mydata$B                        # y-axis
plot(x, y,                          # plot the variables
   main="Scatterplot Example",
   xlab="x-axis label",             # x-axis label
   ylab="y-axis label" )            # y-axis label
