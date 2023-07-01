const comment_chars = "#;"

fn main() {
   s := [
      "apples, pears # and bananas",
      "apples, pears ; and bananas",
      "no bananas"	
   ]
   for element in s {
      println('source: $element')
      println('stripped: ' + strip_comment(element))
   }
}

fn strip_comment(source string) string {
   if source.index_any(comment_chars) >= 0 {
      return source.substr(0, source.index_any(comment_chars))
   }
   return source
}
