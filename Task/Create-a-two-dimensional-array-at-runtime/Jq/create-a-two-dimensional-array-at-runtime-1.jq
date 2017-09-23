# A function to create an m x n matrix
# filled with the input element
def matrix(m;n):
  . as $init
  | ( [ range(0; n + 1) ] | map($init)) as $row
  | ( [ range(0; m + 1) ] | map($row))
 ;

# Task: create a matrix with dimensions specified by the user
# and set the [1,2] element:
(0 | matrix($m|tonumber; $n|tonumber)) | setpath([1,2]; 99)
