﻿unit RiggVar.FZ.Z08_Arc;

interface

uses
  BGRABitmapTypes,
  RiggVar.FD.Elements,
  RiggVar.FD.Drawings;

type
  TRggDrawingZ08 = class(TRggDrawing)
  private
    function GetHelpText: string;
  public
    A: TRggCircle;
    B: TRggCircle;
    C: TRggCircle;
    Alpha: TRggArc;
    HT: TRggLabel;
    constructor Create;
    procedure InitDefaultPos; override;
  end;

implementation

{ TRggDrawingZ08 }

procedure TRggDrawingZ08.InitDefaultPos;
begin
  A.Center.X := 100;
  A.Center.Y := 400;
  A.Center.Z := 0;

  B.Center.X := 400;
  B.Center.Y := 400;
  B.Center.Z := 0;

  C.Center.X := 200;
  C.Center.Y := 200;
  C.Center.Z := 0;
end;

constructor TRggDrawingZ08.Create;
var
  L: TRggLine;
  T: TRggTriangle;
  W: TRggArc;
begin
  inherited;
  Name := 'Z08-Arc';

  HT := TRggLabel.Create;
  HT.Caption := 'HelpText';
  HT.Text := GetHelpText;
  HT.StrokeColor := CssTomato;
  HT.IsMemoLabel := True;
  Add(HT);

  A := TRggCircle.Create;
  A.Caption := 'A';
  A.StrokeColor := CssRed;

  B := TRggCircle.Create;
  B.Caption := 'B';
  B.StrokeColor := CssDodgerblue;

  C := TRggCircle.Create;
  C.Caption := 'C';
  C.StrokeColor := CssLime;

  InitDefaultPos;

  T := TRggTriangle.Create;
  T.Caption := 'ABC';
  T.StrokeColor := CssAliceblue;
  T.Point1 := A;
  T.Point2 := B;
  T.Point3 := C;
  Add(T);

  L := TRggLine.Create('AB');
  L.StrokeColor := CssLime;
  L.Point1 := A;
  L.Point2 := B;
  Add(L);

  L := TRggLine.Create('AC');
  L.StrokeColor := CssDodgerblue;
  L.Point1 := A;
  L.Point2 := C;
  Add(L);

  L := TRggLine.Create('BC');
  L.StrokeColor := CssRed;
  L.Point1 := B;
  L.Point2 := C;
  Add(L);

  W := TRggArc.Create('Alpha');
  W.StrokeColor := CssRed;
  W.Point1 := A;
  W.Point2 := B;
  W.Point3 := C;
  Add(W);

  W := TRggArc.Create('Beta');
  W.StrokeColor := CssDodgerblue;
  W.Point1 := B;
  W.Point2 := C;
  W.Point3 := A;
  Add(W);

  W := TRggArc.Create('Gamma');
  W.StrokeColor := CssLime;
  W.Point1 := C;
  W.Point2 := B;
  W.Point3 := A;
  Add(W);

  Add(A);
  Add(B);
  Add(C);

  DefaultElement := C;
end;

function TRggDrawingZ08.GetHelpText: string;
begin
  ML.Add('Arc test sample.');
  ML.Add('');
  ML.Add('How to move caption text may be different between elements.');
  ML.Add('  Arc has caption position radius mapped to Shift-Wheel.');

  result := ML.Text;
  ML.Clear;
end;

end.
