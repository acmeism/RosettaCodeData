<?php

class ethiopian_multiply {

   protected $result = 0;

   protected function __construct($x, $y){
      while($x >= 1){
         $this->sum_result($x, $y);
         $x = $this->half_num($x);
         $y = $this->double_num($y);
      }
   }

   protected function half_num($x){
      return floor($x/2);
   }

   protected function double_num($y){
      return $y*2;
   }

   protected function not_even($n){
      return $n%2 != 0 ? true : false;
   }

   protected function sum_result($x, $y){
      if($this->not_even($x)){
         $this->result += $y;
      }
   }

   protected function get_result(){
      return $this->result;
   }

   static public function init($x, $y){
      $init = new ethiopian_multiply($x, $y);
      return $init->get_result();
   }

}

echo ethiopian_multiply::init(17, 34);

?>
