#!/bin/bash

vowels='AÀÁÂÃÄÅĀĂĄǺȀȂẠẢẤẦẨẪẬẮẰẲẴẶḀÆǼEȄȆḔḖḘḚḜẸẺẼẾỀỂỄỆĒĔĖĘĚÈÉÊËIȈȊḬḮỈỊĨĪĬĮİÌÍÎÏĲOŒØǾȌȎṌṎṐṒỌỎỐỒỔỖỘỚỜỞỠỢŌÒÓŎŐÔÕÖUŨŪŬŮŰŲÙÚÛÜȔȖṲṴṶṸṺỤỦỨỪỬỮỰ'

function input {
cat<<'EOF'
In this entry, we assume that the "vowels" of the particular texts of
interest can be specified as a JSON string of letters.  Furthermore,
we take advantage of gsub's support for the "ignore case" option, "i",
so that for vowels which have both upper and lower case forms, only
one form need be included in the string.  So for example, for
unaccented English text we could use the invocation:

jq -Rr 'gsub("[aeiou]+"; ""; "i")' input.txt

The string of vowels can also be specified as an argument to jq, e.g. assuming
a bash or bash-like scripting environment:

vowels='AÀÁÂÃÄÅĀĂĄǺȀȂẠẢẤẦẨẪẬẮẰẲẴẶḀÆǼEȄȆḔḖḘḚḜẸẺẼẾỀỂỄỆĒĔĖĘĚÈÉÊËIȈȊḬḮỈỊĨĪĬĮİÌÍÎÏĲOŒØǾȌȎṌṎṐṒỌỎỐỒỔỖỘỚỜỞỠỢŌÒÓŎŐÔÕÖUŨŪŬŮŰŲÙÚÛÜȔȖṲṴṶṸṺỤỦỨỪỬỮỰ'
jq -Rr --arg v "$vowels" 'gsub("[\($v)]+"; ""; "i")' input.txt

Norwegian, Icelandic, German, Turkish, French, Spanish, English:
Undervisningen skal være gratis, i det minste på de elementære og grunnleggende trinn.
Skal hún veitt ókeypis, að minnsta kosti barnafræðsla og undirstöðummentu.
Hochschulunterricht muß allen gleichermaßen entsprechend ihren Fähigkeiten offenstehen.
Öğrenim hiç olmazsa ilk ve temel safhalarında parasızdır. İlk öğretim mecburidir.
L'éducation doit être gratuite, au moins en ce qui concerne l'enseignement élémentaire et fondamental.
La instrucción elemental será obligatoria. La instrucción técnica y profesional habrá de ser generalizada.
Education shall be free, at least in the elementary and fundamental stages.
EOF
}

input | jq -Rr --arg v "$vowels" 'gsub("[\($v)]+"; ""; "i")'
