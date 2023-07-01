<?php

class Complex
{
    public $real;
    public $imaginary;

    function __construct($real, $imaginary){
        $this->real = $real;
        $this->imaginary = $imaginary;
    }

    function Add($other, $dst){
        $dst->real = $this->real + $other->real;
        $dst->imaginary = $this->imaginary + $other->imaginary;
        return $dst;
    }

    function Subtract($other, $dst){

        $dst->real = $this->real - $other->real;
        $dst->imaginary = $this->imaginary - $other->imaginary;
        return $dst;
    }

    function Multiply($other, $dst){
        //cache real in case dst === this
        $r = $this->real * $other->real - $this->imaginary * $other->imaginary;
        $dst->imaginary = $this->real * $other->imaginary + $this->imaginary * $other->real;
        $dst->real = $r;
        return $dst;
    }

    function ComplexExponential($dst){
        $er = exp($this->real);
        $dst->real = $er * cos($this->imaginary);
        $dst->imaginary = $er * sin($this->imaginary);
        return $dst;
    }
}
