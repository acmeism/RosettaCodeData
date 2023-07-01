function beerSong(){
    function nbottles(howMany:number){
        return `${howMany?howMany:'no'} bottle${howMany!=1?'s':''}`;
    }
    let song=[];
    let beer = 99;
    while (beer > 0) {
        song.push(`
            ${nbottles(beer)} of beer on the wall,
            ${nbottles(beer)} of beer!
            Take one down, pass it around
            ${nbottles(--beer)} of beer on the wall
        `);
    }
    return song.join('');
}

console.log(beerSong());
