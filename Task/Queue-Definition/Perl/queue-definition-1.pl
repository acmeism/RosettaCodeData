use Carp;
sub mypush (\@@) {my($list,@things)=@_; push @$list, @things}
sub mypop  (\@)  {my($list)=@_; @$list or croak "Empty"; shift @$list }
sub empty  (@)   {not @_}
