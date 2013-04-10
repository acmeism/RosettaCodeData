function index = searchCollection(list,searchItem,firstLast)

    %firstLast is a string containing either 'first' or 'last'. The 'first'
    %flag will cause searchCollection to return the index of the first
    %instance of the item being searched. 'last' will cause
    %searchCollection to return the index of the last instance of the item
    %being searched.

    indicies = cellfun(@(x)x==searchItem,list);
    index = find(indicies,1,firstLast);
    assert(~isempty(index),['The string ''' searchItem ''' does not exist in this collection of strings.']);

end
