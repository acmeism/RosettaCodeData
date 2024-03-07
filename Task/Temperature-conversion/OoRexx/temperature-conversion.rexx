/* REXX convert temperatures from/to 58 temperature scakes                       */
Parse Source src
Parse Var src . how .

If how='FUNCTION' Then
  If arg(2)='' Then
    tlist=arg(1) 'TO' 'K'
  Else
    tlist=arg(1) 'TO' arg(2)
Else Do
  Parse Arg tList                          /* get the list of pairs                */
  If arg(1)='?' Then Call help
  tList= space(tList)                      /* elide any and all superfluous blanks.*/
  End
Do While tList>''                          /* process the list                     */
  Parse Var tList pair ',' tList           /* pairs are separated by commas        */
  Parse       Var pair from_to '(' desc    /* get spec and description (If any)    */
  Parse upper Var from_to fromt ' TO' toscal . /* get temperature and target scale */
  If toscal=='' Then Do                    /* no target scale: show all targets    */
    If how='FUNCTION' Then Do
      all=0
      toscal='K'
      End
    Else Do
      all=1
      toscale='all'
      End
    End
  Else Do
    all=0
    toscale=scalename(toscal)
    End

  Parse Var fromt fromtemp fromscal
  If fromscal='' Then
    fromscale='K'                       /*assume kelvin as per task requirement*/
  Else
    fromscale=scalename(fromscal)

  If fromt='' Then Call serr 'No source temperature specified'
  If \datatype(fromtemp,'N') Then Call serr 'Source temperature ('fromtemp') not numeric'
  If left(fromscale,1)='*' Then Call serr 'Invalid source scale' fromscale
  If left(toscale,1)='*' Then Call serr 'Invalid target scale' toscale

  F=convert2Fahrenheit(fromtemp fromscale) /*convert a temperature --? Fahrenheit.*/

  If F<-459.67 Then Call serr 'Source temperature below absolute zero'

  If how<>'FUNCTION' Then Do            /* write a header line                    */
    If desc<>'' Then desc='('desc
    Say pair                /*show original value & scale (for sep)*/
    If toscale<>'' Then
      Say fromtemp fromscale 'TO' toscale
    Else
      Say fromtemp fromscale 'TO' all
    End

  Call convert2specific

  End   /* while tlist>'' */
Exit                                     /* stick a fork in it, we're all done.  */

