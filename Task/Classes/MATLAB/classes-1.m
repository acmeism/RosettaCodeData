function GenericClassInstance = GenericClass(varargin)

        if isempty(varargin) %No input arguments
            GenericClassInstance.classVariable = 0; %Generates a struct
        else
            GenericClassInstance.classVariable = varargin{1}; %Generates a struct
        end

        %Converts the struct to a class of type GenericClass
        GenericClassInstance = class(GenericClassInstance,'GenericClass');

end
