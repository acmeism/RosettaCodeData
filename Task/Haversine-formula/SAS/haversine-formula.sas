options minoperator;

%macro haver(lat1, long1, lat2, long2, type=D, dist=K);

	%if %upcase(&type) in (D DEG DEGREE DEGREES) %then %do;
		%let convert = constant('PI')/180;
		%end;
	%else %if %upcase(&type) in (R RAD RADIAN RADIANS) %then %do;
		%let convert = 1;
		%end;
	%else %do;
		%put ERROR - Enter RADIANS or DEGREES for type.;
		%goto exit;
		%end;

	%if %upcase(&dist) in (M MILE MILES) %then %do;
		%let distrat = 1.609344;
		%end;
	%else %if %upcase(&dist) in (K KM KILOMETER KILOMETERS) %then %do;
		%let distrat = 1;
		%end;
	%else %do;
		%put ERROR - Enter M on KM for dist;
		%goto exit;
		%end;
		
		data _null_;
			convert = &convert;
			lat1 = &lat1 * convert;
			lat2 = &lat2 * convert;
			long1 = &long1 * convert;
			long2 = &long2 * convert;

			diff1 = lat2 - lat1;
			diff2 = long2 - long1;

			part1 = sin(diff1/2)**2;
			part2 = cos(lat1)*cos(lat2);
			part3 = sin(diff2/2)**2;

			root = sqrt(part1 + part2*part3);

			dist = 2 * 6372.8 / &distrat * arsin(root);

			put "Distance is " dist "%upcase(&dist)";
		run;

	%exit:
%mend;

%haver(36.12, -86.67, 33.94, -118.40);
