library(stringr)

text_between <- function(text, start, end){
  regexp <- str_glue("(?<={start}).*?(?={end})")
  if(start=="start"){
    regexp <- str_replace(regexp, fixed("(?<=start)"), "^")
  }
  if((end=="end")|!str_detect(text, end)){
    regexp <- str_replace(regexp, fixed(str_c("(?=", end, ")")), "$")
  }
  str_extract(text, regexp)
}

test_strings <- list(c("Hello Rosetta Code world", "Hello ", " world"),
                     c("Hello Rosetta Code world", "start", " world"),
                     c("Hello Rosetta Code world", "Hello ", "end"),
                     c("Hello Rosetta Code world", "start", "end"),
                     c("</div><div style=\"chinese\">你好嗎</div>",
                       "<div style=\"chinese\">",
                       "</div>"),
                     c("<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">",
                       "<text>",
                       "<table>"),
                     c("<table style=\"myTable\"><tr><td>hello world</td></tr></table>",
                       "<table>",
                       "</table>"),
                     c("The quick brown fox jumps over the lazy other fox", "quick ", " fox"),
                     c("One fish two fish red fish blue fish", "fish ", " red"),
                     c("FooBarBazFooBuxQuux", "Foo", "Foo"))

tb_unary <- function(v) do.call(text_between, as.list(v))
writeLines(sapply(test_strings, tb_unary))
