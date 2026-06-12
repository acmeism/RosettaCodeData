first( range(1; infinite) | select( .*. - ((.-1) | .*.) > 1000 ) )
