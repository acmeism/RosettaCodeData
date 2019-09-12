report z_integer_comparison.

parameters: a type int4, b type int4.

data(comparison_result) = cond string(
  when a < b " can be replaced by a lt b
  then |{ a } is less than { b }|
  when a = b " can be replaced by a eq b
  then |{ a } is equal to { b }|
  when a > b " can be replaced by a gt b
  then |{ a } is greater than { b }| ).

write comparison_result.
