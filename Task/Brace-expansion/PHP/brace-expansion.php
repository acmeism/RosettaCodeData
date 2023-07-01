function getitem($s,$depth=0) {
    $out = [''];
    while ($s) {
        $c = $s[0];
        if ($depth && ($c == ',' || $c == '}')) {
            return [$out, $s];
        }
        if ($c == '{') {
            $x = getgroup(substr($s, 1), $depth + 1);
            if($x) {
                $tmp = [];
                foreach($out as $a) {
                    foreach($x[0] as $b) {
                        $tmp[] = $a . $b;
                    }
                }
                $out = $tmp;
                $s = $x[1];
                continue;
            }
        }
        if ($c == '\\' && strlen($s) > 1) {
            list($s, $c) = [substr($s, 1), ($c . $s[1])];
        }

        $tmp = [];
        foreach($out as $a) {
            $tmp[] = $a . $c;
        }
        $out = $tmp;
        $s = substr($s, 1);

    }
    return [$out, $s];
}
function getgroup($s,$depth) {
    list($out, $comma) = [[], false];
    while ($s) {
        list($g, $s) = getitem($s, $depth);
        if (!$s) {
            break;
        }
        $out = array_merge($out, $g);
        if ($s[0] == '}') {
            if ($comma) {
                return [$out, substr($s, 1)];
            }

            $tmp = [];
            foreach($out as $a) {
                $tmp[] = '{' . $a . '}';
            }
            return [$tmp, substr($s, 1)];
        }
        if ($s[0] == ',') {
            list($comma, $s) = [true, substr($s, 1)];
        }
    }
    return null;
}

$lines = <<< 'END'
~/{Downloads,Pictures}/*.{jpg,gif,png}
It{{em,alic}iz,erat}e{d,}, please.
{,{,gotta have{ ,\, again\, }}more }cowbell!
{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}
END;

foreach( explode("\n", $lines) as $line ) {
    printf("\n%s\n", $line);
    foreach( getitem($line)[0] as $expansion ) {
        printf("    %s\n", $expansion);
    }
}
