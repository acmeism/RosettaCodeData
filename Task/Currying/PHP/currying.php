<?php

function curry($callable)
{
    if (_number_of_required_params($callable) === 0) {
        return _make_function($callable);
    }
    if (_number_of_required_params($callable) === 1) {
        return _curry_array_args($callable, _rest(func_get_args()));
    }
    return _curry_array_args($callable, _rest(func_get_args()));
}

function _curry_array_args($callable, $args, $left = true)
{
    return function () use ($callable, $args, $left) {
        if (_is_fullfilled($callable, $args)) {
            return _execute($callable, $args, $left);
        }
        $newArgs = array_merge($args, func_get_args());
        if (_is_fullfilled($callable, $newArgs)) {
            return _execute($callable, $newArgs, $left);
        }
        return _curry_array_args($callable, $newArgs, $left);
    };
}

function _number_of_required_params($callable)
{
    if (is_array($callable)) {
        $refl = new \ReflectionClass($callable[0]);
        $method = $refl->getMethod($callable[1]);
        return $method->getNumberOfRequiredParameters();
    }
    $refl = new \ReflectionFunction($callable);
    return $refl->getNumberOfRequiredParameters();
}

function _make_function($callable)
{
    if (is_array($callable))
        return function() use($callable) {
            return call_user_func_array($callable, func_get_args());
        };
    return $callable;
}

function _execute($callable, $args, $left)
{
    if (! $left) {
        $args = array_reverse($args);
    }
    $placeholders = _placeholder_positions($args);
    if (0 < count($placeholders)) {
        $n = _number_of_required_params($callable);
        if ($n <= _last($placeholders[count($placeholders) - 1])) {
            throw new \Exception('Argument Placeholder found on unexpected position!');
        }
        foreach ($placeholders as $i) {
            $args[$i] = $args[$n];
            array_splice($args, $n, 1);
        }
    }
    return call_user_func_array($callable, $args);
}

function _placeholder_positions($args)
{
    return array_keys(array_filter($args, '_is_placeholder'));
}

function _is_fullfilled($callable, $args)
{
    $args = array_filter($args, function($arg) {
        return ! _is_placeholder($arg);
    });
    return count($args) >= _number_of_required_params($callable);
}

function _is_placeholder($arg)
{
    return $arg instanceof Placeholder;
}

function _rest(array $args)
{
    return array_slice($args, 1);
}

function product($a, $b)
{
    return $a * $b;
}

echo json_encode(array_map(curry('product', 7), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]));
