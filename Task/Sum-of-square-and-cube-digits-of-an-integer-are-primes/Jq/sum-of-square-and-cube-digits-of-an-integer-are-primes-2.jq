range(1;100)
| (.*.) as $sq
|  select( ($sq | digitSum | is_prime) and ($sq * . | digitSum | is_prime ) )
