data: lv_source type string,
      cl_processor type ref to cl_java_script,
      lv_ret type string.

cl_processor = cl_java_script=>create( ).
concatenate
'function acc(sum) { '
'  return function(n) { '
'   return sum += n;'
'  }; '
' }; '
' var x = acc(1); '
' x(5);'
' var ret = acc(3).toString();'
' ret = ret + x(2.3);'
 into lv_source.
lv_ret = cl_processor->evaluate( lv_source ).

if cl_processor->last_condition_code <> cl_java_script=>cc_ok.
  write cl_processor->last_error_message.
else.
  write lv_ret.
  write / 'Done'.
endif.
