use MONKEY_TYPING; # Needed to do runtime augmentation of a base class.

augment class Any {
    method nsort { self.list.sort: {$^a.lc.subst(/(\d+)/,->$/{0~$0.chars.chr~$0},:g)~"\x0"~$^a} }
};

say ~<a201st a32nd a3rd a144th a17th a2 a95>.nsort;
say ~<a201st a32nd a3rd a144th a17th a2 a95>.sort;
