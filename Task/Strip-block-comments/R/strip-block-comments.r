test_code <- "/**
   * Some comments
   * longer comments here that we can parse.
   *
   * Rahoo
   */
   function subroutine() {
    a = /* inline comment */ b + c ;
   }
   /*/ <-- tricky comments */

   /**
    * Another comment.
    */
    function something() {
    }"

#Backslashes need to be handled first, then other special regex characters
specialchars <- c("\\","*","^","+",".","!","?","(",")","[","]","{","}","$","|")

strip_comments <- function(s, opener, closer){
  for(char in specialchars){
    opener <- gsub(char, paste0("\\", char), opener, fixed=TRUE)
    closer <- gsub(char, paste0("\\", char), closer, fixed=TRUE)
  }
  regexp <- paste0(opener, ".*?", closer)
  gsub(regexp, "", s)
}

cat(strip_comments(test_code, "/*", "*/"))
