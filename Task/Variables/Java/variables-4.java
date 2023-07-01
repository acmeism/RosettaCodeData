final String x = "blah";
final String y;
final double[] nums = new double[15];
y = "test";
x = "blahblah"; //not legal
nums[5] = 2.5; //legal
nums = new double[10]; //not legal
final Date now = new java.util.Date();
now.setTime(1234567890); //legal
now = new Date(1234567890); //not legal
