<?php
// Puzzle 15 Game - Rosseta Code - PHP 7 as the server-side script language.

// This program DOES NOT use cookies.

session_start([
  "use_only_cookies" => 0,
  "use_cookies" => 0,
  "use_trans_sid" => 1,
]);

class Location
{
  protected $column, $row;

  function __construct($column, $row){
    $this->column = $column;
    $this->row = $row;
  }
  function create_neighbor($direction){
    $dx = 0; $dy = 0;
    switch ($direction){
      case 0: case 'left':  $dx = -1; break;
      case 1: case 'right': $dx = +1; break;
      case 2: case 'up':    $dy = -1; break;
      case 3: case 'down':  $dy = +1; break;
    }
    return new Location($this->column + $dx, $this->row + $dy);
  }
  function equals($that){
    return $this->column == $that->column && $this->row == $that->row;
  }
  function is_inside_rectangle($left, $top, $right, $bottom){
    return $left <= $this->column && $this->column <= $right
        && $top <= $this->row && $this->row <= $bottom;
  }
  function is_nearest_neighbor($that){
    $s = abs($this->column - $that->column) + abs($this->row - $that->row);
    return $s == 1;
  }
}

class Tile
{
  protected $index;
  protected $content;
  protected $target_location;
  protected $current_location;

  function __construct($index, $content, $row, $column){
    $this->index = $index;
    $this->content = $content;
    $this->target_location = new Location($row, $column);
    $this->current_location = $this->target_location;
  }
  function get_content(){
    return $this->content;
  }
  function get_index(){
    return $this->index;
  }
  function get_location(){
    return $this->current_location;
  }
  function is_completed(){
    return $this->current_location->equals($this->target_location);
  }
  function is_empty(){
    return $this->content == NULL;
  }
  function is_nearest_neighbor($that){
    $a = $this->current_location;
    $b = $that->current_location;
    return $a->is_nearest_neighbor($b);
  }
  function swap_locations($that){
    $a = $this->current_location;
    $b = $that->current_location;
    $this->current_location = $b;
    $that->current_location = $a;
  }
}

class Model
{
  protected $N;
  protected $M;
  protected $tiles;

  function __construct($N, $M){
    $this->N = $N;
    $this->M = $M;
    $this->tiles[0] = new Tile(0, NULL, $N, $M);
    for ($k = 1; $k < $N * $M; $k++ ){
      $i = 1 + intdiv($k - 1, $M);
      $j = 1 + ($k - 1) % $M;
      $this->tiles[$k] = new Tile($k, (string)$k, $i, $j);
    }
    $number_of_shuffles = 1000;
    $i = 0;
    while ($i < $number_of_shuffles)
      if ($this->move_in_direction(random_int(0, 3)))
        $i++;
  }
  function get_N(){
    return $this->N;
  }
  function get_M(){
    return $this->M;
  }
  function get_tile_by_index($index){
    return $this->tiles[$index];
  }
  function get_tile_at_location($location){
    foreach($this->tiles as $tile)
      if ($location->equals($tile->get_location()))
        return $tile;
    return NULL;
  }
  function is_completed(){
    foreach($this->tiles as $tile)
      if (!$tile->is_completed())
        return FALSE;
    return TRUE;
  }
  function move($tile){
    if ($tile != NULL)
      foreach($this->tiles as $target){
        if ($target->is_empty() && $target->is_nearest_neighbor($tile)){
          $tile->swap_locations($target);
          break;
        }
      }
  }
  function move_in_direction($direction){
    foreach($this->tiles as $tile)
      if ($tile->is_empty())
        break;
    $location = $tile->get_location()->create_neighbor($direction);
    if ($location->is_inside_rectangle(0, 0, $this->M, $this->N)){
      $tile = $this->get_tile_at_location($location);
      $this->move($tile);
      return TRUE;
    }
    return FALSE;
  }
}

class View
{
  protected $model;

  function __construct($model){
      $this->model = $model;
  }
  function show(){
    $N = $this->model->get_N();
    $M = $this->model->get_M();
    echo "<form>";
    for ($i = 1; $i <= $N; $i++){
      for ($j = 1; $j <= $M; $j++){
        $tile = $this->model->get_tile_at_location(new Location($i, $j));
        $content = $tile->get_content();
        if ($content != NULL)
          echo "<span class='puzzle'>"
          .    "<input type='submit' class='puzzle' name='index'"
          .    "value='$content'>"
          .    "</span>";
        else
          echo "<span class='puzzle'></span>";
      }
      echo "<br>";
    }
    echo "</form>";
    if ($this->model->is_completed()){
      echo "<p class='end-game'>";
      echo "You win!";
      echo "</p>";
    }
  }
}

class Controller
{
  protected $model;
  protected $view;

  function __construct($model, $view){
    $this->model = $model;
    $this->view = $view;
  }
  function run(){
    if (isset($_GET['index'])){
      $index = $_GET['index'];
      $this->model->move($this->model->get_tile_by_index($index));
    }
    $this->view->show();
  }
}
?>

<!DOCTYPE html>
<html lang="en"><meta charset="UTF-8">
<head>
  <title>15 puzzle game</title>
  <style>
    .puzzle{width: 4ch; display: inline-block; margin: 0; padding: 0.25ch;}
    span.puzzle{padding: 0.1ch;}
    .end-game{font-size: 400%; color: red;}
  </style>
</head>
<body>
  <p><?php
    if (!isset($_SESSION['model'])){
      $width = 4; $height = 4;
      $model = new Model($width, $height);
    }
    else
      $model = unserialize($_SESSION['model']);
    $view = new View($model);
    $controller = new Controller($model, $view);
    $controller->run();
    $_SESSION['model'] = serialize($model);
  ?></p>
</body>
</html>
