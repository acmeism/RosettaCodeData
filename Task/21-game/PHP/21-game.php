<!DOCTYPE html>
<html lang="en">

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
    <meta name="dc.date"      content="2020-07-31">
    <meta name="dc.created"   content="2020-07-31">
    <meta name="dc.modified"  content="2020-08-01">
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
    21 Game in PHP 7
  </h1>

  <p>
    21 is a two player game, the game is played by choosing a number
    (1, 2, or 3) to be added to the running total. The game is won by
    the player whose chosen number causes the running total to reach
    exactly 21. The running total starts at zero.
  </p>


  <?php

    const GOAL = 21;
    const PLAYERS = array('AI', 'human');

    function best_move($n)
    {
      for ($i = 1; $i <= 3; $i++)
        if ($n + $i == GOAL)
          return $i;
      for ($i = 1; $i <= 3; $i++)
        if (($n + $i - 1) % 4 == 0)
          return $i;
      return 1;
    }

    if (isset($_GET['reset']) || !isset($_GET['total']))
    {
      $first = PLAYERS[rand(0, 1)];
      $total = 0;
      $human = 0;
      $ai = 0;
      $message = '';
      if ($first == 'AI')
      {
        $move = best_move($total);
        $ai = $move;
        $total = $total + $move;
      }
    }
    else
    {
      $first   = $_GET['first'];
      $total   = $_GET['total'];
      $human   = $_GET['human'];
      $ai      = $_GET['ai'];
      $message = $_GET['message'];
    }

    if (isset($_GET['move']))
    {
      $move = (int)$_GET['move'];
      $human = $move;
      $total = $total + $move;
      if ($total == GOAL)
        $message = 'The winner is human.';
      else
      {
        $move = best_move($total);
        $ai = $move;
        $total = $total + $move;
        if ($total == GOAL)
          $message = 'The winner is AI.';
      }
    }

    $state = array();
    for ($i = 1; $i <= 3; $i++)
      $state[$i] = $total + $i > GOAL ? 'disabled' : '';

    echo <<< END
      <p>
        The first player is $first.
        Use buttons to play.
      </p>
      <form class="ui">
        <div>
          <input type='hidden' id='first' name='first' value='$first'>
          <input type='hidden' name='message' value='$message'>
        </div>
        <div class='total'>
          <label for='human'>human last choice:</label>
          <input type='text' name='human' readonly value='$human'>
        </div>
        <div class='total'>
          <label for='AI'>AI last choice:</label>
          <input type='text' name='ai' readonly value='$ai'>
        </div>
        <div class='total'>
          <label for='runningTotalText'>running total:</label>
          <input type='text' name='total' readonly value='$total'>
        </div>
        <div class='buttons'>
          <button type='submit' name='move' value='1' {$state[1]}> one   </button>
          <button type='submit' name='move' value='2' {$state[2]}> two   </button>
          <button type='submit' name='move' value='3' {$state[3]}> three </button>
          <button type='submit' name='reset' value='reset'> reset </button>
        </div>
      </form>
      <p>
        $message
      </p>
    END
  ?>

</body>
