<?php
<?php


/*
  _      _____ _   _ _    ___   __
 | |    |_   _| \ | | |  | \ \ / /
 | |      | | |  \| | |  | |\ V /
 | |      | | | . ` | |  | | > <
 | |____ _| |_| |\  | |__| |/ . \
 |______|_____|_| \_|\____//_/ \_\
*/
// Install eSpeak - Run this command in a terminal
/*
 sudo apt-get install eSpeak
*/


/*
  __  __          _____
 |  \/  |   /\   / ____|
 | \  / |  /  \ | |
 | |\/| | / /\ \| |
 | |  | |/ ____ \ |____
 |_|  |_/_/    \_\_____|
*/
// Mac has it's own Speech Synthesis system
// accessible via the "say" command.
// To use eSpeak on a Mac, change this variable to true.
$mac_use_espeak = false;

// To use eSpeak on a Mac you need to install
// Homebrew Package Manager & eSpeak
// Run these commands in a terminal:
/*

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install espeak

*/

$voice = "espeak";
$statement = 'Hello World!';
$save_file_args = '-w HelloWorld.wav'; // eSpeak args

// Ask PHP what OS it was compiled for,
// CAPITALIZE it and truncate to the first 3 chars.
$OS = strtoupper(substr(PHP_OS, 0, 3));

// If this is Darwin (MacOS) AND we don't want eSpeak
elseif($OS === 'DAR' && $mac_use_espeak == false) {
    $voice = "say -v 'Victoria'";
    $save_file_args = '-o HelloWorld.wav'; // say args
}

// Say It
exec("$voice '$statement'");

// Save it to a File
exec("$voice '$statement' $save_file_args");
