<!DOCTYPE html><html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="keywords"    content="Game 21">
    <meta name="description" content="
      21 is a two player game, the game is played by choosing a number
      (1, 2, or 3) to be added to the running total. The game is won by
      the player whose chosen number causes the running total to reach
      exactly 21. The running total starts at zero.
    ">
    <!--DCMI metadata (Dublin Core Metadata Initiative)-->
    <meta name="dc.publisher" content="Rosseta Code">
    <meta name="dc.date"      content="2020-07-23">
    <meta name="dc.created"   content="2020-07-23">
    <meta name="dc.modified"  content="2020-07-30">
    <title>
        21 Game
    </title>
    <!-- Remove the line below in the final/production version. -->
    <meta http-equiv="cache-control" content="no-cache">

    <style>
      .ui div   { width: 50%; display: inline-flex; justify-content: flex-end; }
      div.total { margin-bottom: 1ch; }
      label     { padding-right: 1ch; }
      button + button { margin-left: 1em; }
    </style>
</head>

<body>
  <h1>
    21 Game in ECMA Script (Java Script)
  </h1>

  <p>
    21 is a two player game, the game is played by choosing a number
    (1, 2, or 3) to be added to the running total. The game is won by
    the player whose chosen number causes the running total to reach
    exactly 21. The running total starts at zero.
  </p>

  <p><span id="first"></span> Use buttons to play.</p>

  <div class="ui">
    <div class="total">
      <label for="human">human last choice:</label>
      <input type="text" id="human" readonly>
    </div>
    <div class="total">
      <label for="AI">AI last choice:</label>
      <input type="text" id="AI" readonly>
    </div>
    <div class="total">
      <label for="runningTotalText">running total:</label>
      <input type="text" id="runningTotalText" readonly>
    </div>
    <div class="buttons">
      <button onclick="choice(1);" id="choice1"> one   </button>
      <button onclick="choice(2);" id="choice2"> two   </button>
      <button onclick="choice(3);" id="choice3"> three </button>
      <button onclick="restart();"> restart </button>
    </div>
  </div>

  <p id="message"></p>

  <noscript>
    No script, no fun. Turn on Javascript on.
  </noscript>

  <script>
    // I really dislike global variables, but in any (?) WWW browser the global
    // variables are in the window (separately for each tab) context space.
    //
    var runningTotal = 0;
    const human = document.getElementById('human');
    const AI = document.getElementById('AI');
    const runningTotalText = document.getElementById('runningTotalText');
    const first = document.getElementById('first')
    const message = document.getElementById('message');
    const choiceButtons = new Array(3);

    // An function to restart game in any time, should be called as a callback
    // from the WWW page, see above for an example.
    //
    function restart()
    {
      runningTotal = 0;
      runningTotalText.value = runningTotal;
      human.value = '';
      AI.value = '';
      for (let i = 1; i <= 3; i++)
      {
        let button = document.getElementById('choice' + i);
        button.disabled = false;
        choiceButtons[i] = button;
      }
      message.innerText = '';
      if (Math.random() > 0.5)
      {
        update(AI, ai());
        first.innerText = 'The first move is AI move.'
      }
      else
        first.innerText = 'The first move is human move.'
    }

    // This function update an (read-only for a user) two text boxes
    // as well as runningTotal. It should be called only once per a move/turn.
    //
    function update(textBox, n)
    {
      textBox.value = n;
      runningTotal = runningTotal + n;
      runningTotalText.value = runningTotal;
      for (let i = 1; i <= 3; i++)
        if (runningTotal + i > 21)
          choiceButtons[i].disabled = true;
    }

    // An callback function called when the human player click the button.
    //
    function choice(n)
    {
      update(human, n);
      if (runningTotal == 21)
        message.innerText = 'The winner is human.';
      else
      {
        update(AI, ai());
        if (runningTotal == 21)
          message.innerText = 'The winner is AI.';
      }
    }

    // A rather simple function to calculate a computer move for the given total.
    //
    function ai()
    {
      for (let i = 1; i <= 3; i++)
        if (runningTotal + i == 21)
          return i;

      for (let i = 1; i <= 3; i++)
        if ((runningTotal + i - 1) % 4 == 0)
          return i;

      return 1;
    }

    // Run the script - actually this part do only some initialization, because
    // the game is interactively driven by events from an UI written in HTML.
    //
    restart();
  </script>

</body>
</html>
