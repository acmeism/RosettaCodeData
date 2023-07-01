#define Throw(_X_)       if( !Is_ok ) { goto _X_; }
#define Exception(_H_)   _H_: if( !Is_ok++ )
#define Assert(_X_,_Y_)  if( !(_X_) ) { Is_ok=0; goto _Y_; }
