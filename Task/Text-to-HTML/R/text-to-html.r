library(stringr)

example_txt <- "            Sample Text

This is an example of converting plain text to HTML which demonstrates extracting a title and escaping certain characters within bulleted and numbered lists.

* This is a bulleted list with a less than sign (<)

* And this is its second line with a greater than sign (>)

A 'normal' paragraph between the lists.

1. This is a numbered list with an ampersand (&)

2. \"Second line\" in double quotes

3. 'Third line' in single quotes

That's all folks."

txt_to_html <- function(t = example_txt) {
  # Split text into lines and escape HTML characters
  paras <- strsplit(t, "\r?\n")[[1]]
  paras <- sapply(paras, function(p) {
    p <- gsub("&", "&amp;", p)
    p <- gsub("<", "&lt;", p)
    p <- gsub(">", "&gt;", p)
    p <- gsub('"', "&quot;", p)
    p
  })

  # Check if first paragraph is a title (starts with whitespace)
  firstchar <- substr(paras[1], 1, 1)
  title <- "Untitled"
  k <- 1

  if (firstchar == " " || firstchar == "\t") {
    title <- trimws(paras[1])
    k <- 2
  }

  # Print HTML header
  cat("<html>\n")
  cat(sprintf("<head><title>%s</title></head>\n", title))
  cat("<body>\n")

  blist <- FALSE
  nlist <- FALSE

  # Process paragraphs
  for (i in k:length(paras)) {
    para <- paras[i]
    para2 <- trimws(para)

    # Skip empty paragraphs
    if (nchar(para2) == 0) next

    # Check for bulleted list
    if (grepl("^\\*", para2)) {
      if (!blist) {
        blist <- TRUE
        cat("<ul>\n")
      }
      para2 <- trimws(substr(para2, 2, nchar(para2)))
      cat(sprintf("  <li>%s</li>\n", para2))
      next
    } else if (blist) {
      blist <- FALSE
      cat("</ul>\n")
    }

    # Check for numbered list
    if (grepl("^\\d+\\.", para2)) {
      if (!nlist) {
        nlist <- TRUE
        cat("<ol>\n")
      }
      para2 <- trimws(substr(para2, 4, nchar(para2)))
      cat(sprintf("  <li>%s</li>\n", para2))
      next
    } else if (nlist) {
      nlist <- FALSE
      cat("</ol>\n")
    }

    # Regular paragraph
    if (!blist && !nlist) {
      cat(sprintf("<p>%s</p>\n", para2))
    }
  }

  # Close any open lists
  if (blist) {
    cat("</ul>\n")
  }
  if (nlist) {
    cat("</ol>\n")
  }

  cat("</body>\n")
  cat("</html>\n")
}

# Run the function
txt_to_html()
