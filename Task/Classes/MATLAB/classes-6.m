classdef GenericClass2

    properties
        classVariable
    end %properties

    methods

        %Class constructor
        function objectInstance = GenericClass2(varargin)
            if isempty(varargin) %No input arguments
                objectInstance.classVariable = 0;
            else
                objectInstance.classVariable = varargin{1};
            end
        end

        %Set function
        function setValue(GenericClassInstance,newValue)
            GenericClassInstance.classVariable = newValue;

            %MATLAB magic that changes the object in the scope that called
            %this set function.
            assignin('caller',inputname(1),GenericClassInstance);
        end

    end %methods
end
