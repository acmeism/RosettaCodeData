<?php

include 'complex.class.php';

function IFFT($amplitudes)
{
    $N = count($amplitudes);
    $iN = 1 / $N;

    // Conjugate if imaginary part is not 0
    for($i = 0; $i < $N; ++$i){
        if($amplitudes[$i] instanceof Complex){
            $amplitudes[$i]->imaginary = -$amplitudes[$i]->imaginary;
        }
    }

    // Apply Fourier Transform
    $amplitudes = FFT($amplitudes);

    for($i = 0; $i < $N; ++$i){
        //Conjugate again
        $amplitudes[$i]->imaginary = -$amplitudes[$i]->imaginary;
        // Scale
        $amplitudes[$i]->real *= $iN;
        $amplitudes[$i]->imaginary *= $iN;
    }
    return $amplitudes;
}


function FFT($amplitudes)
{
    $N = count($amplitudes);
    if($N <= 1){
        return $amplitudes;
    }

    $hN = $N / 2;

    $even =  array_pad(array() , $hN, 0);
    $odd =  array_pad(array() , $hN, 0);
    for($i = 0; $i < $hN; ++$i){
        $even[$i] = $amplitudes[$i*2];
        $odd[$i] = $amplitudes[$i*2+1];
    }
    $even = FFT($even);
    $odd = FFT($odd);

    $a = -2*PI();
    for($k = 0; $k < $hN; ++$k){
        if(!($even[$k] instanceof Complex)){
            $even[$k] = new Complex($even[$k], 0);
        }

        if(!($odd[$k] instanceof Complex)){
            $odd[$k] = new Complex($odd[$k], 0);
        }
        $p = $k/$N;
        $t = new Complex(0, $a * $p);

        $t->ComplexExponential($t);
        $t->Multiply($odd[$k], $t);


        $amplitudes[$k] = $even[$k]->Add($t, $odd[$k]);
        $amplitudes[$k + $hN] = $even[$k]->Subtract($t, $even[$k]);
    }
    return $amplitudes;
}

function EchoSamples(&$samples){
    echo "Index\tReal\t\t\t\tImaginary" . PHP_EOL;
    foreach($samples as $key=>&$sample){
        echo  "$key\t" . number_format($sample->real, 13) . "\t\t\t\t" . number_format($sample->imaginary, 13) . PHP_EOL;
    }
}


// Input Amplitudes
$time_amplitude_samples = array(1,1,1,1,0,0,0,0);


// echo input for reference
echo 'Input '. PHP_EOL;
echo "Index\tReal" . PHP_EOL;
foreach($time_amplitude_samples as $key=>&$sample){
    echo  "$key\t" . number_format($sample, 13) . PHP_EOL;
}
echo PHP_EOL;

// Do FFT and echo results
echo 'FFT '. PHP_EOL;
$frequency_amplitude_samples = FFT($time_amplitude_samples);
EchoSamples($frequency_amplitude_samples);
echo PHP_EOL;

// Do inverse FFT and echo results
echo 'Inverse FFT '. PHP_EOL;
$frequency_back_to_time_amplitude_samples = IFFT($frequency_amplitude_samples);
EchoSamples($frequency_back_to_time_amplitude_samples);
echo PHP_EOL;
