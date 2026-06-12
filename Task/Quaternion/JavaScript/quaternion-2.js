var q = Quaternion(1,2,3,4);
var q1 = Quaternion(2,3,4,5);
var q2 = Quaternion(3,4,5,6);
var r = 7;

console.log("q = "+q);
console.log("q1 = "+q1);
console.log("q2 = "+q2);
console.log("r = "+r);
console.log("1. q.norm() = "+q.norm());
console.log("2. q.negate() = "+q.negate());
console.log("3. q.conjugate() = "+q.conjugate());
console.log("4. q.add(r) = "+q.add(r));
console.log("5. q1.add(q2) = "+q1.add(q2));
console.log("6. q.mul(r) = "+q.mul(r));
console.log("7.a. q1.mul(q2) = "+q1.mul(q2));
console.log("7.b. q2.mul(q1) = "+q2.mul(q1));
console.log("8. q1.mul(q2) " + (q1.mul(q2).equals(q2.mul(q1)) ? "==" : "!=") + " q2.mul(q1)");
