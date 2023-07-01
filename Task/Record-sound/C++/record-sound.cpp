#include <iostream>
#include <string>
#include <windows.h>
#include <mmsystem.h>

#pragma comment ( lib, "winmm.lib" )
using namespace std;

class recorder
{
public:
    void start()
    {
	paused = rec = false; action = "IDLE";
	while( true )
	{
	    cout << endl << "==" << action << "==" << endl << endl;
	    cout << "1) Record" << endl << "2) Play" << endl << "3) Pause" << endl << "4) Stop" << endl << "5) Quit" << endl;
	    char c; cin >> c;
	    if( c > '0' && c < '6' )
	    {
		switch( c )
		{
		    case '1': record(); break;
		    case '2': play();   break;
		    case '3': pause();  break;
		    case '4': stop();   break;
		    case '5': stop();   return;
		}
	    }
	}
    }
private:
    void record()
    {
	if( mciExecute( "open new type waveaudio alias my_sound") )
	{
	    mciExecute( "record my_sound" );
	    action = "RECORDING"; rec = true;
	}
    }
    void play()
    {
	if( paused )
	    mciExecute( "play my_sound" );
	else
	    if( mciExecute( "open tmp.wav alias my_sound" ) )
		mciExecute( "play my_sound" );

	action = "PLAYING";
	paused = false;
    }
    void pause()
    {
	if( rec ) return;
	mciExecute( "pause my_sound" );
	paused = true; action = "PAUSED";
    }
    void stop()
    {
	if( rec )
	{
	    mciExecute( "stop my_sound" );
	    mciExecute( "save my_sound tmp.wav" );
	    mciExecute( "close my_sound" );
	    action = "IDLE"; rec = false;
	}
	else
	{
	    mciExecute( "stop my_sound" );
	    mciExecute( "close my_sound" );
	    action = "IDLE";
	}
    }
    bool mciExecute( string cmd )
    {
	if( mciSendString( cmd.c_str(), NULL, 0, NULL ) )
	{
	    cout << "Can't do this: " << cmd << endl;
	    return false;
	}
	return true;
    }

    bool paused, rec;
    string action;
};

int main( int argc, char* argv[] )
{
    recorder r; r.start();
    return 0;
}
