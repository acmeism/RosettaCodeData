throbber <- function(phases){
  repeat{
    for(char in phases){
      cat(char, "\r")
      Sys.sleep(0.25)
    }
  }
}

throbber(c("\\", "|", "/", "-"))
#R supports Unicode characters, so this works also
throbber(c("⬍", "⬈", "➞", "⬊", "⬍", "⬋", "⬅", "⬉"))
#Or even this!
throbber(c("🌑", "🌒", "🌓", "🌔", "🌕", "🌖", "🌗", "🌘"))
