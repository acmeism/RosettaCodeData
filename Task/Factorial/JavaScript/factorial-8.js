<html>

  <body>

    <button onclick="incrementFact()">Factorial</button>
    <p id="FactArray"></p>
    <p id="Factorial"></p>
    <br>

  </body>

</html>

<input id="userInput" value="">
<br>
<button onclick="singleFact()">Single Value Factorial</button>
<p id="SingleFactArray"></p>
<p id="SingleFactorial"></p>


<script>
  function mathFact(total, sum) {
    return total * sum;
  }

  var incNumbers = [1];

  function incrementFact() {
    var n = incNumbers.pop();
    incNumbers.push(n);
    incNumbers.push(n + 1);
    document.getElementById("FactArray").innerHTML = incNumbers;
    document.getElementById("Factorial").innerHTML = incNumbers.reduceRight(mathFact);

  }

  var singleNum = [];

  function singleFact() {
    var x = document.getElementById("userInput").value;
    for (i = 0; i < x; i++) {
      singleNum.push(i + 1);
      document.getElementById("SingleFactArray").innerHTML = singleNum;
    }
    document.getElementById("SingleFactorial").innerHTML = singleNum.reduceRight(mathFact);
    singleNum = [];
  }

</script>
