#!/usr/bin/php
<?php

# defined as numbers, so I can use max() and min() on it
if (! define('triFalse',0))  trigger_error('Unknown error defining!', E_USER_ERROR);
if (! define('triMaybe',1))  trigger_error('Unknown error defining!', E_USER_ERROR);
if (! define('triTrue', 2))  trigger_error('Unknown error defining!', E_USER_ERROR);

$triNotarray = array(triFalse=>triTrue, triMaybe=>triMaybe, triTrue=>triFalse);

# output helper
function triString ($tri) {
    if ($tri===triFalse) return 'false  ';
    if ($tri===triMaybe) return 'unknown';
    if ($tri===triTrue)  return 'true   ';
    trigger_error('triString: parameter not a tri value', E_USER_ERROR);
}

function triAnd() {
    if (func_num_args() < 2)
       trigger_error('triAnd needs 2 or more parameters', E_USER_ERROR);
    return min(func_get_args());
}

function triOr() {
    if (func_num_args() < 2)
       trigger_error('triOr needs 2 or more parameters', E_USER_ERROR);
    return max(func_get_args());
}

function triNot($t) {
    global $triNotarray; # using result table
    if (in_array($t, $triNotarray)) return $triNotarray[$t];
    trigger_error('triNot: Parameter is not a tri value', E_USER_ERROR);
}

function triImplies($a, $b) {
    if ($a===triFalse || $b===triTrue)  return triTrue;
    if ($a===triMaybe || $b===triMaybe) return triMaybe;
    # without parameter type check I just would return triFalse here
    if ($a===triTrue &&  $b===triFalse) return triFalse;
    trigger_error('triImplies: parameter type error', E_USER_ERROR);
}

function triEquiv($a, $b) {
    if ($a===triTrue)  return $b;
    if ($a===triMaybe) return $a;
    if ($a===triFalse) return triNot($b);
    trigger_error('triEquiv: parameter type error', E_USER_ERROR);
}

# data sampling

printf("--- Sample output for a equivalent b ---\n\n");

foreach ([triTrue,triMaybe,triFalse] as $a) {
    foreach ([triTrue,triMaybe,triFalse] as $b) {
        printf("for a=%s and b=%s a equivalent b is %s\n",
               triString($a), triString($b), triString(triEquiv($a, $b)));
    }
}
