program OpenGLTriangle;

{$APPTYPE CONSOLE}

uses
  System.Classes,
  Sample.App,
  Winapi.OpenGL,
  System.UITypes;

type
  TTriangleApp = class(TApplication)
  public
    procedure Initialize; override;
    procedure Update(const ADeltaTimeSec, ATotalTimeSec: Double); override;
    procedure Shutdown; override;
    procedure KeyDown(const AKey: Integer; const AShift: TShiftState); override;
  end;

{ TTriangleApp }

procedure TTriangleApp.Initialize;
begin
  inherited;
  glViewport(0, 0, width, height);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(-30.0, 30.0, -30.0, 30.0, -30.0, 30.0);
  glMatrixMode(GL_MODELVIEW);
end;

procedure TTriangleApp.KeyDown(const AKey: Integer; const AShift: TShiftState);
begin
  inherited;
  if (AKey = vkEscape) then
    Terminate;
end;

procedure TTriangleApp.Shutdown;
begin
  inherited;
  // Writeln('App is Shutdown');
end;

procedure TTriangleApp.Update(const ADeltaTimeSec, ATotalTimeSec: Double);
begin
  inherited;

  glClearColor(0.3, 0.3, 0.3, 0.0);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  glShadeModel(GL_SMOOTH);

  glLoadIdentity();
  glTranslatef(-15.0, -15.0, 0.0);

  glBegin(GL_TRIANGLES);
  glColor3f(1.0, 0.0, 0.0);
  glVertex2f(0.0, 0.0);
  glColor3f(0.0, 1.0, 0.0);
  glVertex2f(30.0, 0.0);
  glColor3f(0.0, 0.0, 1.0);
  glVertex2f(0.0, 30.0);
  glEnd();

  glFlush();
end;

begin
  RunApp(TTriangleApp, 640, 480, 'OpenGL Triangle');
end.
