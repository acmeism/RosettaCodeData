import hmac
import hashlib
import time
import struct
import os
import math

class TOTP_SHA1:
    def __init__(self):
        self.K = None
        self.generate_key()

    def generate_key(self):
        """Generates a random key."""
        # Keys SHOULD be of the length of the HMAC output to facilitate
        # interoperability.
        self.K = os.urandom(hashlib.sha1().digest_size)

    def hotp(self, C: int, digits: int = 6) -> int:
        """
        Calculates the HMAC-based One-Time Password (HOTP).

        Args:
            C: The counter value.
            digits: The number of digits in the HOTP (default: 6).

        Returns:
            The HOTP as an integer.
        """
        hmac_obj = hmac.new(self.K, struct.pack(">Q", C), hashlib.sha1)
        hmac_result = hmac_obj.digest()
        return self.truncate(hmac_result, digits)

    def counter_now(self, T1: int = 30) -> int:
        """
        Calculates the counter value based on the current time.

        Args:
            T1: The time step in seconds (default: 30).

        Returns:
            The counter value as an integer.
        """
        seconds_since_epoch = time.time()
        return int(math.floor(seconds_since_epoch / T1))

    def _dt(self, hmac_result: bytes) -> int:
        """
        Performs dynamic truncation on the HMAC result.

        Args:
            hmac_result: The HMAC result as bytes.

        Returns:
            The dynamically truncated value as an integer.
        """
        offset = hmac_result[19] & 0xf
        bin_code = (hmac_result[offset] & 0x7f) << 24 | \
                   (hmac_result[offset + 1] & 0xff) << 16 | \
                   (hmac_result[offset + 2] & 0xff) << 8 | \
                   (hmac_result[offset + 3] & 0xff)
        return bin_code

    def truncate(self, hmac_result: bytes, digits: int) -> int:
        """
        Truncates the dynamically truncated value to the specified number of digits.

        Args:
            hmac_result: The HMAC result as bytes.
            digits: The number of digits in the HOTP.

        Returns:
            The truncated value as an integer.
        """
        snum = self._dt(hmac_result)
        return snum % (10 ** digits)


if __name__ == "__main__":
    totp = TOTP_SHA1()
    print(totp.hotp(totp.counter_now()))
