%Bitmap class
%
%Implements a class to manage bitmap images without the need for the
%various conversion and display functions
%
%Available functions:
%
%fill(obj,color)
%setPixel(obj,pixel,color)
%getPixel(obj,pixel,[optional: color channel])
%display(obj)
%disp(obj)
%plot(obj)
%image(obj)
%save(obj)
%open(obj)

classdef Bitmap

    %% Public Properties
    properties

        %Channel arrays
        red;
        green;
        blue;

    end

    %% Public Methods
    methods

        %Creates image and defaults it to black
        function obj = Bitmap(width,height)
            obj.red   = zeros(height,width,'uint8');
            obj.green = zeros(height,width,'uint8');
            obj.blue  = zeros(height,width,'uint8');
        end % End Bitmap Constructor

        %Fill the image with a specified color
        %color = [red green blue] max for each is 255
        function fill(obj,color)
            obj.red(:,:)   = color(1);
            obj.green(:,:) = color(2);
            obj.blue(:,:)  = color(3);
            assignin('caller',inputname(1),obj); %saves the changes to the object
        end

        %Set a pixel to a specified color
        %pixel = [x y]
        %color = [red green blue]
        function setPixel(obj,pixel,color)
            obj.red(pixel(2),pixel(1))   = color(1);
            obj.green(pixel(2),pixel(1)) = color(2);
            obj.blue(pixel(2),pixel(1))  = color(3);
            assignin('caller',inputname(1),obj); %saves the changes to the object
        end

        %Get pixel color
        %pixel = [x y]
        %varargin can be:
        %  no input for all channels
        %  'r' or 'red' for red channel
        %  'g' or 'green' for green channel
        %  'b' or 'blue' for blue channel
        function color = getPixel(obj,pixel,varargin)

            if( ~isempty(varargin) )
                switch (varargin{1})
                    case {'r','red'}
                        color = obj.red(pixel(2),pixel(1));
                    case {'g','green'}
                        color = obj.red(pixel(2),pixel(1));
                    case {'b','blue'}
                        color = obj.red(pixel(2),pixel(1));
                end
            else
                color = [obj.red(pixel(2),pixel(1)) obj.green(pixel(2),pixel(1)) obj.blue(pixel(2),pixel(1))];
            end

        end

        %Display the image
        %varargin can be:
        %  no input for all channels
        %  'r' or 'red' for red channel
        %  'g' or 'green' for green channel
        %  'b' or 'blue' for blue channel
        function display(obj,varargin)

            if( ~isempty(varargin) )
                switch (varargin{1})
                    case {'r','red'}
                        image(obj.red)
                    case {'g','green'}
                        image(obj.green)
                    case {'b','blue'}
                        image(obj.blue)
                end

                colormap bone;
            else
                bitmap = cat(3,obj.red,obj.green,obj.blue);
                image(bitmap);
            end
        end

        %Overload several commonly used display functions
        function disp(obj,varargin)
            display(obj,varargin{:});
        end

        function plot(obj,varargin)
            display(obj,varargin{:});
        end

        function image(obj,varargin)
            display(obj,varargin{:});
        end

        %Saves the image
        function save(obj)

            %Open file dialogue
            [fileName,pathName,success] = uiputfile({'*.bmp','Bitmap Image (*.bmp)'},'Save Bitmap As');

            if( not(success == 0) )
                imwrite(cat(3,obj.red,obj.green,obj.blue),[pathName fileName],'bmp'); %Write image file to disk
                disp('Save Complete');
            end
        end

        %Opens an image and overwrites what is currently stored
        function success = open(obj)

            %Open file dialogue
            [fileName,pathName,success] = uigetfile({'*.bmp','Bitmap Image (*.bmp)'},'Open Bitmap ');

            if( not(success == 0) )

                channels = imread([pathName fileName], 'bmp'); %returns color indexed data

                %Store each channel
                obj.red   = channels(:,:,1);
                obj.green = channels(:,:,2);
                obj.blue  = channels(:,:,3);

                assignin('caller',inputname(1),obj); %saves the changes to the object
                success = true;
                return
            else
                success = false;
                return
            end
        end


    end %methods
end %classdef