scaleName:
 Parse Arg sn                            /* abbreviations --> temp. short name.  */
 snU=translate(sn)                       /* uppercase version of temperature unit*/
 snU=translate(snU,'-eE',"_éÉ")          /* translate some accented characters.  */

 If left(snU,7)=='DEGREES' Then          /* is this a redundant "degrees"  ?     */
   snU=substr(snU,8)
 If left(snU,6)=='DEGREE' Then           /* "  "    " "         "degree"  ?      */
   snU=substr(snU,7)
 snU=strip(snU)                          /* elide all leading & trailing blanks  */
 _= length(snU)                          /* obtain the length of the  snU  value */

 If right(snU,1)=='S' & _>1 Then
   snU=left(snU,_-1)                     /* remove any trailing plural(s)        */

 Select                                  /* get scalename from abbrevuation      */
   When abbrev('ALL'                     , snU, 3)    Then sn= "ALL"
   When abbrev('ABSOLUTE'                , snU, 1)    Then sn= "ABSOLUTE"
   When abbrev('AMONTON'                 , snU)       Then sn= "AMONTON"
   When abbrev('BARNDORF'                , snU,2)  |,
        abbrev('BARNSDORF'               , snU,2)     Then sn= "BARNSDORF"
   When abbrev('BEAUMIUR'                , snU,3)  |,
        abbrev('BEAUMUIR'                , snU,3)     Then sn= "BEAUMUIR"
   When abbrev('BENERT'                  , snU,3)  |,
        abbrev('BENART'                  , snU,3)     Then sn= "BENART"
   When abbrev('BRISSEN'                 , snU,3)  |,
        abbrev('BRISSON'                 , snU,3)     Then sn= "BRISSEN"
   When abbrev('BURGEN'                  , snU,3)  |,
        abbrev('BURGAN'                  , snU,3)  |,
        abbrev('BERGAN'                  , snU,3)  |,
        abbrev('BERGEN'                  , snU,3)     Then sn= "BERGEN"
   When abbrev('CENTIGRADE'              , snU)    |,
        abbrev('CENTRIGRADE'             , snU)    |,       /* 50% misspelled.*/
        abbrev('CETIGRADE'               , snU)    |,       /* 50% misspelled.*/
        abbrev('CENTINGRADE'             , snU)    |,
        abbrev('CENTESIMAL'              , snU)    |,
        abbrev('CELCIU'                  , snU)    |,       /* 82% misspelled.*/
        abbrev('CELCIOU'                 , snU)    |,       /*  4% misspelled.*/
        abbrev('CELCUI'                  , snU)    |,       /*  4% misspelled.*/
        abbrev('CELSUI'                  , snU)    |,       /*  2% misspelled.*/
        abbrev('CELCEU'                  , snU)    |,       /*  2% misspelled.*/
        abbrev('CELCU'                   , snU)    |,       /*  2% misspelled.*/
        abbrev('CELISU'                  , snU)    |,       /*  1% misspelled.*/
        abbrev('CELSU'                   , snU)    |,       /*  1% misspelled.*/
        abbrev('HECTOGRADE'              , snU)    |,
        abbrev('CELSIU'                  , snU)       Then sn= "CELSIUS"
   When abbrev('CIMANTO'                 , snU,2)  |,
        abbrev('CIMENTO'                 , snU,2)     Then sn= "CIMENTO"
   When abbrev('CRUQUIOU'                , snU,2)  |,
        abbrev('CRUQUIO'                 , snU,2)  |,
        abbrev('CRUQUIU'                 , snU,2)     Then sn= "CRUQUIU"
   When abbrev('DALANCE'                 , snU,4)  |,
        abbrev('DALENCE'                 , snU,4)     Then sn= "DALENCE"
   When abbrev('DANELLE'                 , snU,3)  |,
        abbrev('DANEAL'                  , snU,3)  |,
        abbrev('DANIAL'                  , snU,3)  |,
        abbrev('DANIELE'                 , snU,3)  |,
        abbrev('DANNEL'                  , snU,3)  |,
        abbrev('DANYAL'                  , snU,3)  |,
        abbrev('DANYEL'                  , snU,3)  |,
        abbrev('DANIELL'                 , snU,3)     Then sn= "DANIELL"
   When abbrev('DALTON'                  , snU,3)     Then sn= "DALTON"
   When abbrev('DELAHIRE'                , snU,7)  |,
        abbrev('LAHIRE'                  , snU,4)  |,
        abbrev('HIRE'                    , snU,2)  |,
        abbrev('DE-LA-HIRE'              , snU,7)     Then sn= "DE LA HIRE"
   When abbrev('DELAVILLE'               , snU,7)  |,
        abbrev('LAVILLE'                 , snU,3)  |,
        abbrev('VILLE'                   , snU,1)  |,
        abbrev('VILLA'                   , snU,1)  |,
        abbrev('DE-LA-VILLE'             , snU,7)     Then sn= "DE LA VILLE"
   When abbrev('DELISLE'                 , snU,3)     Then sn= "DELISLE"
   When abbrev('DELISLE-OLD'             , snU,8)  |,
        abbrev('OLDDELISLE'              , snU,6)  |,
        abbrev('DELISLEOLD'              , snU,8)     Then sn= "DELISLE OLD"
   When abbrev('DELUC'                   , snU,4)  |,
        abbrev('LUC'                     , snU,2)  |,
        abbrev('DE-LUC'                  , snU,5)     Then sn= "DE LUC"
   When abbrev('DELYON'                  , snU,4)  |,
        abbrev('LYON'                    , snU,2)  |,
        abbrev('DE-LYON'                 , snU,5)     Then sn= "DE LYON"
   When abbrev('DEREVILLA'               , snU,3)  |,
        abbrev('DEREVILA'                , snU,3)  |,
        abbrev('REVILLA'                 , snU,3)  |,
        abbrev('DE-REVILLA'              , snU,4)  |,
        abbrev('DE-REVILLA'              , snU,5)     Then sn= "DE REVILLAS"
   When abbrev('DEVILLENEUVE'            , snU,3)  |,
        abbrev('DE-VILLENEUVE'           , snU,4)     Then sn= "DE VILLENEUVE"
   When abbrev('DURHAM'                  , snU,3)  |,
        abbrev('DERHAM'                  , snU,4)     Then sn= "DERHAM"
   When abbrev('OLDDURHAM'               , snU,5)  |,
        abbrev('OLDDERHAM'               , snU,6)  |,
        abbrev('DERHAM-OLD'              , snU,4)  |,
        abbrev('DERHAMOLD'               , snU,4)     Then sn= "DERHAM OLD"
   When abbrev('DE-SUEDE'                , snU,4)  |,
        abbrev('DESUEDE'                 , snU,4)     Then sn= "DE SUEDE"
   When abbrev('DU-CREST'                , snU,2)  |,
        abbrev('DUCREST'                 , snU,2)     Then sn= "DU CREST"
   When abbrev('EDENBURGH'               , snU,2)  |,
        abbrev('EDINBURGH'               , snU,2)     Then sn= "EDINBURGH"
   When abbrev('EVOLT'                   , snU,2)  |,
        abbrev('ELECTRONVOLT'            , snU,2)     Then sn= "ELECTRON VOLTS"
   When abbrev('FARENHEIT'               , snU)    |,       /* 39% misspelled.*/
        abbrev('FARENHEIGHT'             , snU)    |,       /* 15% misspelled.*/
        abbrev('FARENHITE'               , snU)    |,       /*  6% misspelled.*/
        abbrev('FARENHIET'               , snU)    |,       /*  3% misspelled.*/
        abbrev('FARHENHEIT'              , snU)    |,       /*  3% misspelled.*/
        abbrev('FARINHEIGHT'             , snU)    |,       /*  2% misspelled.*/
        abbrev('FARENHIGHT'              , snU)    |,       /*  2% misspelled.*/
        abbrev('FAHRENHIET'              , snU)    |,       /*  2% misspelled.*/
        abbrev('FERENHEIGHT'             , snU)    |,       /*  2% misspelled.*/
        abbrev('FEHRENHEIT'              , snU)    |,       /*  2% misspelled.*/
        abbrev('FERENHEIT'               , snU)    |,       /*  2% misspelled.*/
        abbrev('FERINHEIGHT'             , snU)    |,       /*  1% misspelled.*/
        abbrev('FARIENHEIT'              , snU)    |,       /*  1% misspelled.*/
        abbrev('FARINHEIT'               , snU)    |,       /*  1% misspelled.*/
        abbrev('FARANHITE'               , snU)    |,       /*  1% misspelled.*/
        abbrev('FAHRENHEIT'              , snU)       Then sn= "FAHRENHEIT"
   When abbrev('OLDFAHRENHEIT'           , snU,4)  |,
        abbrev('FAHRENHEIT-OLD'          , snU,13) |,
        abbrev('FAHRENHEITOLD'           , snU,13)    Then sn= "FARHENHEIT OLD"
   When abbrev('FLORENTINE-LARGE'        , snU,12) |,
        abbrev('LARGE-FLORENTINE'        , snU,7)  |,
        abbrev('LARGEFLORENTINE'         , snU,6)  |,
        abbrev('FLORENTINELARGE'         , snU,12)    Then sn= "FLORENTINE LARGE"
   When abbrev('FLORENTINE-MAGNUM'       , snU,2)  |,
        abbrev('MAGNUM-FLORENTINE'       , snU,3)  |,
        abbrev('MAGNUMFLORENTINE'        , snU,3)  |,
        abbrev('FLORENTINEMAGNUM'        , snU,2)     Then sn= "FLORENTINE MAGNUM"
   When abbrev('FLORENTINE-SMALL'        , snU,13) |,
        abbrev('SMALL-FLORENTINE'        , snU,7)  |,
        abbrev('SMALLFLORENTINE'         , snU,6)  |,
        abbrev('FLORENTINESMALL'         , snU,13)    Then sn= "FLORENTINE SMALL"
   When abbrev('FOULER'                  , snU,2)  |,
        abbrev('FOWLOR'                  , snU,2)  |,
        abbrev('FOWLER'                  , snU,2)     Then sn= "FOWLER"
   When abbrev('FRICK'                   , snU,2)     Then sn= "FRICK"
   When abbrev('GAS-MARK'                , snU,2)  |,
        abbrev('GASMARK'                 , snU,2)     Then sn= "GAS MARK"
   When abbrev('GOUBERT'                 , snU,2)     Then sn= "GOUBERT"
   When abbrev('HAIL'                    , snU,3)  |,
        abbrev('HALE'                    , snU,3)     Then sn= "HALES"
   When abbrev('HANOW'                   , snU,3)     Then sn= "HANOW"
   When abbrev('HUCKSBEE'                , snU,3)  |,
        abbrev('HAWKSBEE'                , snU,3)  |,
        abbrev('HAUKSBEE'                , snU,3)     Then sn= "HAUKSBEE"
   When abbrev('JACOBSHOLBORN'           , snU,2)  |,
        abbrev('JACOBS-HOLBORN'          , snU,2)     Then sn= "JACOBS-HOLBORN"
   When abbrev('KALVIN'                  , snU)    |,       /* 27% misspelled.*/
        abbrev('KERLIN'                  , snU)    |,       /* 18% misspelled.*/
        abbrev('KEVEN'                   , snU)    |,       /*  9% misspelled.*/
        abbrev('KELVIN'                  , snU)       Then sn= "KELVIN"
   When abbrev('LAYDEN'                  , snU)    |,
        abbrev('LEIDEN'                  , snU)       Then sn= "LEIDEN"
   When abbrev('NEUTON'                  , snU)    |,       /*100% misspelled.*/
        abbrev('NEWTON'                  , snU)       Then sn= "NEWTON"
   When abbrev('ORTEL'                   , snU)    |,
        abbrev('OERTEL'                  , snU)       Then sn= "OERTEL"
   When abbrev('PLACK'                   , snU)    |,       /*100% misspelled.*/
        abbrev('PLANC'                   , snU)    |,       /*     misspelled.*/
        abbrev('PLANK'                   , snU)    |,       /*     misspelled.*/
        abbrev('PLANCK'                  , snU)       Then sn= "PLANCK"
   When abbrev('RANKINE'                 , snU, 1)    Then sn= "RANKINE"
   When abbrev('REAUMUR'                 , snU, 2)    Then sn= "REAUMUR"
   When abbrev('RICKTER'                 , snU, 3) |,
        abbrev('RICHTER'                 , snU, 3)    Then sn= "RICHTER"
   When abbrev('RINALDINI'               , snU, 3)    Then sn= "RINALDINI"
   When abbrev('ROEMER'                  , snU, 3) |,
        abbrev('ROMER'                   , snU, 3)    Then sn= "ROMER"
   When abbrev('ROSANTHAL'               , snU, 3) |,
        abbrev('ROSENTHAL'               , snU, 3)    Then sn= "ROSENTHAL"
   When abbrev('RSOL'                    , snU, 2) |,
        abbrev('RSL'                     , snU, 2) |,
        abbrev('ROYALSOCIETYOFLONDON'    , snU, 3) |,
        abbrev('ROYAL-SOCIETY-OF-LONDON' , snU, 3)    Then sn= "ROYAL SOCIETY"
   When abbrev('SAGREDO'                 , snU, 3)    Then sn= "SAGREDO"
   When abbrev('ST.-PATRICE'             , snU, 3) |,
        abbrev('ST.PATRICE'              , snU, 3) |,
        abbrev('SAINTPATRICE'            , snU, 3) |,
        abbrev('SAINT-PATRICE'           , snU, 3)    Then sn= "SAINT-PATRICE"
   When abbrev('STUFFE'                  , snU, 3) |,
        abbrev('STUFE'                   , snU, 3)    Then sn= "STUFE"
   When abbrev('SULTZER'                 , snU, 2) |,
        abbrev('SULZER'                  , snU, 2)    Then sn= "SULZER"
   When abbrev('WEDGEWOOD'               , snU)    |,
        abbrev('WEDGWOOD'                , snU)       Then sn= "WEDGWOOD"
   Otherwise
     sn='***' sn '***'
   End   /*Select*/
