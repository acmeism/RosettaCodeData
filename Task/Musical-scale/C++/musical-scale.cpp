#include <iostream>
#include <windows.h>
#include <mmsystem.h>

#pragma comment ( lib, "winmm.lib" )

typedef unsigned char byte;

typedef union
{
    unsigned long word;
    unsigned char data[4];
}
midi_msg;

class midi
{
public:
    midi()
    {
	if( midiOutOpen( &device, 0, 0, 0, CALLBACK_NULL) != MMSYSERR_NOERROR )
	{
	    std::cout << "Error opening MIDI Output..." << std::endl;
	    device = 0;
	}
    }
    ~midi()
    {
	midiOutReset( device );
	midiOutClose( device );
    }
    bool isOpen() { return device != 0; }
    void setInstrument( byte i )
    {
	message.data[0] = 0xc0; message.data[1] = i;
	message.data[2] = 0; message.data[3] = 0;
	midiOutShortMsg( device, message.word );
    }
    void playNote( byte n, unsigned i )
    {
	playNote( n ); Sleep( i ); stopNote( n );
    }

private:
    void playNote( byte n )
    {
	message.data[0] = 0x90; message.data[1] = n;
	message.data[2] = 127; message.data[3] = 0;
	midiOutShortMsg( device, message.word );
    }
    void stopNote( byte n )
    {
	message.data[0] = 0x90; message.data[1] = n;
	message.data[2] = 0; message.data[3] = 0;
	midiOutShortMsg( device, message.word );
    }
    HMIDIOUT device;
    midi_msg message;
};

int main( int argc, char* argv[] )
{
    midi m;
    if( m.isOpen() )
    {
	byte notes[] = { 60, 62, 64, 65, 67, 69, 71, 72 };
	m.setInstrument( 42 );
	for( int x = 0; x < 8; x++ )
	    m.playNote( notes[x], rand() % 100 + 158 );
	Sleep( 1000 );
    }
    return 0;
}
