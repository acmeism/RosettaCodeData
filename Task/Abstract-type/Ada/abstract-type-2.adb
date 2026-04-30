type Scheduler is task interface;
procedure Plan (Manager : in out Scheduler; Activity : in out Job) is abstract;
