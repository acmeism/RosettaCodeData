typedef struct{
	double focalLength;
	double resolution;
	double memory;
}Camera;

typedef struct{
	double balance;
	double batteryLevel;
	char** contacts;
}Phone;

typedef struct{
	Camera cameraSample;
	Phone phoneSample;
}CameraPhone;
