// version 1.1.4-3

val sample = """
/**
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
    }
"""

val sample2 = """
``{
   ` Some comments
   ` longer comments here that we can parse.
   `
   ` Rahoo
   ``}
   function subroutine2() {
    d = ``{ inline comment ``} e + f ;
   }
   ``{ / <-- tricky comments ``}

   ``{
    ` Another comment.
    ``}
    function something2() {
    }
"""

fun stripBlockComments(text: String, del1: String = "/*", del2: String = "*/"): String {
    val d1 = Regex.escape(del1)
    val d2 = Regex.escape(del2)
    val r = Regex("""(?s)$d1.*?$d2""")
    return text.replace(r, "")
}

fun main(args: Array<String>) {
    println(stripBlockComments(sample))
    println(stripBlockComments(sample2, "``{", "``}"))
}