Return sn

convert2Fahrenheit: /*convert N --? ºF temperatures. */
/* [?]  fifty-eight temperature scales.*/
Parse Arg n sn
Select
  When sn=='ABSOLUTE'           Then F= n *   9/5      - 459.67
  When sn=='AMONTON'            Then F= n * 8.37209    - 399.163
  When sn=='BARNSDORF'          Then F= n * 6.85714    +   6.85714
  When sn=='BEAUMUIR'           Then F= n * 2.22951    +  32
  When sn=='BENART'             Then F= n * 1.43391    +  31.2831
  When sn=='BERGEN'             Then F=(n + 23.8667)   *  15/14
  When sn=='BRISSEN'            Then F= n *  32/15     +  32
  When sn=='CELSIUS'            Then F= n *   9/5      +  32  /* C -> Celsius.*/
  When sn=='CIMENTO'            Then F= n * 2.70677    -   4.54135
  When sn=='CRUQUIUS'           Then F= n * 0.409266   - 405.992
  When sn=='DALENCE'            Then F= n * 2.7        +  59
  When sn=='DALTON'             Then F=rxCalcexp(rxCalclog(373.15/273.15)*n/100)*9*273.15/5-459.67
--When sn=='DALTON'             Then F=273.15*rxCalcexp(273.15/273.15,n/100)*1.8-459.67
  When sn=='DANIELL'            Then F= n * 7.27194    +  55.9994
  When sn=='DE LA HIRE'         Then F=(n - 3)         /   0.549057
  When sn=='DE LA VILLE'        Then F=(n + 6.48011)   /   0.985568
  When sn=='DELISLE'            Then F=212             -   n * 6/5
  When sn=='DELISLE OLD'        Then F=212             -   n * 1.58590197
  When sn=='DE LUC'             Then F=(n + 14)        *  16/7
  When sn=='DE LYON'            Then F=(n + 17.5)      *  64/35
  When sn=='DE REVILLAS'        Then F=212             -   n * 97/80
  When sn=='DERHAM'             Then F= n / 0.38444386 - 188.578
  When sn=='DERHAM OLD'         Then F= n * 3          +   4.5
  When sn=='DE SUEDE'           Then F=(n + 17.6666)   * 150/83
  When sn=='DE VILLENEUVE'      Then F=(n + 23.7037)   /   0.740741
  When sn=='DU CREST'           Then F=(n + 37.9202)   /   0.650656
  When sn=='EDINBURGH'          Then F= n * 4.6546     -   6.40048
  When sn=='ELECTRON VOLTS'     Then F= n * 20888.1    - 459.67
  When sn=='FAHRENHEIT'         Then F= n
  When sn=='FAHRENHEIT OLD'     Then F= n * 20/11      -  89.2727
  When sn=='FLORENTINE LARGE'   Then F=(n +  7.42857)  /   0.857143
  When sn=='FLORENTINE MAGNUM'  Then F=(n + 73.9736 )  /   1.50659
  When sn=='FLORENTINE SMALL'   Then F=(n -  1.38571)  /   0.378571
  When sn=='FOWLER'             Then F= n * 0.640321   +  53.7709
  When sn=='FRICK'              Then F= n * 200/251    +  58.5339
  When sn=='GASMARK'            Then F= n * 25         + 250
  When sn=='GOUBERT'            Then F= n * 2          +  32
  When sn=='HALES'              Then F= n * 1.2        +  32
  When sn=='HANOW'              Then F= n * 1.06668    -  10.6672
  When sn=='HAUKSBEE'           Then F= n *  18/25     +  88.16
  When sn=='JACOBS-HOLBORN'     Then F= n *  18/71     -  53.4366
  When sn=='K'                  Then F= n *   9/5      - 459.67
  When sn=='KELVIN'             Then F= n *   9/5      - 459.67
  When sn=='LEIDEN'             Then F= n * 1.8        - 423.4
  When sn=='NEWTON'             Then F= n *  60/11     +  32
  When sn=='OERTEL'             Then F= n + n          -  32
  When sn=='PLANCK'             Then F= n * 1.416833e32*   9/5  -  459.67
  When sn=='RANKINE'            Then F= n              - 459.67  /* R -> Rankine.*/
  When sn=='REAUMUR'            Then F= n *   9/4      +  32
  When sn=='RICHTER'            Then F= n * 160/73     -   7.45205
  When sn=='RINALDINI'          Then F= n * 15         +  32
  When sn=='ROMER'              Then F=(n - 7.5) * 27/4+  32
  When sn=='ROSENTHAL'          Then F= n *  45/86     - 453.581
  When sn=='ROYAL SOCIETY'      Then F=(n -122.82)     * -50/69
  When sn=='SAGREDO'            Then F= n * 0.3798     -   5.98
  When sn=='SAINT-PATRICE'      Then F= n * 2.62123    + 115.879
  When sn=='STUFE'              Then F= n * 45         + 257
  When sn=='SULZER'             Then F= n * 1.14595    +  33.2334
  When sn=='THERMOSTAT'         Then F= n * 54         +  32
  When sn=='WEDGWOOD'           Then F= n * 44.7429295 + 516.2
  Otherwise Call serr  'invalid temperature scale: '
  End   /*Select*/
