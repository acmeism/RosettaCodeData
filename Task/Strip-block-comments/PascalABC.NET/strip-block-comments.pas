begin
  var s := '''
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
  ''';
  Regex.Replace(s,'/\*(\n|\r|\r\n|.)*?\*/','').Print
end.
