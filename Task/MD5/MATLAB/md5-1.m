function digest = md5(message)
    % digest = md5(message)
    %  Compute the MD5 digest of the message, as a hexadecimal digest.

    % Follow the MD5 algorithm from RFC 1321 [1] and Wikipedia [2].
    %  [1] http://tools.ietf.org/html/rfc1321
    %  [2] http://en.wikipedia.org/wiki/MD5

    % m is the modulus for 32-bit unsigned arithmetic.
    m = 2 ^ 32;

    % s is the shift table for circshift(). Each shift is negative
    % because it is a left shift.
    s = [-7, -12, -17, -22
         -5,  -9, -14, -20
         -4, -11, -16, -23
         -6, -10, -15, -21];

    % t is the sine table. Each sine is a 32-bit integer, unsigned.
    t = floor(abs(sin(1:64)) .* m);

    % Initialize the hash, as a row vector of 32-bit integers.
    digest = [hex2dec('67452301') ...
              hex2dec('EFCDAB89') ...
              hex2dec('98BADCFE') ...
              hex2dec('10325476')];

    % If message contains characters, convert them to ASCII values.
    message = double(message);
    bytelen = numel(message);

    % Pad the message by appending a 1, then appending enough 0s to make
    % the bit length congruent to 448 mod 512. Because we have bytes, we
    % append 128 '10000000', then append enough 0s '00000000's to make
    % the byte length congruent to 56 mod 64.
    message = [message, 128, zeros(1, mod(55 - bytelen, 64))];

    % Convert the message to 32-bit integers, little endian.
    % For little endian, first byte is least significant byte.
    message = reshape(message, 4, numel(message) / 4);
    message = message(1,:) + ...            % least significant byte
              message(2,:) * 256 + ...
              message(3,:) * 65536 + ...
              message(4,:) * 16777216;      % most significant byte

    % Append the bit length as a 64-bit integer, little endian.
    bitlen = bytelen * 8;
    message = [message, mod(bitlen, m), mod(bitlen / m, m)];

    % Process each 512-bit block. Because we have 32-bit integers, each
    % block has 16 elements, message(k + (0:15)).
    for k = 1:16:numel(message)
        % Copy hash.
        a = digest(1); b = digest(2); c = digest(3); d = digest(4);

        % Do 64 operations.
        for i = (1:64)
            % Convert b, c, d to row vectors of bits (0s and 1s).
            bv = dec2bin(b, 32) - '0';
            cv = dec2bin(c, 32) - '0';
            dv = dec2bin(d, 32) - '0';

            % Find f  = mix of b, c, d.
            %      ki = index in 0:15, to message(k + ki).
            %      sr = row in 1:4, to s(sr, :).
            if i <= 16          % Round 1
                f = (bv & cv) | (~bv & dv);
                ki = i - 1;
                sr = 1;
            elseif i <= 32      % Round 2
                f = (bv & dv) | (cv & ~dv);
                ki = mod(5 * i - 4, 16);
                sr = 2;
            elseif i <= 48      % Round 3
                f = xor(bv, xor(cv, dv));
                ki = mod(3 * i + 2, 16);
                sr = 3;
            else                % Round 4
                f = xor(cv, bv | ~dv);
                ki = mod(7 * i - 7, 16);
                sr = 4;
            end

            % Convert f, from row vector of bits, to 32-bit integer.
            f = bin2dec(char(f + '0'));

            % Do circular shift of sum.
            sc = mod(i - 1, 4) + 1;
            sum = mod(a + f + message(k + ki) + t(i), m);
            sum = dec2bin(sum, 32);
            sum = circshift(sum, [0, s(sr, sc)]);
            sum = bin2dec(sum);

            % Update a, b, c, d.
            temp = d;
            d = c;
            c = b;
            b = mod(b + sum, m);
            a = temp;
        end %for i

        % Add hash of this block to hash of previous blocks.
        digest = mod(digest + [a, b, c, d], m);
    end %for k

    % Convert hash from 32-bit integers, little endian, to bytes.
    digest = [digest                % least significant byte
              digest / 256
              digest / 65536
              digest / 16777216];   % most significant byte
    digest = reshape(mod(floor(digest), 256), 1, numel(digest));

    % Convert hash to hexadecimal.
    digest = dec2hex(digest);
    digest = reshape(transpose(digest), 1, numel(digest));
end %md5
