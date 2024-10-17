unit main;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  System.SyncObjs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    mmo1: TMemo;
    btn1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FMutex: TMutex;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FMutex := TMutex.Create();
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FMutex.Free;
end;

// http://edgarpavao.com/2017/08/07/multithreading-e-processamento-paralelo-no-delphi-ppl/
procedure TForm1.btn1Click(Sender: TObject);
begin
//Thread 1
  TThread.CreateAnonymousThread(
    procedure
    begin
      FMutex.Acquire;
      try
        TThread.Sleep(5000);
        TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            mmo1.Lines.Add('Thread 1');
          end);
      finally
        FMutex.Release;
      end;
    end).Start;

  //Thread 2
  TThread.CreateAnonymousThread(
    procedure
    begin
      FMutex.Acquire;
      try
        TThread.Sleep(1000);
        TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            mmo1.Lines.Add('Thread 2');
          end);
      finally
        FMutex.Release;
      end;
    end).Start;

  //Thread 3
  TThread.CreateAnonymousThread(
    procedure
    begin
      FMutex.Acquire;
      try
        TThread.Sleep(3000);
        TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            mmo1.Lines.Add('Thread 3');
          end);
      finally
        FMutex.Release;
      end;
    end).Start;
end;

end.
