clear all;close all;clc;
cidrCanonicalizer();

function cidrCanonicalizer
    % Main function to test CIDR canonicalization

    % Define test cases
    testCases = {
        '36.18.154.103/12', '36.16.0.0/12';
        '62.62.197.11/29', '62.62.197.8/29';
        '67.137.119.181/4', '64.0.0.0/4';
        '161.214.74.21/24', '161.214.74.0/24';
        '184.232.176.184/18', '184.232.128.0/18'
    };

    % Run test cases
    for i = 1:size(testCases, 1)
        ip = testCases{i, 1};
        expected = testCases{i, 2};
        result = canonicalize(ip);
        fprintf('%s -> %s\n', ip, result);
        assert(strcmp(result, expected));
    end
end

function result = dottedToInt(dotted)
    % Convert dotted IP to integer representation
    parts = str2double(strsplit(dotted, '.'));
    result = sum(parts .* (256 .^ (3:-1:0)));
end

function result = intToDotted(ip)
    % Convert integer IP to dotted representation
    result = strjoin(arrayfun(@(x) num2str(bitshift(bitand(ip, bitshift(255, x)), -x)), [24 16 8 0], 'UniformOutput', false), '.');
end

function result = networkMask(numberOfBits)
    % Create a network mask for the given number of bits
    result = bitshift((bitshift(1, numberOfBits) - 1), (32 - numberOfBits));
end

function result = canonicalize(ip)
    % Canonicalize the given CIDR IP
    [dotted, networkBits] = strtok(ip, '/');
    networkBits = str2double(strrep(networkBits, '/', ''));
    i = dottedToInt(dotted);
    mask = networkMask(networkBits);
    result = strcat(intToDotted(bitand(i, mask)), '/', num2str(networkBits));
end
