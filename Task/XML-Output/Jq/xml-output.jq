def escapes: [
    ["&" , "&amp;"], # must do this one first
    ["\"", "&quot;"],
    ["'" , "&apos;"],
    ["<" , "&lt;"],
    [">" , "&gt;"]
];

def xmlEscape:
  reduce escapes[] as $esc (.; gsub($esc[0]; $esc[1]));

def xmlDoc(names; remarks):
    reduce range(0;names|length) as $i ("<CharacterRemarks>\n";
        (names[$i]|xmlEscape) as $name
        | (remarks[$i]|xmlEscape) as $remark
        | .  + "    <Character name=\"\($name)\">\($remark)</Character>\n")
    + "</CharacterRemarks>" ;

def names: ["April", "Tam O'Shanter", "Emily"];
def remarks: [
    "Bubbly: I'm > Tam and <= Emily",
    "Burns: \"When chapman billies leave the street ...\"",
    "Short & shrift"
];

xmlDoc(names; remarks)
