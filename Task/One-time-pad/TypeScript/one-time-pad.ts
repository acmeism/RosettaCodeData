#!/usr/bin/env node
import { writeFileSync, existsSync, readFileSync, unlinkSync } from 'node:fs';
//https://www.elitizon.com/2021/01-09-how-to-create-a-cli-command-with-typescript/#:~:text=%20Boost%20your%20productivity%20by%20creating%20your%20own,information.%20Required%3A%20string.%20%20...%20%20More%20

const a:string[] = process.argv;
const argv:string[] = a.splice(2)
/**
 *  Extension of the pad files
 */
const padExtension:string = ".1tp";
/**
 * Extension of the key generated
 */
const keyExtension:string = ".key";
/**
 * Array of commands usable
 */
const commands:string[] = ["--generate", "--encrypt","--decrypt"];
/**
 * The alphabet
 */
const stringLetter = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


/**
 * Main function
 */
const main = ():void => {
    // if no args have been give display help
    if(argv.length == 0){
        help();
        return;
    }

    // Check if there is a command in the file
    if(commands.includes(argv[0])){
        let choise = argv[0].trim().toLowerCase();
        if(choise === "--generate"){
                console.log("Generating action chosen");

                // Check if the arguments have been given to generate a new key
                if(!argv[1]){
                    ("Pad name not specified")
                    help();
                    return;
                }

                // Check if the length of the filename is at least 4 characters
                if(argv[1].length <= 3){
                    console.log("The name of the pad should be at least 4 letters long");
                    help();
                    return;
                }

                // Check if the filesize is a number(should be the second argv)
                let fileSize = +argv[2];
                if(isNaN(fileSize)){
                    console.log("File size should be a number");
                    help();
                    return
                }

                createFile(argv[1], fileSize)
        }

        // If the selected action is to encrypt
        if( choise === "--encrypt"){
                console.log("Encrypting action chosen");
                let padDataName = argv[2] ? `${argv[2].trim()}${padExtension}` : `${argv[1].trim()}${padExtension}`

                // Check if the files exist
                if(!argv[1] && !argv[2]){
                    console.log("Parameters not given");
                    help();
                    return;
                }

                // Check if the text file exists and the pad file
                if(!existsSync(`${argv[1].trim().toLowerCase()}.txt`)){
                    console.log("Text file doesn't exit");
                    help();
                    return;
                }

                console.log("Reading file")
                // Get the data from the file as well as the data from the padfile
                let fileDataEnc = readFileSync(`${argv[1].trim().toLowerCase()}.txt`, 'utf-8');

                if(!existsSync(`${argv[2]}${padExtension}`)){
                    console.log("1tp file doesn't exist, generating new 1pt file");
                    createFile(argv[1], fileDataEnc.length);
                }

                console.log("Reading 1pt file");
                // Get the pad data
                let padDataEnc = RetrievePadData(padDataName);

                // if the file 1pt file has been specified but it's not big enough
                if(fileDataEnc.length > padDataEnc.length){
                    console.log("The file is bigger than the 1tp file. Generating a new padfile");
                    createFile(argv[1], fileDataEnc.length);
                    padDataEnc = RetrievePadData(`${argv[1]}${padExtension}`)
                }

                console.log("Converting the file");
                let keyEnc = padFunction(fileDataEnc,padDataEnc);
                createFile(`${argv[1]}.key`, keyEnc.length, false, keyEnc);

        }


        if(choise === "--decrypt"){
                console.log("Decrypting action chosen");

                // Check if the necessary args were given
                if(!argv[1]){
                    console.log("No file specified For decryption specified")
                    return;
                }
                if(!argv[2]){
                    console.log("No 1pt file was given, Please specify the file to use");
                    return;
                }
                if(!argv[3] || argv[3].trim() != '-o') {
                   console.log("No file for output specified");
                }


                let fileNameDec = `${argv[1].trim()}${keyExtension}`;
                let padNameDec = `${argv[2].trim()}${padExtension}`;

                // Check if the files exists or not
                if(!existsSync(fileNameDec)){
                    console.log("File specified does not exist");
                    return;
                }
                if(!existsSync(padNameDec)){
                    console.log("1pt file specified doesn't exist");
                    return;
                }

                console.log("Read the encrypted file");
                let fileDataDec = readFileSync(fileNameDec, 'utf-8');
                console.log("Reading the 1pt file");
                let padDataDec = RetrievePadData(padNameDec);

                // decrypt the file
                console.log("Generating the file");
                let keyDec = padFunction(fileDataDec, padDataDec)


                if(argv[3] && argv[3].trim()==='-o'){
                    let textFileDec = `${argv[1].trim()}.txt`;
                    if(!argv[4]){
                        console.log("No output file specified, creating a new file")
                    }
                    if(argv[4] && argv[4].trim().length < 3){
                        console.log("The name of the output file should be greater than 4 characters");
                        console.log(`Creating new file`)
                    }else {
                        argv[4] ? textFileDec = `${argv[4].trim()}.txt` : textFileDec = `${argv[1].trim()}.txt`
                    }

                    console.log("Generating text file");
                    createFile(textFileDec, 0, false, keyDec );
                    // https://sebhastian.com/javascript-delete-file/
                    console.log("Deleting encrypted file");
                    unlinkSync(fileNameDec);
                    console.log("Deleting 1pt file");
                    unlinkSync(padNameDec);
                }else {
                    console.log("The decrypted file is: \n\n")
                    console.log(keyDec);
                }
        }

    }else {
        console.log("Invalid action");
        help();
        return;
    }

}

