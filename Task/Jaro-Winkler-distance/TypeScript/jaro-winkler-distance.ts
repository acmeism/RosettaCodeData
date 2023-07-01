var fs = require('fs')

// Jaro Winkler Distance Formula
function jaroDistance(string1: string, string2: string): number{
    // Compute Jaro-Winkler distance between two string
    // Swap strings if string1 is shorter than string 2
    if (string1.length < string2.length){
        const tempString: string = string1;
        string1 = string2;
        string2 = tempString
    }
    let len1: number = string1.length
    let len2: number = string2.length
    if (!len2){
        return 0.0
    }
    const delta: number = Math.max(1, len1 / 2.0) - 1.0;
    // Flags for transpositions
    let flag: boolean[] = Array(len2).fill(false)
    let ch1Match: string[] = Array(len1).fill('')
    // Count number of matching characters
    let matches = 0
    // Check if characters on both string matches
    for (let i: number = 0; i < len1; i++){
            const ch1: string = string1[i]
            for (let j = 0; j < len2; j++){
                const ch2: string = string2[j]
                if (j <= i + delta && j + delta >= 1 && ch1 == ch2 && !flag[j]){
                    flag[j] = true
                    ch1Match[matches++] = ch1;
                    break;
                }
            }
    }
    if (!matches){
        return 1.0
    }
    // Count number of transpositions (shared characters placed in different positions)
    let transpositions: number = 0.0
    for (let i: number = 0, j: number = 0; j < len2; j++){
            if (flag[j]){
                if (string2[j] != ch1Match[i]){
                    transpositions++
                }
                i++
            }
    }
    const m: number = matches
    // Jaro Similarity Formula simj = ( (m / length of s1) + (m / length of s2) + (m - t) / m ) / 3
    const jaro: number = (m / len1 + m / len2 + (m - transpositions / 2.0) / m) / 3.0
    // Length of common prefix between string up to 4 characters
    let commonPrefix: number = 0.0
    len2 = Math.min(4, len2)
    for (let i: number = 0; i < len2; i++){
        if (string1[i] == string2[i]){
            commonPrefix++
        }
    }
    // Jaro Winkler Distance Formula simw = simj + lp(1 - simj)
    return 1.0 - (jaro + commonPrefix * 0.1 * (1.0 - jaro))
}

// Compute Jaro Winkler Distance for every word on the dictionary against the misspelled word
function withinDistance(words: string[] ,maxDistance: number, string: string, maxToReturn: number): (string | number)[][]{
    let result: (string | number)[][]  = new Array()
    words.forEach(word =>{
        const distance = jaroDistance(word, string)
        // check if computed jaro winkler distance is within the set distance parameter
        if (distance <= maxDistance){
            const tuple = [distance, word]
            result.push(tuple)
        }
    })
    result.sort()
    // Limit of matches set to maxtoReturn
    return result.length <= maxToReturn ? result : result.slice(0, maxToReturn)
}

function loadDictionary(fileName: string): string[]{
    let words: string[] = new Array()
    try{
        //attacomsian.com/blog/reading-a-file-line-by-line-in-nodejs
        const data = fs.readFileSync(fileName, 'utf-8')
        const lines: string[] = data.split(/\r?\n/)
        lines.forEach(line => {
            words.push(line)
        })
        return words
    }
    catch(error){
        console.log("Error reading dictionary")
    }
}

function main(): void{
    try {
        const misspellings = [
            "accomodate​",
            "definately​",
            "goverment",
            "occured",
            "publically",
            "recieve",
            "seperate",
            "untill",
            "wich"
        ]
        //unixdict.txt from users.cs.duke.edu/~ola/ap/linuxwords
        let words: string[] = loadDictionary("unixdict.txt")

        misspellings.forEach(spelling =>{
            console.log("Misspelling:", spelling)
            const closeWord = withinDistance(words, 0.15, spelling, 5)
            closeWord.forEach(word =>{
                console.log((word[0] as number).toFixed(4) + " " + word[1])
            })
            console.log("")
        })
    }
    catch(error) {
        console.log("Error on main")
    }
}
main();
