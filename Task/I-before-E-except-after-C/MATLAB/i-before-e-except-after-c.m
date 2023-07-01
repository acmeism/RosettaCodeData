function iBeforeE()
check('http://wiki.puzzlers.org/pub/wordlists/unixdict.txt');
fprintf('\n');
check('http://ucrel.lancs.ac.uk/bncfreq/lists/1_2_all_freq.txt');
end

function check(URL)
fprintf('For %s:\n', URL)
[~, name, ext] = fileparts(URL);
fn = [name ext];
if exist(fn,'file')
    lines = readlines(fn, 'EmptyLineRule', 'skip');
else
    fprintf('Reading data from %s\n', URL)
    lines = readlines(URL, 'EmptyLineRule', 'skip');
    % Save the file for later
    writelines(lines,fn);
end
includesFrequencyData = length(split(lines(1))) > 1;
ie = 0;
cie = 0;
ei = 0;
cei = 0;
for i = 1:size(lines,1)
    if includesFrequencyData
        fields = split(strtrim(lines(i)));
        if length(fields) ~= 3 || i == 1
            continue;
        end
        word = fields(1);
        frequency = str2double(fields(3));
    else
        word = lines(i);
        frequency = 1;
    end
    ie = ie + length(strfind(word,'ie')) * frequency;
    ei = ei + length(strfind(word,'ei')) * frequency;
    cie = cie + length(strfind(word,'cie')) * frequency;
    cei = cei + length(strfind(word,'cei')) * frequency;
end
rule1 =  "I before E when not preceded by C";
p1 = reportPlausibility(rule1, ie-cie, ei-cei );
rule2 =  "E before I when preceded by C";
p2 = reportPlausibility(rule2, cei, cie );
combinedRule = "I before E, except after C";
fprintf('Hence the combined rule \"%s\" is ', combinedRule);
if ~(p1 && p2)
    fprintf('NOT ');
end
fprintf('PLAUSIBLE.\n');
end

function plausible = reportPlausibility(claim, positive, negative)
plausible = true;
fprintf('\"%s\" is ', claim);
if positive <= 2*negative
    plausible = false;
    fprintf('NOT ')
end
fprintf('PLAUSIBLE,\n  since the ratio of positive to negative examples is %d/%d = %0.2f.\n', positive, negative, positive/negative )
end
