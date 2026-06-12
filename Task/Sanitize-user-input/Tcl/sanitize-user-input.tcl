#!/usr/bin/env  tclsh

# https://rosettacode.org/wiki/Sanitize_user_input#

# in Tcl  {abc defg} == "abc defg" or  == [list abc defg]
#         [llength {abc def}]          -> 2
#         [string length {abc defg}]   -> 8
#         set a  [lindex {abc defg} 0] -> abc
#         set b  [lindex {abc defg} 1] -> defg
#         [string length $a]           -> 3
#         [string length $b]           -> 4


# -------------------------------------- #
# some utilities

# remove by value
proc lremove {listVariable value} {
    upvar 1 $listVariable var
    set idx [lsearch -exact $var $value]
    set var [lreplace $var $idx $idx]
}

# eliminates duplicate entries in list
proc unique {list} {
  set new {}
    foreach item $list {
	    if {$item ni $new} {lappend new $item}
    }
    return $new
}

# ------------------------------------------- #
# some common variables (namespace scpope)

variable csv_records {}

variable max_name_length 32

variable acceptable_names {}


# these should be fine
set good_names {
    {Douglas Adams}
    {Bill Wither-Spoon}
    {Grahame Greene}
    {Wallace Grommit}
    {Farley Mowat}
    {David Greenstreet}
    {Les Parnas}
    {Alan Parsons}
    {Douglas Adams}
    {Charlie Brown}
    {Peter Pettigrew}
}



# an actual ASCII NULCHAR
set NUL [scan %c "\0"]

# a fp number
set num [expr {3.1415926 * 2.0}]

# these should all fail

set  bad_names {
    {_Bill Fellows}
    {-option root}
    {Robert 1234}
    {""  Smith}
    {}
    {!hola Amigo}
    {His Holiness The Pope}
    {rm "-rf /"}
    {bash myscript.sh}
    {Bobby_McGee}
    {Harold Harold}
    {$num $NUL}
    {username:pass}
}

# substitute values for variables
set bad_names [subst $bad_names]


# these need some special parsing
set marginal_names {
    {Mary,Jane}
    {James T. Kirk}
    {W. W. Wonka}
    {Mr. Alistair Crowely}
    {Sir Lancelot du Lac}
    {Cedric The Entertainer}
    {Dwayne "The Rock" Johnson}
    {Princess Tinker Bell}
    {Mlle Adèle Blanc-Sec}
    {Cpt. Jean-Luc Pecard}
}


