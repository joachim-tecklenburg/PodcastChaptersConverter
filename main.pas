unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Types, Clipbrd, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnChooseSourceFile: TButton;
    btnStartConversion: TButton;
    btnCopyToClipboard: TButton;
    edSourceFilePath: TEdit;
    lblCopyConfirmation: TLabel;
    Preview: TMemo;
    dlgOpenSourceFile: TOpenDialog;
    TimerCopyConfirmation: TTimer;
    procedure btnChooseSourceFileClick(Sender: TObject);
    procedure btnCopyToClipboardClick(Sender: TObject);
    procedure btnStartConversionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerCopyConfirmationStartTimer(Sender: TObject);
    procedure TimerCopyConfirmationStopTimer(Sender: TObject);
    procedure TimerCopyConfirmationTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function convertHoursToMinutes(sInput: String): String;
var
  slMinutesAndSeconds: TStringList;
  iHours, iMinutes, iSeconds: Integer;
begin
  slMinutesAndSeconds := TStringList.Create;
  slMinutesAndSeconds.LineBreak := ':';
  slMinutesAndSeconds.Text := sInput;
  iHours := StrToInt(slMinutesAndSeconds[0]);
  iMinutes := iHours * 60;
  iMinutes := iMinutes + StrToInt(slMinutesAndSeconds[1]);
  iSeconds := StrToInt(slMinutesAndSeconds[2]);
  result := IntToStr(iMinutes) + ':' + IntToStr(iSeconds) + ':00';

  slMinutesAndSeconds.Clear;
end;

procedure TForm1.btnStartConversionClick(Sender: TObject);
//const
//  cFileNamePath = '';
var
  fSourceFile: Textfile;
  sOneLine: String;
  //arSplittedText: array[1..2] of String;
  slStringList: TStringList;
  sTitle, sTimeStamp: String;
  i: integer;

begin
  //TimerCopyConfirmation.Enabled:=False;
  slStringList := TStringList.Create;
  slStringList.LineBreak := '.000';  //TODO: Allgemeinere Lösung finden
  AssignFile(fSourceFile, edSourceFilePath.Text);
  btnCopyToClipboard.Enabled := True;
  try
    reset(fSourceFile);
     Preview.Clear;
     Preview.Append('FILE “something.mp3" MP3');
     i := 0;
     while not eof(fSourceFile) do
     begin
       readLn(fSourcefile, sOneLine);
       slStringList.Text := sOneLine;
       sTitle := slStringList[1];
       sTimeStamp := slStringList[0];
       sTimeStamp := convertHoursToMinutes(sTimeStamp);
       Preview.Append('  TRACK ' + Format('%.*d',[2, i]) + ' AUDIO');

       Preview.Append('    TITLE “' + sTitle + '"');
       Preview.Append('    INDEX 01 ' + sTimeStamp);
       i := i + 1;
       slStringList.Clear;
     end;
     CloseFile(fSourceFile);
  except
     Preview.Clear;
     showmessage('Could not open File');
  end;
  slStringList.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  lblCopyConfirmation.Visible:=False;
  TimerCopyConfirmation.Enabled:=False;
  Preview.Clear;
end;

procedure TForm1.TimerCopyConfirmationStartTimer(Sender: TObject);
begin
  lblCopyConfirmation.Visible:=True;
end;

procedure TForm1.TimerCopyConfirmationStopTimer(Sender: TObject);
begin

end;


procedure TForm1.TimerCopyConfirmationTimer(Sender: TObject);
begin
  lblCopyConfirmation.Visible:=False;
  TimerCopyConfirmation.Enabled:=False;
end;


procedure TForm1.btnCopyToClipboardClick(Sender: TObject);
begin
  Clipboard.AsText := Preview.Text;
  TimerCopyConfirmation.Enabled:=True;
end;

procedure TForm1.btnChooseSourceFileClick(Sender: TObject);
begin
  if dlgOpenSourceFile.Execute then
begin
  btnStartConversion.Enabled := True;
  edSourceFilePath.Text := dlgOpenSourceFile.FileName;
end;
end;

end.

