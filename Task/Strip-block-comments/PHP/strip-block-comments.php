function strip_block_comments( $test_string ) {
	$pattern = "/^.*?(\K\/\*.*?\*\/)|^.*?(\K\/\*.*?^.*\*\/)$/mXus";
	return preg_replace( $pattern, '', $test_string );
}

echo "Result: '" . strip_block_comments( "
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
" ) . "'";