# obviously fake names
set fake_names {
    {Miss Kitty Fantastico}
    {Sunshine Superman}
    {Blue Bayou}
    {Lexington Kentucky}
    {Inglorious Bastards}
    {Trouble Comin'}
}


# these are system commands (linux)
# they should not be input strings
variable bad_words {
    abort apt apt-get aptitude add-shell adduser agetty
    alias ar arp arptables as at attr autossh awk axel
    bash blkid bootctl brctl break bsd-csh btattach
    bunzip bunzip2  busybox byobu bzexe bzip2
    cancel capsh cc cd c++ cfdisk cgdisk
    chown chmod chgrp chpasswd chsh chvt
    clang clang++ cmake command cp cpp cpio cppw cupsd curl
    dash dd deb delgroup df disown dget dir display dump
    env eval ethtool exit echo eject efiboot eid enable eutp
    ex exec export extract
    fakeroot find false fdisk filezilla firewall free fsck ftp
    funzip fusermount fwupdate fzsftp
    gcc g++ ls make gmake gnome mkdir passwd run
    halt hash hd hexdump hwclock hy
    ifconfig ifnames init install ip iptables iptunnel iw iwconfig iwspy
    java jar jexec js kill kernel-install keyctl kmod ksh kvm
    ldconfig  ld lftp link login
    mkswap mktemp mmd modprobe mesg  mkfs mount
    named nano nasm nemo netcat newusers newgrp nohup nologin
    node nodejs npm nstat onboard open openssl
    partx partimage partprobe pass passwd patch
    qemu ranlib rarp rbaxh rcp rdx read reboot regedit rename reset return
    rfcomm rfkill rksh rlogin rm rmdir  rmmod rndc rnano route
    rpcbind rpcinfo rpcdebug rrsync rsync rsync-ssl rscreen rsh rstart rstartd
    rtmon rtorrent rtstat runcon runuser run-parts ruscreen
    rvim rview scp screen  script scrot seahorse sed set setcap  setterm service
    sfdisk sftp sgdisk sh shopt shred shutdown
    skill sleep slogin smbclient smbd smbget smbinfo
    smbpasswd smbcontrol snice source sqfscat
    ssh sshd ssh-keygen sshpass startx stat stty
    su sudo  sudoedit sudoers-add sulogin su-to-root
    swapoff swapon switch_root systcl syslinux systemctl systemd
    tar tasksel tasm tcc tclsh tcpdump telinit telnet tgz
    timeshift tmux tnftp tftp tor touch tput tracepath tset tty tzselect tzconfig
    ufw ulimit unzip updatedb useradd userdel usermod username uxterm uz
    vi view vim virt-manager virsh who wine wish wpa_cli wpa_supplicant
    wget xterm xclip xconsole zcat zip zdump
}

# swear words
set more_bad_words {
    {f off}
    {eat sh}
}

# searching is faster if sorted
set bad_words [unique [lsort -ascii $bad_words]]

# these often come before a name
variable honorifics {
    Sir Madame Mr. Mrs. Mlle Ms.
    Hon. Dr. Rev Lady Lord Miss
    lt. Cpt. Maj. Pvt.
    Gov. Sen. Pres.
    King Queen Prince Princess
    The Of
}

# ------------------------------------------- #
# validation functions

# could have a known prefix
proc check_honorific {input} {

    variable honorifics

    set len [llength $input]

    if {$len eq 3} {
	    foreach w $input  {
	        if {$w in $honorifics} {
		        lremove input $w
	       }
	   }
    }
    return $input
}

# detect and remove middle initial (C.)
#  <space><char><period<space>  (\s.\.\s)
proc middle_initial {name} {

    set len [llength $name]

    if {$len eq 3} {
	    if {[regexp {(\s.\.\s)} $name] } {
	        lassign $name  f m l
	        return "${f} ${l}"
	    }
    }
    return $name
}


# if we can correct do it
proc fix_fixable {name} {

    variable honorifics
    set first ""
    set last  ""

    # substitutions
    set delims { {,} { } {:} { } {;} { } {'} { } {|} { } }

    set name [string map -nocase $delims $name] ; # replace delim /w space

    set name [check_honorific $name]

    set name [middle_initial $name]

    return $name
}


# checks the name for {first last}
# with both in proper format
proc check_valid {str} {

    variable max_name_length

    set len [string length $str]

    if {$len eq 0}               {return "\[zero length \]"}
    if {$len > $max_name_length} {return "\[>max length \]"}

    #  count (letter followed by period)
    set period_count [regexp -all {(.\.)} $str]
    if {$period_count > 2}      {return "\[too many initials ($period_count)\]"}

    # string -> list of characters
    set charList [split $str ""]

    # can not start with hypen
    set firstchar [lindex $charList 0]
    # check first char (shortcut)
    switch -regexp $firstchar {

	    -           {return "\[begins with: dash\]"             }

	    [[:alpha:]] {}

	    [[:punct:]] {return "\[begins with: punctuation\]"      }

	    [[:digit:]] {return "\[begins with: digit\]"            }

	    [[:graph:]] {return "\[begins with: utf-8 graph char\]" }

	    [[:space:]] {return "\[begins with: whitespace\]"       }

	    [[:blank:]] {return "\[begins with: blank\]"            }

	    [[:cntrl:]] {return "\[begins with: control char\]"     }

	    default   {return "\[begins with unkown value: $firstchar\]"}
    }

    # check each char for class (long cut)
    set string_checks {integer space punct control }

    foreach char $charList {
	    foreach check $string_checks {

	        if {! [string is alpha $char]} {
		
		        switch $char {
		            - {continue}
		            . {continue}
			        default {return "\[non-alpha\]"}
		        }
	        }

  	        if { [string is $check $char]} {return "\[$check : $char\]"}
  	    }	
    }

    return ok
}


# check basic string format {last first}
# use validate for words
proc sanitize {input} {

    variable bad_words

    # try to fix common fixable problems
    set input [fix_fixable $input]

    # arity of string

    switch [llength $input] {

	    0 {return "\[empty\]"}

	    1 {return "\[1 word: ${input}\]"}
	
	    2 {} ;# 2 is valid

        3 {
	        set input [check_honorific $input]
	
	        if { [llength $input] ne 2 } { return "\[!= 2 words: ${input}\]" }
	     }
	
	    default {return "\[> 2 words: ${input}\]"}
    }


    set last ""

    # do first and last separately
    foreach w $input {

	    if {[llength $w] > 1}   {return "\[> 1 word : ${w}\]"}

	    if {$last eq $w}        {return "\[first == last\]"}

    	set last $w
	
	    set v [check_valid $w]

	    if {$v ne {ok}}         {return $v}

	    set wbad  [lsearch -sorted -ascii $bad_words $w]

	    if { $wbad ne -1 }      {return "\[bad word : ${w}\]"}
    }
    return ok
}

# print out report about the name good of bad

proc validate_list { names } {

    variable acceptable_names

    foreach name $names {	

	set status [sanitize $name]
	
	if { $status eq {ok}} {

	    set out [format "%-*s %-*s" 40 $name 60 "good"]
	    # add to good list
	    lappend acceptable_names $name ; 	
	} else {
	    # mark bad and output explanation for fail
	    set out [format "%-*s %-*s %-*s" 40 $name 10 "bad" 40 $status] 	   		}
	puts  $out
    }
    return ok
}


# 32 dashes
set line32 [string repeat - 32]
	
# --------------------------------------------- #
# "main"

# checks that this file was called as a script

if { [info script] eq $::argv0 } {
    # list of 3 lists
    set nlists [list $good_names $marginal_names $bad_names]

    foreach names $nlists {

	    puts  $line32

	    validate_list $names
    }

    puts  $line32
    puts  "These are acceptable:\n"

    # start the csv database with headers
    set header  "firstname,lastname,id," ; # ... add more fields later

    lappend csv_records $header

    foreach name $acceptable_names {
	
	    # generate random 64bit ID
	    set rnd_id [expr {int(rand() * 0xFFFFFFFF)}]

	    set n [check_honorific $name]
	
	    set fn  [lindex $n 0]
	    set ln  [lindex $n 1]
	    set id $rnd_id

	    set rec "${fn},${ln},${id},"

	    lappend csv_records $rec	
    }

    # printout
    foreach rec $csv_records { puts $rec }

    return 0 ; # return to shell
}

# end
