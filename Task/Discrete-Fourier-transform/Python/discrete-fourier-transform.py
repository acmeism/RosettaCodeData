# 20220918 Python programming solution
import cmath


def dft( x ):
    """Takes N either real or complex signal samples, yields complex DFT bins.  Assuming the input
    waveform is filtered to only contain signals in the bandwidth B range -B/2:+B/2 around baseband
    frequency MID, and is frequency shifted (divided by) your baseband frequency MID, and is sampled
    at the Nyquist rate R: given N samples, the result contains N signal frequency component bins:

        index:      0                           N/2                   N-1
        baseband:  [MID+] [MID+] ... [MID+]    [MID+/-]  [MID+]  ... [MID+]
        frequency:  DC     1B/N   (N/2-1)B/N   (N/2)B/N  (1-N/2)B/N  -1B/N

    """
    N                           = len( x )
    result                      = []
    for k in range( N ):
        r                       = 0
        for n in range( N ):
            t                   = -2j * cmath.pi * k * n / N
            r                  += x[n] * cmath.exp( t )
        result.append( r )
    return result


def idft( y ):
    """Inverse DFT on complex frequency bins."""
    N                           = len( y )
    result                      = []
    for n in range( N ):
        r                       = 0
        for k in range( N ):
            t                   = 2j * cmath.pi * k * n / N
            r                  += y[k] * cmath.exp( t )
        r                      /= N+0j
        result.append( r )
    return result


if __name__ == "__main__":
    x                           = [ 2, 3, 5, 7, 11 ]
    print( "vals:   " + ' '.join( f"{f:11.2f}" for f in x ))
    y                           = dft( x )
    print( "DFT:    " + ' '.join( f"{f:11.2f}" for f in y ))
    z                           = idft( y )
    print( "inverse:" + ' '.join( f"{f:11.2f}" for f in z ))
    print( " - real:" + ' '.join( f"{f.real:11.2f}" for f in z ))

    N                           = 8
    print( f"Complex signals, 1-4 cycles in {N} samples; energy into successive DFT bins" )
    for rot in (0, 1, 2, 3, -4, -3, -2, -1):    # cycles; and bins in ascending index order
        if rot > N/2:
            print( "Signal change frequency exceeds sample rate and will result in artifacts")
        sig                     = [
            # unit-magnitude complex samples, rotated through 2Pi 'rot' times, in N steps
            cmath.rect(
                1, cmath.pi*2*rot/N*i
            )
            for i in range( N )
        ]
        print( f"{rot:2} cycle" + ' '.join( f"{f:11.2f}" for f in sig ))
        dft_sig                 = dft( sig )
        print( f"  DFT:  " + ' '.join( f"{f:11.2f}" for f in dft_sig ))
        print( f"   ABS: " + ' '.join( f"{abs(f):11.2f}" for f in dft_sig ))
