<html>

  <body>

    <input id="userInputMH" value="1000">
    <input id="userInputDoor" value="3">
    <br>
    <button onclick="montyhall()">Calculate</button>
    <p id="firstPickWins"></p>
    <p id="switchPickWins"></p>

  </body>

</html>


<script>
  function montyhall() {
    var tests = document.getElementById("userInputMH").value;
    var doors =  document.getElementById("userInputDoor").value;
    var prizeDoor, chosenDoor, shownDoor, switchDoor, chosenWins = 0,switchWins = 0;

    function pick(excludeA, excludeB) {
      var door;
      do {
        door = Math.floor(Math.random() * doors);
      } while (door === excludeA || door === excludeB);
      return door;
    }


    for (var i = 0; i < tests; i++) {

      prizeDoor = pick();
      chosenDoor = pick();
      shownDoor = pick(prizeDoor, chosenDoor);
      switchDoor = pick(chosenDoor, shownDoor);

      if (chosenDoor === prizeDoor) {
        chosenWins++;
      } else if (switchDoor === prizeDoor) {
        switchWins++;
      }
    }
    document.getElementById("firstPickWins").innerHTML = 'First Door Wins: ' + chosenWins + ' | ' + (100 * chosenWins / tests) + '%';
    document.getElementById("switchPickWins").innerHTML = 'Switched Door Wins: ' + switchWins + ' | ' + (100 * switchWins / tests) + '%';
  }

</script>
