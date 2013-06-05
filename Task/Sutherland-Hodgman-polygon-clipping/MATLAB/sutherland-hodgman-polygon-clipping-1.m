%The inputs are a table of x-y pairs for the verticies of the subject
%polygon and boundary polygon. (x values in column 1 and y values in column
%2) The output is a table of x-y pairs for the clipped version of the
%subject polygon.

function clippedPolygon = sutherlandHodgman(subjectPolygon,clipPolygon)

%% Helper Functions

    %computerIntersection() assumes the two lines intersect
    function intersection = computeIntersection(line1,line2)

        %this is an implementation of
        %http://en.wikipedia.org/wiki/Line-line_intersection

        intersection = zeros(1,2);

        detL1 = det(line1);
        detL2 = det(line2);

        detL1x = det([line1(:,1),[1;1]]);
        detL1y = det([line1(:,2),[1;1]]);

        detL2x = det([line2(:,1),[1;1]]);
        detL2y = det([line2(:,2),[1;1]]);

        denominator = det([detL1x detL1y;detL2x detL2y]);

        intersection(1) = det([detL1 detL1x;detL2 detL2x]) / denominator;
        intersection(2) = det([detL1 detL1y;detL2 detL2y]) / denominator;

    end %computeIntersection

    %inside() assumes the boundary is oriented counter-clockwise
    function in = inside(point,boundary)

        pointPositionVector = [diff([point;boundary(1,:)]) 0];
        boundaryVector = [diff(boundary) 0];
        crossVector = cross(pointPositionVector,boundaryVector);

        if ( crossVector(3) <= 0 )
            in = true;
        else
            in = false;
        end

    end %inside

%% Sutherland-Hodgman Algorithm

    clippedPolygon = subjectPolygon;
    numVerticies = size(clipPolygon,1);
    clipVertexPrevious = clipPolygon(end,:);

    for clipVertex = (1:numVerticies)

        clipBoundary = [clipPolygon(clipVertex,:) ; clipVertexPrevious];

        inputList = clippedPolygon;

        clippedPolygon = [];
        if ~isempty(inputList),
            previousVertex = inputList(end,:);
        end

        for subjectVertex = (1:size(inputList,1))

            if ( inside(inputList(subjectVertex,:),clipBoundary) )

                if( not(inside(previousVertex,clipBoundary)) )
                    subjectLineSegment = [previousVertex;inputList(subjectVertex,:)];
                    clippedPolygon(end+1,1:2) = computeIntersection(clipBoundary,subjectLineSegment);
                end

                clippedPolygon(end+1,1:2) = inputList(subjectVertex,:);

            elseif( inside(previousVertex,clipBoundary) )
                    subjectLineSegment = [previousVertex;inputList(subjectVertex,:)];
                    clippedPolygon(end+1,1:2) = computeIntersection(clipBoundary,subjectLineSegment);
            end

            previousVertex = inputList(subjectVertex,:);
            clipVertexPrevious = clipPolygon(clipVertex,:);

        end %for subject verticies
    end %for boundary verticies
end %sutherlandHodgman
