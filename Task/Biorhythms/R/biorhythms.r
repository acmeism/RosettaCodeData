bioR <- function(bDay, targetDay) {
    bDay <- as.Date(bDay)
    targetDay <- as.Date(targetDay)
    n <- as.numeric(targetDay - bDay)

    cycles <- c(23, 28, 33)
    mods <- n %% cycles
    bioR <- c(sin(2 * pi * mods / cycles))
    loc <- mods / cycles
    current <- ifelse(bioR > 0, ': Up', ': Down')
    current <- paste(current, ifelse(loc < 0.25 | loc > 0.75,
                                     "and rising",
                                     "and falling"))

    df <- data.frame(dates = seq.Date(from = targetDay - 30,
                                      to = targetDay + 30,
                                      by = 1))
    df$n <- as.numeric(df$dates - bDay)
    df$P <- sin(2 * pi * (df$n %% cycles[1]) / cycles[1])
    df$E <- sin(2 * pi * (df$n %% cycles[2]) / cycles[2])
    df$M <- sin(2 * pi * (df$n %% cycles[3]) / cycles[3])

    plot(df$dates, df$P, col = 'blue',
         main = paste(targetDay, 'Biorhythm for Birthday on', bDay),
         xlab = "",
         ylab = "Intensity")
    points(df$dates, df$E, col = 'green')
    points(df$dates, df$M, col = 'red')
    abline(v = targetDay)
    legend('topleft', legend = c("Phys", "Emot", "Ment"),
           col =c("blue", "green", "red"),
           cex = 0.8,
           pch = 21)

    cat(paste0('Birthday = ', as.character(bDay),
               '\nTarget Date = ', as.character(targetDay),
               '\n', n, ' days',
               '\nPhysical = ', mods[1], current[1],
               '\nEmotional = ', mods[2], current[2],
               '\nMental = ', mods[3], current[3]))
}

bioR('1943-03-09', '1972-07-11')
