class Fifo {
  private $data = array();
  public function push($element){
    array_push($this->data, $element);
  }
  public function pop(){
    if ($this->isEmpty()){
      throw new Exception('Attempt to pop from an empty queue');
    }
    return array_shift($this->data);
  }

  //Alias functions
  public function enqueue($element) { $this->push($element); }
  public function dequeue() { return $this->pop(); }

  //Note: PHP prevents a method name of 'empty'
  public function isEmpty(){
    return empty($this->data);
  }
}
