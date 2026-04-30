compressLZW <- function(decompressed) {
    dictsize <- 256
    # Create dictionary with characters 0-255
    dict <- list()
    for (i in 0:255) {
        dict[[intToUtf8(i)]] <- i
    }

    result <- c()
    w <- ""

    # Split string into characters
    chars <- strsplit(decompressed, "")[[1]]

    for (c in chars) {
        wc <- paste0(w, c)
        if (!is.null(dict[[wc]])) {
            w <- wc
        } else {
            result <- c(result, dict[[w]])
            dict[[wc]] <- dictsize
            dictsize <- dictsize + 1
            w <- c
        }
    }

    if (w != "") {
        result <- c(result, dict[[w]])
    }

    return(result)
}

decompressLZW <- function(compressed) {
    dictsize <- 256
    # Create reverse dictionary with integers 0-255 mapping to characters
    dict <- list()
    for (i in 0:255) {
        dict[[as.character(i)]] <- intToUtf8(i)
    }

    result <- ""
    w <- intToUtf8(compressed[1])
    result <- paste0(result, w)

    if (length(compressed) > 1) {
        for (i in 2:length(compressed)) {
            k <- compressed[i]

            if (!is.null(dict[[as.character(k)]])) {
                entry <- dict[[as.character(k)]]
            } else if (k == dictsize) {
                entry <- paste0(w, substr(w, 1, 1))
            } else {
                stop(paste("bad compressed k:", k))
            }

            result <- paste0(result, entry)
            dict[[as.character(dictsize)]] <- paste0(w, substr(entry, 1, 1))
            dictsize <- dictsize + 1
            w <- entry
        }
    }

    return(result)
}

# Test the functions
original <- c("0123456789", "TOBEORNOTTOBEORTOBEORNOT", "dudidudidudida")
compressed <- lapply(original, compressLZW)
decompressed <- lapply(compressed, decompressLZW)

# Print results
for (i in 1:length(original)) {
    word <- original[i]
    comp <- compressed[[i]]
    decomp <- decompressed[[i]]

    comprate <- (nchar(word) - length(comp)) / nchar(word) * 100

    cat("Original:", word, "\n")
    cat("-> Compressed:", paste(comp, collapse=" "),
        sprintf("(compr.rate: %.2f%%)", comprate), "\n")
    cat("-> Decompressed:", decomp, "\n\n")
}
