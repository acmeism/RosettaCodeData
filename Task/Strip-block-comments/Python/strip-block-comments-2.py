def test():
    print('\nNON-NESTED BLOCK COMMENT EXAMPLE:')
    sample = '''  /**
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
    }'''
    print(commentstripper(sample))

    print('\nNESTED BLOCK COMMENT EXAMPLE:')
    sample = '''  /**
   * Some comments
   * longer comments here that we can parse.
   *
   * Rahoo
   *//*
   function subroutine() {
    a = /* inline comment */ b + c ;
   }
   /*/ <-- tricky comments */
   */
   /**
    * Another comment.
    */
    function something() {
    }'''
    print(commentstripper(sample))

if __name__ == '__main__':
    test()
