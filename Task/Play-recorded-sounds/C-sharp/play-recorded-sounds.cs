using System;
using System.Threading;
using System.Media;

class Program
{
    static void Main(string[] args)
    {
        //load sound file
        SoundPlayer s1 = new SoundPlayer(); //
        s1.SoundLocation = file; // or "s1 = new SoundPlayer(file)"

        //play
        s1.Play();

        //play for 0.1 seconds
        s1.Play();
        Thread.Sleep(100);
        s1.Stop();

        //loops
        s1.PlayLooping();
    }
}
