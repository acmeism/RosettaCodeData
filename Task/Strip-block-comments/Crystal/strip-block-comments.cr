def strip_comments (s, start_delim = "/*", end_delim = "*/")
  s.gsub(/#{Regex.escape(start_delim)}.*?#{Regex.escape(end_delim)}/m, "")
end

puts strip_comments <<-EOF
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
EOF
