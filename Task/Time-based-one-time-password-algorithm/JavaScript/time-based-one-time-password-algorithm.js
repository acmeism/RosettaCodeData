// ! npm install crypto
// import crypto from 'crypto';
const crypto = require('crypto');


class TOTP_SHA1 {
    constructor() {
        this.K = null;
        this.generate_key();
    }

    generate_key() {
        /** Generates a random key. */
        // Keys SHOULD be of the length of the HMAC output to facilitate
        // interoperability.
        this.K = crypto.randomBytes(20); // SHA1 digest size is 20 bytes
    }

    hotp(C, digits = 6) {
        /**
         * Calculates the HMAC-based One-Time Password (HOTP).
         *
         * Args:
         *     C: The counter value.
         *     digits: The number of digits in the HOTP (default: 6).
         *
         * Returns:
         *     The HOTP as an integer.
         */

        const hmac_result = crypto.createHmac('sha1', this.K).update(this.longToBytes(C)).digest();
        return this.truncate(hmac_result, digits);
    }


    counter_now(T1 = 30) {
        /**
         * Calculates the counter value based on the current time.
         *
         * Args:
         *     T1: The time step in seconds (default: 30).
         *
         * Returns:
         *     The counter value as an integer.
         */
        const seconds_since_epoch = Math.floor(Date.now() / 1000);
        return Math.floor(seconds_since_epoch / T1);
    }


    _dt(hmac_result) {
        /**
         * Performs dynamic truncation on the HMAC result.
         *
         * Args:
         *     hmac_result: The HMAC result as bytes.
         *
         * Returns:
         *     The dynamically truncated value as an integer.
         */
        const offset = hmac_result[19] & 0xf;
        const bin_code = ((hmac_result[offset] & 0x7f) << 24) |
                         ((hmac_result[offset + 1] & 0xff) << 16) |
                         ((hmac_result[offset + 2] & 0xff) << 8) |
                         (hmac_result[offset + 3] & 0xff);
        return bin_code;
    }

    truncate(hmac_result, digits) {
        /**
         * Truncates the dynamically truncated value to the specified number of digits.
         *
         * Args:
         *     hmac_result: The HMAC result as bytes.
         *     digits: The number of digits in the HOTP.
         *
         * Returns:
         *     The truncated value as an integer.
         */
        const snum = this._dt(hmac_result);
        return snum % (10 ** digits);
    }

    longToBytes(long) {
        // we want to represent the input as a 8-bytes array
        let byteArray = [0, 0, 0, 0, 0, 0, 0, 0];

        for ( let index = 7; index >= 0; index -- ) {
            let byte = long & 0xff;
            byteArray [ index ] = byte;
            long = (long - byte) / 256 ;
        }

        return Buffer.from(byteArray);
    }
}

// Example Usage (if running in a Node.js environment):
if (typeof require !== 'undefined' && require.main === module) {
    const totp = new TOTP_SHA1();
    console.log(totp.hotp(totp.counter_now()));
}
