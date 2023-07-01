xy = {{1,2,3,4},{1,2,3,4},{1,2,3,4}}
yx = feval(@(x) cellfun(@(varargin)[varargin],x{:},'un',0), xy)
