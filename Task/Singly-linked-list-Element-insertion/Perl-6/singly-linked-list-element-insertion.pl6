my @list = <a b>;
say @list.splice(1,0,'c');
say @list;
