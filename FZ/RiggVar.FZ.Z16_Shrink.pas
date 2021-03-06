﻿unit RiggVar.FZ.Z16_Shrink;

interface

uses
  SysUtils,
  Classes,
  Math,
  BGRABitmapTypes,
  RiggVar.FD.Point,
  RiggVar.FD.Elements,
  RiggVar.FD.Drawings;

type
  TRggDrawingZ16 = class(TRggDrawingKK)
  private
    ox, oy: single;
    SegmentCount: Integer;
    Count: Integer;
    MastLength: single;
    Radius: single;
    ComputedPhi: single;
    Counter: Integer;
    Branch: Integer;
    procedure ComputePhi(l, s: single);
    function GetHelpText: string;
  public
    A: TRggCircle;
    B: TRggCircle;
    M: TRggCircle;
    T: TRggCircle;

    MT: TRggLine;
    AB: TRggPolyLine3D;

    Bem: TRggLabel;

    HT: TRggLabel;

    constructor Create;
    procedure InitDefaultPos; override;
    procedure Compute; override;
    procedure Transform(AM: TMatrix3D); override;
  end;

implementation

{ TRggDrawingZ16 }

procedure TRggDrawingZ16.InitDefaultPos;
begin
  ox := 400;
  oy := 650;

  A.Center.X := ox;
  A.Center.Y := oy;
  A.Center.Z := 0;
  A.Save;

  B.Center.X := ox;
  B.Center.Y := oy - 440;
  B.Center.Z := 0;
  B.Save;
end;

procedure TRggDrawingZ16.Transform(AM: TMatrix3D);
begin
  inherited;
  AB.Transform;
end;

procedure TRggDrawingZ16.Compute;
var
  l: single;
  d: single;

  r: single;
  phi: single;
  deltaPhi: single;
  tempPhi: single;

  i: Integer;

  alpha: single;
  Temp: TPoint3D;

  P: TRggPoint3D;
begin
  l := AB.LineLength;
  d := MastLength - l;

  T.Center.C := AB.Point2.Center.C + (AB.Point2.Center.C - AB.Point1.Center.C) * -0.5;
  M.Center := T.Center;

  if (l > MastLength - 1) or (d < 1) then
  begin
    AB.ShowPoly := False;
    Branch := 1;
    Bem.Text := 'branch = ' + IntToStr(Branch);
    AB.StrokeThickness := 1;
    AB.StrokeColor := CssGray;
    Exit;
  end;

  AB.ShowPoly := True;

  r := Radius;
  SKK.Radius1 := r;
  SKK.Radius2 := r;
  SKK.MittelPunkt1 := A.Center.C;
  SKK.MittelPunkt2 := B.Center.C;
  M.Center.C := SKK.SchnittPunkt2;

  ComputePhi(MastLength, d);

  r := l / 2 / ComputedPhi;
  if (Counter > 0) and (r > (l / 2) + 0.1) then
  begin
    SKK.Radius1 := r;
    SKK.Radius2 := r;
    M.Center.C := SKK.SchnittPunkt2;
    phi := arcsin(l / 2 / r);
    Branch := 2;
    AB.StrokeThickness := 2;
    AB.StrokeColor := CssDodgerblue;
  end
  else
  begin
    r := (l / 2) + 0.1;
    SKK.Radius1 := r;
    SKK.Radius2 := r;
    M.Center.C := SKK.SchnittPunkt2;
    phi := arcsin(l / 2 / r);
    Branch := 3;
    AB.StrokeThickness := 1;
    AB.StrokeColor := CssRed;
  end;

  deltaPhi := 2 * phi / SegmentCount;

  Temp := T.Center.C - M.Center.C;
  alpha := arctan2(Temp.Y, Temp.X);
  Bem.Text := Format('branch = %d, alpha = %.2f, %.2f, counter = %d', [
    Branch,
    RadToDeg(alpha),
    RadToDeg(ComputedPhi),
    Counter]);

  tempPhi := -phi;
  for i := 0 to Count-1 do
  begin
    P.X := r * cos(tempPhi);
    P.Y := r * sin(tempPhi);
    P.Z := 0;
    P := P.Rotate(alpha);
    P.C := M.Center.C + P.C;
    AB.Poly[i].X := Round(P.X);
    AB.Poly[i].Y := Round(P.Y);
    if AB.WantRotation then
    begin
      AB.RggPoly[i].X := AB.Poly[i].X;
      AB.RggPoly[i].Y := AB.Poly[i].Y;
      AB.RggPoly[i].Z  := 0;
    end;
    tempPhi := tempPhi + deltaPhi;
  end;
end;

procedure TRggDrawingZ16.ComputePhi(l, s: single);
var
  i: Integer;
  phi: single;
  u, v: single;
begin
  u := l / (l-s);
  ComputedPhi := 0;
  Counter := 0;
  for i := 1 to 200 do
  begin
    phi := DegToRad(i);
    v := phi - u * sin(phi);
    if v > 0 then
    begin
      Counter := i;
      ComputedPhi := phi;
      break;
    end;
  end;
end;

constructor TRggDrawingZ16.Create;
begin
  inherited;
  Name := 'Z16-Shrink';

  SegmentCount := 20;
  Count := SegmentCount + 1;
  MastLength := 460;
  Radius := 300;

  { Help Text }

  HT := TRggLabel.Create;
  HT.Caption := 'HelpText';
  HT.Text := GetHelpText;
  HT.StrokeColor := CssTomato;
  HT.IsMemoLabel := True;
  HT.Position.Y := 500;
  Add(HT);

  { Points }

  A := TRggCircle.Create('A');
  A.StrokeColor := CssBlack;

  B := TRggCircle.Create('B');
  B.StrokeColor := CssRed;

  T := TRggCircle.Create('T');
  T.StrokeColor := CssAquamarine;
  T.ShowCaption := False;
  T.IsComputed := True;

  M := TRggCircle.Create('M');
  M.StrokeColor := CssOrangeRed;
  M.IsComputed := True;

  InitDefaultPos;

  { Sonstiges }

  DefaultShowCaption := False;

  MT := TRggLine.Create('MT');
  MT.StrokeThickness := 1;
  MT.StrokeColor := CssRed;
  MT.Point1 := M;
  MT.Point2 := T;
  MT.IsComputed := True;
  Add(MT);

  AB := TRggPolyLine3D.Create('AB', Count);
  AB.StrokeThickness := 1;
  AB.StrokeColor := CssDodgerblue;
  AB.Point1 := A;
  AB.Point2 := B;
  Add(AB);

  Bem := TRggLabel.Create;
  Bem.Caption := 'Bem';
  Add(Bem);

  Add(A);
  Add(B);
  Add(T);
  Add(M);

  FixPoint3D := A.Center.C;
  WantRotation := False;
  WantSort := False;
  DefaultElement := B;

  AB.WantRotation := WantRotation;
end;

function TRggDrawingZ16.GetHelpText: string;
begin
  ML.Add('Shrink sample');
  ML.Add('');
  ML.Add('If the Mast bends - distance AB (D0C) will shorten, but how much?');
  ML.Add('  This is a sample based on paper and pencil work for RiggVar,');
  ML.Add('    in the 90th.');
  ML.Add('');
  ML.Add('I created the drawing elements out of a need to document stuff,');
  ML.Add('  in 2020 using Delphi.');
  ML.Add('Drawing elements need an attached caption and should be live!');
  result := ML.Text;
  ML.Clear;
end;

end.
