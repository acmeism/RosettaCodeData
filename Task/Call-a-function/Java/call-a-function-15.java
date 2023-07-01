int myMethod( Map<String,Object> params ){
    return
       ((Integer)params.get("x")).intValue()
       + ((Integer)params.get("y")).intValue();
}
