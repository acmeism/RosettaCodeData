function testEval
    fprintf('Expressions:\n')
    x = eval('5+10^2')
    eval('y = (x-100).*[1 2 3]')
    eval('z = strcat(''my'', '' string'')')
    try
        w eval(' = 45')
    catch
        fprintf('Runtime error: interpretation of w is a function\n\n')
    end
    % eval('v') = 5
    % Invalid at compile-time as MATLAB interprets as using eval as a variable

    fprintf('Other Statements:\n')
    nl = sprintf('\n');
    eval(['for k = 1:20' nl ...
              'fprintf(''%.3f\n'', k)' nl ...
              'if k == 3' nl ...
                  'break' nl ...
              'end' nl ...
          'end'])
    true == eval('1')
    try
        true eval(' == 1')
    catch
        fprintf('Runtime error: interpretation of == 1 is of input to true\n\n')
    end

    fprintf('Programming on the fly:\n')
    userIn = true;
    codeBlock = '';
    while userIn
        userIn = input('Enter next line of code: ', 's');
        codeBlock = [codeBlock nl userIn];
    end
    eval(codeBlock)
end
