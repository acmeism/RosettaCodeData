function [morseText,morseSound] = text2morse(string,playSound)

%% Translate AlphaNumeric Text to Morse Text

    string = lower(string);

    %Defined such that the ascii code of the characters in the string map
    %to the indecies of the dictionary.
    morseDictionary = {{' ',' '},{'',''},{'',''},{'',''},...
                       {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                       {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                       {'0','-----'},{'1','.----'},{'2','..---'},{'3','...--'},...
                       {'4','....-'},{'5','.....'},{'6','-....'},{'7','--...'},...
                       {'8','---..'},{'9','----.'},...
                       {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                       {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                       {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                       {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                       {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                       {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                       {'',''},{'',''},{'',''},...
                       {'a','.-'},{'b','-...'},{'c','-.-.'},{'d','-..'},...
                       {'e','.'},{'f','..-.'},{'g','--.'},{'h','....'},...
                       {'i','..'},{'j','.---'},{'k','-.-'},{'l','.-..'},...
                       {'m','--'},{'n','-.'},{'o','---'},{'p','.--.'},...
                       {'q','--.-'},{'r','.-.'},{'s','...'},{'t','-'},...
                       {'u','..-'},{'v','...-'},{'w','.--'},{'x','-..-'},...
                       {'y','-.--'},{'z','--..'}};

    %Iterates through each letter in the string and converts it to morse
    %code
    morseText = arrayfun(@(x)[morseDictionary{x}{2} '|'],(string - 31),'UniformOutput',false);

    %The output of the previous operation is a cell array, we want it to be
    %a string. This line accomplishes that.
    morseText = cell2mat(morseText);

    morseText(end) = []; %delete extra pipe

%% Translate Morse Text to Morse Audio

    %Generate the tones for each element of the code
    SamplingFrequency = 8192; %Hz
    ditLength = .1; %s
    dit = (0:1/SamplingFrequency:ditLength);
    dah = (0:1/SamplingFrequency:3*ditLength);
    dit = sin(3520*dit);
    dah = sin(3520*dah);
    silent = zeros(1,length(dit));

    %A dictionary of the audio components of each symbol
    morseTiming = {{'.',[dit silent]},{'-',[dah silent]},{'|',[silent silent]},{' ',[silent silent]}};
    morseSound = [];

    for i = (1:length(morseText))

        %Iterate through each cell in the morseTiming cell array and
        %find which timing sequence corresponds to the current morse
        %text symbol.
        cellNum = find(cellfun(@(x)(x{1}==morseText(i)),morseTiming));

        morseSound = [morseSound morseTiming{cellNum}{2}];
    end

    morseSound(end-length(silent):end) = []; %Delete the extra silent tone at the end

    if(playSound)
        sound(morseSound,SamplingFrequency); %Play sound
    end

end %text2morse
