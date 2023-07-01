define(`invert',`ifelse(len(`$1'),0,,`invert(substr(`$1',1))'`'substr(`$1',0,1))')