Return F

convert2specific: /*convert ºF --? xxx temperatures.*/

K=(F+459.67)*5/9                       /*compute temperature in kelvin scale. */
a=(1e||(-digits()%2)-digits()%20)      /*minimum number for Dalton temperature*/
eV=(F+459.67)/20888.1                  /*compute the number of electron volts.*/

If ?('ABSOLUTE') Then Call line fn(k) "Absolute"
If ?('AMONTON') Then Call line  fn((F+399.163) / 8.37209 ) "Amonton"
If ?('BARNSDORF') Then Call line fn( ( F - 6.85715) / 6.85715 ) "Barnsdorf"
If ?('BEAUMUIR') Then Call line fn( ( F - 32 ) / 2.22951 ) "Beaumuir"
If ?('BENART') Then Call line fn( ( F - 31.2831 ) / 1.43391 ) "Benart"
If ?('BERGEN') Then Call line fn( ( F * 14/15 ) - 23.8667 ) "Bergen"
If ?('BRISSON') Then Call line fn( ( F - 32 ) * 15/32 ) "Brisson"
If ?('CELSIUS') Then Call line fn( ( F - 32 ) * 5/9 ) "Celsius"
If ?('CIMENTO') Then Call line fn( ( F + 4.54135) / 2.70677 ) "Cimento"
If ?('CRUQUIUS') Then Call line fn( ( F + 405.992 ) / 0.409266 ) "Cruquius"
If ?('DALENCE') Then Call line fn( ( F - 59 ) / 2.7 ) "Dalence"
If ?('DALTON') Then Do
 If K>a Then Call line fn(100*rxCalclog(k/273.15)/rxCalclog(373.15/273.15) ) "Dalton"
 Else Call line right("-infinity        ", 60) "Dalton"
 End
