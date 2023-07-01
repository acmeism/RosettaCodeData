fun a r = ( print " > function a called\n"; r )
fun b r = ( print " > function b called\n"; r )

fun test_and b1 b2 = (
  print ("# testing (" ^ Bool.toString b1 ^ " andalso " ^ Bool.toString b2 ^ ")\n");
  ignore (a b1 andalso b b2) )

fun test_or b1 b2 = (
  print ("# testing (" ^ Bool.toString b1 ^ " orelse " ^ Bool.toString b2 ^ ")\n");
  ignore (a b1 orelse b b2) )

fun test_this test = (
  test true true;
  test true false;
  test false true;
  test false false )
;

print "==== Testing and ====\n";
test_this test_and;
print "==== Testing or ====\n";
test_this test_or;
