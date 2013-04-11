lcase   : _ci 97+!26
ucase   : _ci 65+!26
tolower : {@[x;p;:;lcase@n@p:&26>n:ucase?/:x]}
panagram: {&/lcase _lin tolower x}
