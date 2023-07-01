console.log("Supplied examples");
var tests = ["", "[]", "][", "[][]", "][][", "[[][]]", "[]][[]"];
for (var test of tests)
{
  console.log("The string '" + test + "' is " +
      (isStringBalanced(test) ? "" : "not ") + "OK.");
}
console.log();
console.log("Random generated examples");
for (var example = 1; example <= 10; example++)
{
  var test = generate(Math.floor(Math.random() * 10) + 1);
  console.log("The string '" + test + "' is " +
      (isStringBalanced(test) ? "" : "not ") + "OK.");
}

function isStringBalanced(str)
{
  var paired = 0;
  for (var i = 0; i < str.length && paired >= 0; i++)
  {
    var c = str[i];
    if (c == '[')
      paired++;
    else if (c == ']')
      paired--;
  }
  return (paired == 0);
}

function generate(n)
{
  var opensCount = 0, closesCount = 0;
  // Choose at random until n of one type generated
  var generated = "";
  while (opensCount < n && closesCount < n)
  {
    switch (Math.floor(Math.random() * 2) + 1)
    {
      case 1:
        opensCount++;
        generated += "[";
        break;
      case 2:
        closesCount++;
        generated += "]";
        break;
      default:
        break;
    }
  }
  // Now pad with the remaining other brackets
  generated +=
      opensCount == n ? "]".repeat(n - closesCount) : "[".repeat(n - opensCount);
  return generated;
}
