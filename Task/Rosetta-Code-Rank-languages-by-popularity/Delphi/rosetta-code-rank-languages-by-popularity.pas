program Rank_languages_by_popularity;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  IdHttp,
  IdBaseComponent,
  IdComponent,
  IdIOHandler,
  IdIOHandlerSocket,
  IdIOHandlerStack,
  IdSSL,
  IdSSLOpenSSL,
  System.RegularExpressions,
  System.Generics.Collections,
  System.Generics.Defaults;

const
  AURL = 'https://www.rosettacode.org/mw/index.php?title=Special:Categories&limit=5000';
  UserAgent =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36';

type
  TPair = record
    Language: string;
    Users: Integer;
    constructor Create(lang, user: string);
  end;

  TPairs = TList<TPair>;


  { TPair }

constructor TPair.Create(lang, user: string);
begin
  Language := lang;
  Users := StrToIntDef(user, 0);
end;

function GetFullCode: string;
begin
  with TIdHttp.create(nil) do
  begin
    HandleRedirects := True;
    Request.UserAgent := UserAgent;
    IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    Result := Get(AURL);
    IOHandler.Free;
    Free;
  end;
end;

function GetList(const Code: string): TPairs;
var
  RegularExpression: TRegEx;
  Match: TMatch;
  language, users: string;
begin
  Result := TPairs.Create;

  RegularExpression.Create('>(?<LANG>[^<,;]*)<\/a>.. \((?<USERS>[,\d]*)');
  Match := RegularExpression.Match(Code);

  while Match.Success do
  begin
    users := Match.Groups.Item['USERS'].Value.Replace(',', '');
    language := Match.Groups.Item['LANG'].Value;

    Result.Add(TPair.Create(language, users));
    Match := Match.NextMatch;
  end;
end;

procedure Sort(List: TPairs);
begin
  List.Sort(TComparer<TPair>.Construct(
    function(const Left, Right: TPair): Integer
    begin
      result := Right.Users - Left.Users;
      if result = 0 then
        result := CompareText(Left.Language, Right.Language);
    end));
end;

function SumUsers(List: TPairs): Cardinal;
var
  p: TPair;
begin
  Result := 0;
  for p in List do
  begin
    Inc(Result, p.Users);
  end;
end;

var
  Data: TStringList;
  Code, line: string;
  List: TPairs;
  i: Integer;

begin
  Data := TStringList.Create;
  Writeln('Downloading code...');

  Code := GetFullCode;
  data.Clear;

  List := GetList(Code);

  Sort(List);

  Writeln('Total languages: ', List.Count);
  Writeln('Total Users: ', SumUsers(List));
  Writeln('Top 10:'#10);

  for i := 0 to List.Count - 1 do
  begin
    line := Format('%5dth %5d %s', [i + 1, List[i].users, List[i].language]);
    Data.Add(line);
    if i < 10 then
      Writeln(line);
  end;

  Data.SaveToFile('Rank.txt');
  List.Free;
  Data.Free;

  Readln;
end.
