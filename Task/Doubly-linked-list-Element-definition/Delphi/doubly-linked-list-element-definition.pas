struct Node(T) {

type

    pList = ^List ;

    list = record
       data : pointer ;
       prev : pList ;
       next : pList ;
    end;

}
