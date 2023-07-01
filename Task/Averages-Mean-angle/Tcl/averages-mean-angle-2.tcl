# A little pretty-printer
proc printMeanAngle {angles} {
    puts [format "mean angle of \[%s\] = %.2f" \
	      [join $angles ", "] [meanAngle $angles]]
}

printMeanAngle {350 10}
printMeanAngle {90 180 270 360}
printMeanAngle {10 20 30}
