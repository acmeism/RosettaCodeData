function [mNumber,mersennesPrime] = mersennePrimes()

    function isPrime = lucasLehmerTest(thePrime)

        llResidue = 4;
        mersennesPrime = (2^thePrime)-1;

        for i = ( 1:thePrime-2 )
            llResidue = mod( ((llResidue^2) - 2),mersennesPrime );
        end

        isPrime = (llResidue == 0);

    end

    %Because IEEE764 Double is the highest precision number we can
    %represent in MATLAB, the highest Mersenne Number we can test is 2^52.
    %In addition, because we have this cap, we can only test up to the
    %number 30 for Mersenne Primeness. When we input 31 into the
    %Lucas-Lehmer test, during the computation of the residue, the
    %algorithm multiplies two numbers together the result of which is
    %greater than 2^53. Because we require every digit to be significant,
    %this leads to an error. The Lucas-Lehmer test should say that M31 is a
    %Mersenne Prime, but because of the rounding error in calculating the
    %residues caused by floating-point arithmetic, it does not. So M30 is
    %the largest number we test.

    mNumber = (3:30);

    [isPrime] = arrayfun(@lucasLehmerTest,mNumber);

    mNumber = [2 mNumber(isPrime)];
    mersennesPrime = (2.^mNumber) - 1;

end
