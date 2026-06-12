    printf "\rCPU: %5.1f%%  \b\b",(1-(idle-prev_idle)/(total-prev_total))*100