If ?('DANIELL') Then Call line fn( ( F - 55.9994 ) / 7.27194 ) "Daniell"
If ?('DE LA HIRE') Then Call line fn( F * 0.549057 + 3 ) "De la Hire"
If ?('DE LA VILLE') Then Call line fn( F * 0.985568 - 6.48011 ) "De la Ville"
If ?('DELISLE') Then Call line fn( ( 212 - F ) * 5/6 ) "Delisle"
If ?('DELISLE OLD') Then Call line fn( ( 212 - F ) / 1.58590197 ) "Delisle OLD"
If ?('DE LUC') Then Call line fn( F * 7/16 - 14 ) "De Luc"
If ?('DE LYON') Then Call line fn( F * 35/64 - 17.5 ) "De Lyon"
If ?('DE REVILLAS') Then Call line fn( ( 212 - F ) * 80/97 ) "De Revillas"
If ?('DERHAM') Then Call line fn( F * 0.38444386 + 72.4978 ) "Derham"
If ?('DERHAM OLD') Then Call line fn( ( F - 4.5 ) / 3 ) "Derham OLD"
If ?('DE VILLENEUVE') Then Call line fn( F * 0.740741 - 23.7037 ) "De Villeneuve"
If ?('DE SUEDE') Then Call line fn( F * 83/150 - 17.6666 ) "De Suede"
If ?('DU CREST') Then Call line fn( F * 0.650656 - 37.9202 ) "Du Crest"
If ?('EDINBURGH') Then Call line fn( ( F + 6.40048) / 4.6546 ) "Edinburgh"
If ?('ELECTRON VOLTS') Then Call line fn( eV ) "electron volt"s(eV)
If ?('FAHRENHEIT') Then Call line fn( F ) "Fahrenheit"
If ?('FAHRENHEIT OLD') Then Call line fn( F * 20/11 - 89.2727 ) "Fahrenheit OLD"
If ?('FLORENTINE LARGE') Then Call line fn( F * 0.857143 - 7.42857 ) "Florentine large"
If ?('FLORENTINE MAGNUM') Then Call line fn( F * 1.50659 - 73.9736 ) "Florentine Magnum"
If ?('FLORENTINE SMALL') Then Call line fn( F * 0.378571 + 1.38571 ) "Florentine small"
If ?('FOWLER') Then Call line fn( ( F - 53.7709 ) / 0.640321 ) "Fowler"
If ?('FRICK') Then Call line fn( ( F - 58.5338 ) * 251/200 ) "Frick"
If ?('GAS MARK') Then Call line fn( ( F - 250 ) * 0.04 ) "gas mark"
If ?('GOUBERT') Then Call line fn( ( F + 32 ) * 0.5 ) "Goubert"
If ?('HALES') Then Call line fn( ( F - 32 ) / 1.2 ) "Hales"
If ?('HANOW') Then Call line fn( ( F + 10.6672 ) / 1.06668 ) "Hanow"
If ?('HAUKSBEE') Then Call line fn( ( F - 88.16 ) * 25/18 ) "Hauksbee"
If ?('JACOBS-HOLBORN') Then Call line fn( ( F + 53.4366 ) * 71/18 ) "Jacobs-Holborn"
If ?('KELVIN') Then Call line fn( k ) 'KELVIN'
If ?('LEIDEN') Then Call line fn( F / 1.8 + 235.222 ) "Leiden"
If ?('NEWTON') Then Call line fn( ( F - 32 ) * 11/60 ) "Newton"
If ?('OERTEL') Then Call line fn( ( F + 32 ) * 0.5 ) "Oertel"
If ?('PLANCK') Then Call line fn( ( F + 459.67 ) * 5/9 / 1.416833e32 ) "Planck"
If ?('RANKINE') Then Call line fn( F + 459.67 ) "Rankine"
If ?('REAUMUR') Then Call line fn( ( F - 32 ) * 4/9 ) "Reaumur"
If ?('RICHTER') Then Call line fn( ( F + 7.45205) * 73/160 ) "Richter"
If ?('RINALDINI') Then Call line fn( ( F - 32 ) / 15 ) "Rinaldini"
If ?('ROMER') Then Call line fn( ( F - 32 ) * 4/27 + 7.5 ) "Romer"
If ?('ROSENTHAL') Then Call line fn( ( F + 453.581 ) * 86/45 ) "Rosenthal"
If ?('ROYAL SOCIETY') Then Call line fn( F * -69/50 + 122.82 ) "Royal Society of London"
If ?('SAGREDO') Then Call line fn( ( F + 5.98 ) / 0.3798 ) "Segredo"
If ?('SAINT-PATRICE') Then Call line fn( ( F - 115.879 ) / 2.62123 ) "Saint-Patrice"
If ?('STUFE') Then Call line fn( ( F - 257 ) / 45 ) "Stufe"
If ?('SULZER') Then Call line fn( ( F - 33.2334 ) / 1.14595 ) "Sulzer"
If ?('THERMOSTAT') Then Call line fn( ( F - 32 ) / 54 ) "Thermostat"
If ?('WEDGWOOD') Then Call line fn( ( F - 516.2 ) / 44.7429295 ) "Wedgwood"
Return

