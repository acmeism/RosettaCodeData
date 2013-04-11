$foo = new Fifo();
$foo->push('One');
$foo->enqueue('Two');
$foo->push('Three');

echo $foo->pop();     //Prints 'One'
echo $foo->dequeue(); //Prints 'Two'
echo $foo->pop();     //Prints 'Three'
echo $foo->pop();     //Throws an exception
