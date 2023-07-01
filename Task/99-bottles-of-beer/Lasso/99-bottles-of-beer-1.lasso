local(
    beer = 99,
    song = ''
)
while(#beer > 0) => {
    #song->append(
        #beer + ' bottles of beer on the wall\n' +
        #beer + ' bottles of beer\n' +
        'Take one down, pass it around\n' +
        (#beer-1) + ' bottles of beer on the wall\n\n'
    )
    #beer--
}

#song
