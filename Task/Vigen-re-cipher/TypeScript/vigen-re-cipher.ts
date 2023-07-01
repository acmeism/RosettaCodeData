class Vigenere {

    key: string

    /** Create new cipher based on key */
    constructor(key: string) {
        this.key = Vigenere.formatText(key)
    }

    /** Enrypt a given text using key */
    encrypt(plainText: string): string {
        return Array.prototype.map.call(Vigenere.formatText(plainText), (letter: string, index: number): string => {
            return String.fromCharCode((letter.charCodeAt(0) + this.key.charCodeAt(index % this.key.length) - 130) % 26 + 65)
        }).join('')
    }

    /** Decrypt ciphertext based on key */
    decrypt(cipherText: string): string {
        return Array.prototype.map.call(Vigenere.formatText(cipherText), (letter: string, index: number): string => {
            return String.fromCharCode((letter.charCodeAt(0) - this.key.charCodeAt(index % this.key.length) + 26) % 26 + 65)
        }).join('')
    }

    /** Converts to uppercase and removes non characters */
    private static formatText(text: string): string {
        return text.toUpperCase().replace(/[^A-Z]/g, "")
    }

}

/** Example usage */
(() => {
    let original: string = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."

    console.log(`Original: ${original}`)

    let vig: Vigenere = new Vigenere("vigenere")

    let encoded: string = vig.encrypt(original)

    console.log(`After encryption: ${encoded}`)

    let back: string = vig.decrypt(encoded)

    console.log(`After decryption: ${back}`)

})()
