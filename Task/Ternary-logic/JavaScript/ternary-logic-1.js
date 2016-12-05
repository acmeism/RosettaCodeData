var L3 = new Object();

L3.not = function(a) {
  if (typeof a == "boolean") return !a;
  if (a == undefined) return undefined;
  throw("Invalid Ternary Expression.");
}

L3.and = function(a, b) {
  if (typeof a == "boolean" && typeof b == "boolean") return a && b;
  if ((a == true && b == undefined) || (a == undefined && b == true)) return undefined;
  if ((a == false && b == undefined) || (a == undefined && b == false)) return false;
  if (a == undefined && b == undefined) return undefined;
  throw("Invalid Ternary Expression.");
}

L3.or = function(a, b) {
  if (typeof a == "boolean" && typeof b == "boolean") return a || b;
  if ((a == true && b == undefined) || (a == undefined && b == true)) return true;
  if ((a == false && b == undefined) || (a == undefined && b == false)) return undefined;
  if (a == undefined && b == undefined) return undefined;
  throw("Invalid Ternary Expression.");
}

// A -> B is equivalent to -A or B
L3.ifThen = function(a, b) {
  return L3.or(L3.not(a), b);
}

// A <=> B is equivalent to (A -> B) and (B -> A)
L3.iff = function(a, b) {
  return L3.and(L3.ifThen(a, b), L3.ifThen(b, a));
}
