var stripper = Fn.new { |start, end|
    if (start == "" || end == "") {
        start = "/*"
        end   = "*/"
    }
    return Fn.new { |source|
        while (true) {
            var cs = source.indexOf(start)
            if (cs == -1) break
            var ce = source[cs+2..-1].indexOf(end)
            if (ce == -1) break
            source = source[0...cs] + source[cs+ce+4..-1]
        }
        return source
    }
}

var source = "/**
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

var stripC = stripper.call("", "")
System.print(stripC.call(source))
