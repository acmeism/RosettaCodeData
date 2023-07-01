luminance histogram_median(histogram h)
{
    luminance From, To;
    unsigned int Left, Right;

    From = 0; To = (1 << (8*sizeof(luminance)))-1;
    Left = h[From]; Right = h[To];

    while( From != To )
    {
       if ( Left < Right )
       {
          From++; Left += h[From];
       } else {
          To--; Right += h[To];
       }
    }
    return From;
}
