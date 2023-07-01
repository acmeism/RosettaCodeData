/* Note: This code is only for PHP 4.
   It won't work on PHP 5 due to the change in behavior of array_merge(). */
while (array_filter($lst, 'is_array'))
    $lst = call_user_func_array('array_merge', $lst);