/**
 * Display help messages
 */
const help = ():void => {
    console.log("\n\n\n1tp is a tool used to encrypt and decrypt text files");
    console.log("Look at the commands below to learn the use of it");
    console.log("The input file for encryption should be a txt file");
    console.log("The output will be a .kye file and a .1pt file");
    console.log("\n\n**Note: Don't add file extensios while running the command**");
    console.log("**Note: if during creation, the application encouters a file already existing, it will overwrite the file**");
    console.log("Options: ");
    console.log("\t -h | --help \t\t\t\t\t\t\t View help");
    console.log("\t --generate <pad name> <size of file> \t\t\t\t Create a pad file given a size");
    console.log("\t --encrypt <txt file> <pad name> \t\t\t\t Encrypt a file give a pad file");
    console.log("\t\t\t\t All parameters for encryption are required");
    console.log("\t --decrypt <key file> <pad name> -o <txt file>  \t Decrypt a file give a key and 1tp files");
    console.log("\t\t\t\t If output file is not specified it will display the text inside the console");
    console.log("\t\t\t\t If only the `-o` option is defined without a txt file, it will create a new file");
    console.log("\n** Note: Decrypting a file will delete the key and the 1pt files**");
}

/**
 * Create a file with a random key
 * @param file Name of the file being created
 * @param fileSize Size of the file being created
 */
const createFile = (file:string, fileSize:number = 1024, key:boolean = true, data:string = ""):void => {
    let fileName:string;
    if(key){
        fileName = `${file.trim().toLowerCase()}${padExtension}`;

        // https://flaviocopes.com/how-to-check-if-file-exists-node/#:~:text=The%20way%20to%20check%20if%20a%20file%20exists,the%20existence%20of%20a%20file%20without%20opening%20it%3A

        console.log("Generating the One time pad");
        const pad = generateOneTimePad(fileSize);
        //https://code-boxx.com/create-save-files-javascript/#:~:text=%20The%20possible%20ways%20to%20create%20and%20save,the%20server.%0Avar%20data%20%3D%20new%20FormData...%20More%20
        console.log("Writing to file");
        writeFileSync(fileName, pad);
        return;

    }

    console.log("Writing to file");
    writeFileSync(file, data);
};

/**
 * Generate a pad
 * @param fileSize Size of the new pad being created
 * @returns the new pad
 */
const generateOneTimePad = (fileSize:number):string => {
    /**
     * String in which we will put the one time pad
     */
    let otp:string = "";
    /**
     * used to organize the key
     */
    let splitCounter = 0;
    let columnCounter = 0;

    for (let i = 0; i <= fileSize;) {
        if(splitCounter < 6){
            // Generate a random letter from the alphabet given
            otp += (stringLetter.charAt(Math.random()*1000%stringLetter.length))
            splitCounter++;
            i++;
            continue;
        }
        // Used to organize the key so it looks estetic
        if(columnCounter < 7){
            splitCounter = 0;
            columnCounter++;
            otp += ("\t");
            continue;
        }else{
            splitCounter = 0;
            columnCounter = 0;
            otp += ("\n");
            continue;
        }

    }
    return otp
}

/**
 * Get the pad data from the file
 * @returns Text pad data
 */
const RetrievePadData = (padFile:string):string => {
    // Retrieve the pad data
    let padData = ""
    // read the file
    const data = readFileSync(`${padFile}`, 'utf-8')

    // Take out all the tabs and new lines we added while generating the key
    const stringArray = data.toString().split("\n");
    for (let index = 0; index < stringArray.length; index++) {
        const element = stringArray[index].split("\t");
        for (let i = 0; i < element.length; i++) {
            padData += element[i];
        }
    }

    return padData;
}

/**
 * One time pad function
 * @param fileData Data of the file to encrypt or decrypt
 * @param padData Data of the pad file
 * @returns The generated encryption or decryption
 */
const padFunction = (fileData:string, padData:string ):string => {
    let key = "";
    for (let i = 0; i < fileData.length; i++) {
        key += String.fromCharCode(-fileData[i].charCodeAt(0)+padData[i].toLowerCase().charCodeAt(0)+97);
        // console.log(`File char: ${fileData[i]} ${fileData[i].charCodeAt(0)}   Pad Data: ${padData[i]} ${padData[i].toLocaleLowerCase().charCodeAt(0)}   Key: ${key[i]} ${key[i].charCodeAt(0)}`)
    }
    return key;
}

main();
