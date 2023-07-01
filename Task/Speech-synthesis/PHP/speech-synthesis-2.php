<?php

// List available SAPI voices
// 0 = Microsoft David Desktop - English (United States)
// 1 = Microsoft Zira Desktop - English (United States)
// ... If you have additional voices installed
function ListSAPIVoices(&$voice){
	foreach($voice->GetVoices as $v){
		echo $v->GetDescription . PHP_EOL;
	}
}



$filename = "DaisyBell.wav";

// https://en.wikipedia.org/wiki/Daisy_Bell#Computing_and_technology
// "In 1961, an IBM 704 at Bell Labs was programmed to sing "Daisy Bell"-
// in the earliest demonstration of computer speech synthesis."
$statement = "There is a flower within my heart, Daisy, Daisy!
Planted one day by a glancing dart,
Planted by Daisy Bell!
Whether she loves me or loves me not,
Sometimes it's hard to tell;
Yet I am longing to share the lot
Of beautiful Daisy Bell!

Daisy, Daisy,
Give me your answer, do!
I'm half crazy,
All for the love of you!
It won't be a stylish marriage,
I can't afford a carriage,
But you'll look sweet on the seat
Of a bicycle built for two!

We will go tandem as man and wife, Daisy, Daisy!
Ped'ling away down the road of life, I and my Daisy Bell!
When the road's dark we can both despise Po'leaseman and lamps as well;
There are bright lights in the dazzling eyes Of beautiful Daisy Bell!

Daisy, Daisy,
Give me your answer, do!
I'm half crazy,
All for the love of you!
It won't be a stylish marriage,
I can't afford a carriage,
But you'll look sweet on the seat
Of a bicycle built for two!

I will stand by you in wheel or woe, Daisy, Daisy!
You'll be the bell which I'll ring you know! Sweet little Daisy Bell!
You'll take the lead in each trip we take, Then if I don't do well;
I will permit you to use the brake, My beautiful Daisy Bell!";

// COM (Component Object Model) objects
// https://www.php.net/manual/en/book.com.php
$voice = new COM("SAPI.SpVoice");
$voice_file_stream = new COM("SAPI.SpVoice");
$file_stream = new COM("SAPI.SpFileStream");


// Change $voice to Zira
$voice->Voice = $voice->GetVoices()->Item(1);

// Change $voice_file_stream to David
$voice_file_stream->Voice = $voice_file_stream->GetVoices()->Item(0);

// Have voices announce themselves
//$voice->Speak($voice->Voice->GetDescription); // (Zira)
//$voice_file_stream->Speak($voice_file_stream->Voice->GetDescription); // (David)


/*
Select Stream Quality:

11kHz 8Bit Mono = 8
11kHz 8Bit Stereo = 9
11kHz 16Bit Mono = 10
11kHz 16Bit Stereo = 11
...
16kHz 8Bit Mono = 16
16kHz 8Bit Stereo = 17
16kHz 16Bit Mono = 18;
16kHz 16Bit Stereo = 19
...
32kHz 8Bit Mono = 28
32kHz 8Bit Stereo = 29
32kHz 16Bit Mono = 30
32kHz 16Bit Stereo = 31
...
*/
// Set stream quality
$file_stream->Format->Type = 17; // 16kHz 8Bit Stereo

/*
Select Speech StreamFile Mode:
Read = 0
ReadWrite = 1
Create = 2
CreateForWrite = 3
*/
$mode = 3;


// Have $voice (Zira) announce beginning file stream
$voice->Speak('Opening audio file stream');

// Output TTS to File
$file_stream->Open($filename, $mode); // Open stream and create file
$voice_file_stream->AudioOutputStream = $file_stream; // Begin streaming TTS
// Have $voice_file_stream (David) speak $statement
$voice_file_stream->Speak($statement);
$file_stream->Close; // Close stream

// Have $voice (Zira) announce file stream completion
$voice->Speak('File stream complete');
