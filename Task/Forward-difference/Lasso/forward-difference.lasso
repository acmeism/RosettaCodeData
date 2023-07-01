#!/usr/bin/lasso9

define forwardDiff(values, order::integer=1) => {
  !#order ? return #values->asArray
  local(result = array)
  iterate(#values) => {
    loop_count < #values->size ?
      #result->insert(#values->get(loop_count+1) - #values->get(loop_count))
  }
  #order > 1 ? #result = forwardDiff(#result, #order-1)
  return #result
}

local(data = (:90, 47, 58, 29, 22, 32, 55, 5, 55, 73))
with x in generateSeries(0, #data->size-1)
do stdoutnl(#x + ': ' + forwardDiff(#data, #x))
