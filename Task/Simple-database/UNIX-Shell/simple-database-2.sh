$ sdb create CDs
Create DB `CDs'
$ sdb add CDs Bookends
$ sdb prop CDs Bookends artists "Simon & Garfunkel"
$ sdb add CDs "Ode to joy"
$ sdb prop CDs "Ode to joy" artist "Beethoven"
$ sdb tag CDs Bookends rock folk  # I'm not sure about this
$ sdb tag CDs "Ode to joy" classical
$ sdb show CDs Bookends
Description:

artists:
    Simon & Garfunkel

Tags: folk  rock
$ sdb prop CDs "Ode to joy" Description "Sym. No. 9"
$ sdb show CDs "Ode to joy"
Description:
    Sym. No. 9

artist:
    Beethoven

Tags: classical
$ sdb last-all CDs
Tag: classical
    Ode to joy

Tag: folk
    Bookends

Tag: rock
    Bookends

$ sdb drop CDs
Delete DB `CDs'
$
