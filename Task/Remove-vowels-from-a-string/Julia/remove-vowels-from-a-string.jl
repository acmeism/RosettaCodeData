const ALLVOWELS = Dict(ch => 1 for ch in Vector{Char}("AÀÁÂÃÄÅĀĂĄǺȀȂẠẢẤẦẨẪẬẮẰẲẴẶḀÆǼEȄȆḔḖḘḚḜẸẺẼẾỀỂỄỆĒĔĖĘĚÈÉÊËIȈȊḬḮỈỊĨĪĬĮİÌÍÎÏĲOŒØǾȌȎṌṎṐṒỌỎỐỒỔỖỘỚỜỞỠỢŌÒÓŎŐÔÕÖUŨŪŬŮŰŲÙÚÛÜȔȖṲṴṶṸṺỤỦỨỪỬỮỰ"))
const ALLVOWELSY = Dict(ch => 1 for ch in Vector{Char}("AÀÁÂÃÄÅĀĂĄǺȀȂẠẢẤẦẨẪẬẮẰẲẴẶḀÆǼEȄȆḔḖḘḚḜẸẺẼẾỀỂỄỆĒĔĖĘĚÈÉÊËIȈȊḬḮỈỊĨĪĬĮİÌÍÎÏĲOŒØǾȌȎṌṎṐṒỌỎỐỒỔỖỘỚỜỞỠỢŌÒÓŎŐÔÕÖUŨŪŬŮŰŲÙÚÛÜȔȖṲṴṶṸṺỤỦỨỪỬỮỰYẙỲỴỶỸŶŸÝ"))

isvowel(ch, yisavowel=false) = haskey(yisavowel ? ALLVOWELSY : ALLVOWELS, uppercase(ch))

const testtext = """
   Norwegian, Icelandic, German, Turkish, French, Spanish, English:
   Undervisningen skal være gratis, i det minste på de elementære og grunnleggende trinn.
   Skal hún veitt ókeypis, að minnsta kosti barnafræðsla og undirstöðummentu.
   Hochschulunterricht muß allen gleichermaßen entsprechend ihren Fähigkeiten offenstehen.
   Öğrenim hiç olmazsa ilk ve temel safhalarında parasızdır. İlk öğretim mecburidir.
   L'éducation doit être gratuite, au moins en ce qui concerne l'enseignement élémentaire et fondamental.
   La instrucción elemental será obligatoria. La instrucción técnica y profesional habrá de ser generalizada.
   Education shall be free, at least in the elementary and fundamental stages."""

println("Removing vowels from:\n$testtext\n becomes:\n",
    String(filter(!isvowel, Vector{Char}(testtext))))