line:
  If how='FUNCTION' & all=0 Then
    Exit space(arg(1))
  Else
    Say arg(1)
  Return

?:
  Return (arg(1)=toscale | all)

fn: Procedure Expose how result
 showDig=8                                /* only show 8 decimal digs.              */
 number=commas(format(arg(1),,showDig)/1) /* format# 8 digits past . and add commas */
 p=pos('.',number)                        /* find position of the decimal point.    */
                                          /* [?]  align integers with FP numbers.   */
 If p==0 Then                             /* no  decimal point                     .*/
   number=number||left('',5+showDig+1)
 Else                                     /* ddd.ddd                                */
   number=number||left('',5+showDig-length(number)+p)
 Return right(number,max(25,length(number)))/* return the re-formatted argument (#).*/

commas: Procedure
Parse Arg u
a=pos('.',u'.')
e=1
If left(u,1)='-' Then e=2
Do j=a-4 To e by -3
  u=insert(',',u,j)
  End
Return u

s:
 If arg(1)==1 Then Return arg(3)
 Return word(arg(2)'s',1) /*pluralizer.*/

serr:
 If how='FUNCTION' Then
   Exit arg(1)
 Else
   Say arg(1)
 Exit 13

help:
  Say 'use as command:'
  Say 'rexx tcw fromtemp [fromscale] [TO toscale | all],...'
  Say 'or as function'
  Say 'tcw(fromtemp [fromscale] [TO toscale])'
  Exit
::Requires rxmath library
