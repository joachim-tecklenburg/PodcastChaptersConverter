unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Types, Clipbrd;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnChooseSourceFile: TButton;
    btnStartConversion: TButton;
    btnCopyToClipboard: TButton;
    edSourceFilePath: TEdit;
    mPreview: TMemo;
    procedure btnCopyToClipboardClick(Sender: TObject);
    procedure btnStartConversionClick(Sender: TObject);
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
const
  cFileNamePath = '/Users/Nina/Downloads/chapters(1).txt';
var
  fSourceFile: Textfile;
  sOneLine: String;
  //arSplittedText: array[1..2] of String;
  slStringList: TStringList;
  sTitle, sTimeStamp: String;
  i: integer;

begin
  slStringList := TStringList.Create;
  slStringList.LineBreak := '.000';
  //slStringList.StrictDelimiter := True;
  AssignFile(fSourceFile, cFileNamePath);
  reset(fSourceFile);
  mPreview.Clear;
  mPreview.Append('FILE “something.mp3" MP3');
  i := 0;
  while not eof(fSourceFile) do
  begin
    readLn(fSourcefile, sOneLine);
    slStringList.Text := sOneLine;
    sTitle := slStringList[1];
    sTimeStamp := slStringList[0];
    sTimeStamp := convertHoursToMinutes(sTimeStamp);
    mPreview.Append('  TRACK ' + Format('%.*d',[2, i]) + ' AUDIO');

    mPreview.Append('    TITLE “' + sTitle + '"');
    mPreview.Append('    INDEX 01 ' + sTimeStamp);
    i := i + 1;
    slStringList.Clear;
  end;
  CloseFile(fSourceFile);


  slStringList.Free;

end;


procedure TForm1.btnCopyToClipboardClick(Sender: TObject);
begin
  Clipboard.AsText := mPreview.Text;
end;

end.

