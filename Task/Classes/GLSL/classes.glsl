struct Rectangle{
    float width;
    float height;
};

Rectangle new(float width,float height){
    Rectangle self;
    self.width = width;
    self.height = height;
    return self;
}

float area(Rectangle self){
    return self.width*self.height;
}

float perimeter(Rectangle self){
    return (self.width+self.height)*2.0;
}
