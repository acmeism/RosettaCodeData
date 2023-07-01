<?php
class fragile {
    private $foo = 'bar';
}
$fragile = new fragile;
$ro = new ReflectionObject($fragile);
$rp = $ro->getProperty('foo');
$rp->setAccessible(true);
var_dump($rp->getValue($fragile));
$rp->setValue($fragile, 'haxxorz!');
var_dump($rp->getValue($fragile));
var_dump($fragile);
