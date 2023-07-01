class foo_params{
	friend void foo(foo_params p);
public:
    foo_params(int r):
        required_param_(r),
	optional_x_(0),
	optional_y_(1),
	optional_z_(3.1415)
	{}
     foo_params& x(int i){
	optional_x_=i;
	return *this;
     }
     foo_params& y(int i){
	optional_y_=i;
	return *this;
     }
     foo_params& z(float f){
	optional_z_=f;
	return *this;
     }
private:
        int 	required_param_;
	int 	optional_x_;
	int 	optional_y_;
	float 	optional_z_;
};
