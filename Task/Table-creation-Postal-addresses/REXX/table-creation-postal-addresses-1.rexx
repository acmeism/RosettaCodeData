╔════════════════════════════════════════════════════════════════════════════════╗
╟───── Format of an entry in the USA address/city/state/zip code structure:──────╣
║                                                                                ║
║ The "structure" name can be any legal variable name, but here the name will be ║
║ shortened to make these comments (and program) easier to read;  its name will  ║
║ be    @USA     (in any letter case).  In addition, the following variable names║
║ (stemmed array tails)  will need to be kept uninitialized  (that is, not used  ║
║ for any variable name).  To that end, each of these variable names will have an║
║ underscore in the beginning of each name.  Other possibilities are to have a   ║
║ trailing underscore (or both leading and trailing), or some other special eye─ ║
║ catching character such as:   !  @  #  $  ?                                    ║
║                                                                                ║
║ Any field not specified will have a value of "null"  (which has a length of 0).║
║                                                                                ║
║ Any field can contain any number of characters, this can be limited by the     ║
║ restrictions imposed by the standards  or  the USA legal definitions.          ║
║ Any number of fields could be added  (with invalid field testing).             ║
╟────────────────────────────────────────────────────────────────────────────────╣
║  @USA.0             the number of entries in the   @USA  stemmed array.        ║
║                                                                                ║
║       nnn           is some positive integer of any length (no leading zeroes).║
╟────────────────────────────────────────────────────────────────────────────────╣
║  @USA.nnn._name     is the name of person, business,  or a lot description.    ║
╟────────────────────────────────────────────────────────────────────────────────╣
║  @USA.nnn._addr     is the 1st street address                                  ║
║  @USA.nnn._addr2    is the 2nd street address                                  ║
║  @USA.nnn._addr3    is the 3rd street address                                  ║
║  @USA.nnn._addrNN      ···  (any number,  but in sequential order).            ║
╟────────────────────────────────────────────────────────────────────────────────╣
║  @USA.nnn._state    is the USA postal code for the state, terrority, etc.      ║
╟────────────────────────────────────────────────────────────────────────────────╣
║  @USA.nnn._city     is the official city name,  it may include any character.  ║
╟────────────────────────────────────────────────────────────────────────────────╣
║  @USA.nnn._zip      is the USA postal zip code,  five or ten digit format.     ║
╟────────────────────────────────────────────────────────────────────────────────╣
║  @USA.nnn._upHist   is the update history   (who,  date and timestamp).        ║
╚════════════════════════════════════════════════════════════════════════════════╝
