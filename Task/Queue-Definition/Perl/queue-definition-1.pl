use Carp;
sub my push :prototype(\@@) {my($list,@things)=@_; push @$list, @things}
sub maypop  :prototype(\@)  {my($list)=@_; @$list or croak "Empty"; shift @$list }
sub empty   :prototype(@)   {not @_}
