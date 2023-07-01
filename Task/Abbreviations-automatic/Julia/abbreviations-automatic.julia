const text = """
Sunday Monday Tuesday Wednesday Thursday Friday Saturday
Sondag Maandag Dinsdag Woensdag Donderdag Vrydag Saterdag
E_djelë E_hënë E_martë E_mërkurë E_enjte E_premte E_shtunë
Ehud Segno Maksegno Erob Hamus Arbe Kedame
Al_Ahad Al_Ithinin Al_Tholatha'a Al_Arbia'a Al_Kamis Al_Gomia'a Al_Sabit
Guiragui Yergou_shapti Yerek_shapti Tchorek_shapti Hink_shapti Ourpat Shapat
domingu llunes martes miércoles xueves vienres sábadu
Bazar_gÜnÜ Birinci_gÜn Çkinci_gÜn ÜçÜncÜ_gÜn DÖrdÜncÜ_gÜn Bes,inci_gÜn Altòncò_gÜn
Igande Astelehen Astearte Asteazken Ostegun Ostiral Larunbat
Robi_bar Shom_bar Mongal_bar Budhh_bar BRihashpati_bar Shukro_bar Shoni_bar
Nedjelja Ponedeljak Utorak Srijeda Cxetvrtak Petak Subota
Disul Dilun Dimeurzh Dimerc'her Diriaou Digwener Disadorn
nedelia ponedelnik vtornik sriada chetvartak petak sabota
sing_kei_yaht sing_kei_yat sing_kei_yee sing_kei_saam sing_kei_sie sing_kei_ng sing_kei_luk
Diumenge Dilluns Dimarts Dimecres Dijous Divendres Dissabte
Dzeenkk-eh Dzeehn_kk-ehreh Dzeehn_kk-ehreh_nah_kay_dzeeneh Tah_neesee_dzeehn_neh Deehn_ghee_dzee-neh Tl-oowey_tts-el_dehlee Dzeentt-ahzee
dy_Sul dy_Lun dy_Meurth dy_Mergher dy_You dy_Gwener dy_Sadorn
Dimanch Lendi Madi Mèkredi Jedi Vandredi Samdi
nedjelja ponedjeljak utorak srijeda cxetvrtak petak subota
nede^le ponde^lí úterÿ str^eda c^tvrtek pátek sobota
Sondee Mondee Tiisiday Walansedee TOOsedee Feraadee Satadee
s0ndag mandag tirsdag onsdag torsdag fredag l0rdag
zondag maandag dinsdag woensdag donderdag vrijdag zaterdag
Diman^co Lundo Mardo Merkredo ^Jaùdo Vendredo Sabato
pÜhapäev esmaspäev teisipäev kolmapäev neljapäev reede laupäev

Diu_prima Diu_sequima Diu_tritima Diu_quartima Diu_quintima Diu_sextima Diu_sabbata
sunnudagur mánadagur tÿsdaguy mikudagur hósdagur friggjadagur leygardagur
Yek_Sham'beh Do_Sham'beh Seh_Sham'beh Cha'har_Sham'beh Panj_Sham'beh Jom'eh Sham'beh
sunnuntai maanantai tiistai keskiviiko torsktai perjantai lauantai
dimanche lundi mardi mercredi jeudi vendredi samedi
Snein Moandei Tiisdei Woansdei Tonersdei Freed Sneon
Domingo Segunda_feira Martes Mércores Joves Venres Sábado
k'vira orshabati samshabati otkhshabati khutshabati p'arask'evi shabati
Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag
Kiriaki' Defte'ra Tri'ti Teta'rti Pe'mpti Paraskebi' Sa'bato
ravivaar somvaar mangalvaar budhvaar guruvaar shukravaar shanivaar
pópule pó`akahi pó`alua pó`akolu pó`ahá pó`alima pó`aono
Yom_rishon Yom_sheni Yom_shlishi Yom_revi'i Yom_chamishi Yom_shishi Shabat
ravivara somavar mangalavar budhavara brahaspativar shukravara shanivar
vasárnap hétfö kedd szerda csütörtök péntek szombat
Sunnudagur Mánudagur ╞riδjudagur Miδvikudagar Fimmtudagur FÖstudagur Laugardagur
sundio lundio mardio merkurdio jovdio venerdio saturdio
Minggu Senin Selasa Rabu Kamis Jumat Sabtu
Dominica Lunedi Martedi Mercuridi Jovedi Venerdi Sabbato
Dé_Domhnaigh Dé_Luain Dé_Máirt Dé_Ceadaoin Dé_ardaoin Dé_hAoine Dé_Sathairn
domenica lunedí martedí mercoledí giovedí venerdí sabato
Nichiyou_bi Getzuyou_bi Kayou_bi Suiyou_bi Mokuyou_bi Kin'you_bi Doyou_bi
Il-yo-il Wol-yo-il Hwa-yo-il Su-yo-il Mok-yo-il Kum-yo-il To-yo-il
Dies_Dominica Dies_Lunæ Dies_Martis Dies_Mercurii Dies_Iovis Dies_Veneris Dies_Saturni
sve-tdien pirmdien otrdien tresvdien ceturtdien piektdien sestdien
Sekmadienis Pirmadienis Antradienis Trec^iadienis Ketvirtadienis Penktadienis S^es^tadienis
Wangu Kazooba Walumbe Mukasa Kiwanuka Nnagawonye Wamunyi
xing-_qi-_rì xing-_qi-_yi-. xing-_qi-_èr xing-_qi-_san-. xing-_qi-_sì xing-_qi-_wuv. xing-_qi-_liù
Jedoonee Jelune Jemayrt Jecrean Jardaim Jeheiney Jesam
Jabot Manre Juje Wonje Taije Balaire Jarere
geminrongo minòmishi mártes mièrkoles misheushi bèrnashi mishábaro
Ahad Isnin Selasa Rabu Khamis Jumaat Sabtu
sφndag mandag tirsdag onsdag torsdag fredag lφrdag
lo_dimenge lo_diluns lo_dimarç lo_dimèrcres lo_dijòus lo_divendres lo_dissabte
djadomingo djaluna djamars djarason djaweps djabièrna djasabra
Niedziela Poniedzial/ek Wtorek S,roda Czwartek Pia,tek Sobota
Domingo segunda-feire terça-feire quarta-feire quinta-feire sexta-feira såbado
Domingo Lunes martes Miercoles Jueves Viernes Sabado
Duminicª Luni Mart'i Miercuri Joi Vineri Sâmbªtª
voskresenie ponedelnik vtornik sreda chetverg pyatnitsa subbota
Sunday Di-luain Di-màirt Di-ciadain Di-ardaoin Di-haoine Di-sathurne
nedjelja ponedjeljak utorak sreda cxetvrtak petak subota
Sontaha Mmantaha Labobedi Laboraro Labone Labohlano Moqebelo
Iridha- Sandhudha- Anga.haruwa-dha- Badha-dha- Brahaspa.thindha- Sikura-dha- Sena.sura-dha-
nedel^a pondelok utorok streda s^tvrtok piatok sobota
Nedelja Ponedeljek Torek Sreda Cxetrtek Petek Sobota
domingo lunes martes miércoles jueves viernes sábado
sonde mundey tude-wroko dride-wroko fode-wroko freyda Saturday
Jumapili Jumatatu Jumanne Jumatano Alhamisi Ijumaa Jumamosi
söndag måndag tisdag onsdag torsdag fredag lordag
Linggo Lunes Martes Miyerkoles Huwebes Biyernes Sabado
Lé-pài-jít Pài-it Pài-jï Pài-sañ Pài-sì Pài-gÖ. Pài-lák
wan-ar-tit wan-tjan wan-ang-kaan wan-phoet wan-pha-ru-hat-sa-boh-die wan-sook wan-sao
Tshipi Mosupologo Labobedi Laboraro Labone Labotlhano Matlhatso
Pazar Pazartesi Sali Çar,samba Per,sembe Cuma Cumartesi
nedilya ponedilok vivtorok sereda chetver pyatnytsya subota
Chu?_Nhâ.t Thú*_Hai Thú*_Ba Thú*_Tu* Thú*_Na'm Thú*_Sáu Thú*_Ba?y
dydd_Sul dyds_Llun dydd_Mawrth dyds_Mercher dydd_Iau dydd_Gwener dyds_Sadwrn
Dibeer Altine Talaata Allarba Al_xebes Aljuma Gaaw
iCawa uMvulo uLwesibini uLwesithathu uLuwesine uLwesihlanu uMgqibelo
zuntik montik dinstik mitvokh donershtik fraytik shabes
iSonto uMsombuluko uLwesibili uLwesithathu uLwesine uLwesihlanu uMgqibelo
Dies_Dominica Dies_Lunæ Dies_Martis Dies_Mercurii Dies_Iovis Dies_Veneris Dies_Saturni
Bazar_gÜnÜ Bazar_ærtæsi Çærs,ænbæ_axs,amò Çærs,ænbæ_gÜnÜ CÜmæ_axs,amò CÜmæ_gÜnÜ CÜmæ_Senbæ
Sun Moon Mars Mercury Jove Venus Saturn
zondag maandag dinsdag woensdag donderdag vrijdag zaterdag
KoseEraa GyoOraa BenEraa Kuoraa YOwaaraa FeEraa Memenaa
Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Sonnabend
Domingo Luns Terza_feira Corta_feira Xoves Venres Sábado
Dies_Solis Dies_Lunae Dies_Martis Dies_Mercurii Dies_Iovis Dies_Veneris Dies_Sabbatum
xing-_qi-_tiàn xing-_qi-_yi-. xing-_qi-_èr xing-_qi-_san-. xing-_qi-_sì xing-_qi-_wuv. xing-_qi-_liù
djadomingu djaluna djamars djarason djaweps djabièrnè djasabra
Killachau Atichau Quoyllurchau Illapachau Chaskachau Kuychichau Intichau"""

function processweek(txt)
    for lin in split(txt, "\n")
        print(lin)
        if length(lin) < 7
            println("A blank line returns \"\", a blank string.")
            continue
        end
        words = map(x->"$x", split(lin, r"\s+"))
        minlen = minimum(map(length, words))
        abbrev = fill("", length(words))
        for i in 1:minlen
            if length(unique(wrd -> split(wrd, "")[1:i], words)) == length(words)
                for (k, word) in enumerate(words)
                    abbrev[k] = join(split(word, "")[1:i], "")
                end
                println(" => ", abbrev, ", which are length ", i)
                break
            elseif i == minlen
                println(" => Could not find abbreviations for the week")
            end
        end
    end
end

processweek(text)
