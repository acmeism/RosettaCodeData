<?php
function is_palindrome($string) {
  return preg_match('/^(?:(.)(?=.*(\1(?(2)\2|))$))*.?\2?$/', $string);
}
?>
