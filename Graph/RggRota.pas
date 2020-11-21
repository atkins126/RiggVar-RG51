﻿unit RggRota;

(*
-
-     F
-    * * *
-   *   *   G
-  *     * *   *
- E - - - H - - - I
-  *     * *         *
-   *   *   *           *
-    * *     *             *
-     D-------A---------------B
-              *
-              (C) federgraph.de
-
*)

interface

{$ifdef fpc}
{$mode delphi}
{$endif}

uses
  Graphics,
  BGRABitmap,
  BGRABitmapTypes,
  SysUtils,
  Classes,
  Types,
  Math,
  ExtCtrls, // for Image
  Controls, // for TMouseButton
  RiggVar.FD.Point,
  RiggVar.RG.Graph,
  RggTypes,
  RggMatrix,
  RggRaumGraph,
  RggGraph,
  RggHull,
  RggPolarKar,
  RggTransformer;

type
  { TRotaForm1 }

  TRotaForm1 = class(TInterfacedObject, IStrokeRigg)
  private
    RPN: TRiggPoints;
    RPE: TRiggPoints;
    RPR: TRiggPoints;
    SkipOnceFlag: Boolean;
    function OnGetFixPunkt: TPoint3D;
    procedure DrawToCanvasEx(g: TBGRABitmap);
    procedure DrawToCanvas(g: TBGRABitmap);
    procedure DrawToImage(g: TBGRABitmap);
  private
    procedure PaintBox3DMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaintBox3DMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PaintBox3DMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  protected
    KeepInsideItemChecked: Boolean;
    procedure PositionSaveItemClick(Sender: TObject);
    procedure KeepInsideItemClick(Sender: TObject);
    procedure PositionResetItemClick(Sender: TObject);
    procedure DrawAlwaysItemClick(Sender: TObject);
  public
    LegendItemChecked: Boolean;
    MatrixItemChecked: Boolean;
    PaintItemChecked: Boolean;
    RumpfItemChecked: Boolean;
    procedure LegendBtnClick(Sender: TObject);
    procedure MatrixItemClick(Sender: TObject);
    procedure PaintBtnClick(Sender: TObject);
    procedure RumpfBtnClick(Sender: TObject);
    procedure ZoomInBtnClick(Sender: TObject);
    procedure ZoomOutBtnClick(Sender: TObject);
    procedure UseDisplayListBtnClick(Sender: TObject);
    procedure UseQuickSortBtnClick(Sender: TObject);
    procedure BogenBtnClick(Sender: TObject);
    procedure KoppelBtnClick(Sender: TObject);
  private
    FViewPoint: TViewPoint;
    FZoomBase: single;
    FZoom: single;

    FPhi: single;
    FTheta: single;
    FGamma: single;

    xmin: single;
    ymin: single;
    xmax: single;
    ymax: single;

    FXpos: single;
    FYpos: single;
    FIncrementW: single;
    FIncrementT: single;
    FZoomIndex: Integer;

    RotaData: TRotaData;
    RotaData1: TRotaData;
    RotaData2: TRotaData;
    RotaData3: TRotaData;
    RotaData4: TRotaData;

    NullpunktOffset: TPointF;
    FDrawAlways: Boolean;
    FTranslation: Boolean;
    MouseDown: Boolean;
    MouseButton: TMouseButton;
    Painted: Boolean;
    prevx, prevy: single;
    MouseDownX, MouseDownY: single;
    SavedXPos, SavedYPos: single;
    AlwaysShowAngle: Boolean;
    FFixPoint: TRiggPoint;
    procedure UpdateMinMax;
    procedure DoTrans;
  public
    { interface IStrokeRigg }
    procedure SetKoordinaten(const Value: TRiggPoints);
    procedure SetKoordinatenE(const Value: TRiggPoints);
    procedure SetKoordinatenR(const Value: TRiggPoints);
    procedure SetMastKurve(const Value: TMastKurve);
    procedure SetKoppelKurve(const Value: TKoordLine);

    procedure SetHullVisible(const Value: Boolean);

    procedure SetFixPoint(const Value: TRiggPoint);
    procedure SetViewPoint(const Value: TViewPoint);
    procedure SetSalingTyp(const Value: TSalingTyp);
    procedure SetControllerTyp(const Value: TControllerTyp);
    procedure SetWanteGestrichelt(const Value: Boolean);
    procedure SetBogen(const Value: Boolean);
    procedure SetKoppel(const Value: Boolean);
    procedure SetBtnBlauDown(const Value: Boolean);
    procedure SetBtnGrauDown(const Value: Boolean);
    procedure SetGrauZeichnen(const Value: Boolean);
    procedure SetRiggLED(const Value: Boolean);
    procedure SetSofortBerechnen(const Value: Boolean);

    procedure SetMastLineData(const Value: TLineDataR100; L: single; Beta: single);
    function GetMastKurvePoint(const Index: Integer): TPoint3D;
    procedure ToggleRenderOption(const fa: Integer);
    function QueryRenderOption(const fa: Integer): Boolean;
    procedure UpdateHullTexture;
    procedure UpdateCameraX(Delta: single);
    procedure UpdateCameraY(Delta: single);
  public
    MatrixTextU: string;
    MatrixTextV: string;
    MatrixTextW: string;
    procedure UpdateMatrixText;
    procedure DrawMatrix(g: TBGRABitmap);
  private
    FScale: single;
    FBitmapWidth: Integer;
    FBitmapHeight: Integer;
    Bitmap: TBGRABitmap;
    EraseBK: Boolean;
    procedure Rotate(Phi, Theta, Gamma, xrot, yrot, zrot: single);
    procedure Translate(x, y: single);
    procedure InitRotaData;
  private
    FOnBeforeDraw: TNotifyEvent;
    FOnAfterDraw: TNotifyEvent;
    Rotator: TPolarKar;
    Transformer: TRggTransformer;
    FBtnGrauDown: Boolean;
    FGrauZeichnen: Boolean;
    FBtnBlauDown: Boolean;
    FRiggLED: Boolean;
    FSofortBerechnen: Boolean;
    FWanteGestrichelt: Boolean;
    FBogen: Boolean;
    FKoppel: Boolean;
    FWantLineColors: Boolean;
    FDarkMode: Boolean;
    FWantOverlayedRiggs: Boolean;
    FUseQuickSort: Boolean;
    procedure InitGraph;
    procedure InitRaumGraph;
    procedure InitHullGraph;
    procedure DrawHullNormal(g: TBGRABitmap);
    procedure UpdateGraphFromTestData;
    procedure UpdateDisplayListForBoth(WithKoord: Boolean);
    procedure SetZoomIndex(const Value: Integer);
    procedure SetOnBeforeDraw(const Value: TNotifyEvent);
    procedure SetOnAfterDraw(const Value: TNotifyEvent);
    function SingleDraw: Boolean;
    procedure SetWantLineColors(const Value: Boolean);
    procedure SetDarkMode(const Value: Boolean);
    procedure SetWantOverlayedRiggs(const Value: Boolean);
    procedure SetUseQuickSort(const Value: Boolean);
  public
    IsUp: Boolean;
    Image: TImage; // injected

    HullGraph: THullGraph0;
    RaumGraph: TRaumGraph;
    UseDisplayList: Boolean;
    BackgroundColor: TColor;

    constructor Create;
    destructor Destroy; override;

    procedure HandleAction(fa: Integer);
    function GetChecked(fa: Integer): Boolean;
    procedure SetChecked(fa: Integer; Value: Boolean);

    procedure Init;
    procedure DoOnceOnShow;
    procedure InitPosition(w, h, x, y: single);
    procedure Swap;
    procedure Draw;
    procedure ImageScreenScaleChanged(Sender: TObject);

    procedure RotateZ(Delta: single);
    procedure Zoom(Delta: single);

    procedure DoOnUpdateStrokeRigg;

    property ZoomIndex: Integer read FZoomIndex write SetZoomIndex;
    property ViewPoint: TViewPoint read FViewPoint write SetViewPoint;
    property FixPoint: TRiggPoint read FFixPoint write SetFixPoint;

    property HullVisible: Boolean write SetHullVisible;
    property SalingTyp: TSalingTyp write SetSalingTyp;
    property ControllerTyp: TControllerTyp write SetControllerTyp;
    property Koordinaten: TRiggPoints write SetKoordinaten;
    property KoordinatenE: TRiggPoints write SetKoordinatenE;
    property KoordinatenR: TRiggPoints write SetKoordinatenR;
    property MastKurve: TMastKurve write SetMastKurve;
    property KoppelKurve: TKoordLine write SetKoppelKurve;
    property WanteGestrichelt: Boolean read FWanteGestrichelt write SetWanteGestrichelt;
    property Bogen: Boolean read FBogen write SetBogen;
    property Koppel: Boolean read FKoppel write SetKoppel;

    property RiggLED: Boolean read FRiggLED write SetRiggLED;
    property SofortBerechnen: Boolean read FSofortBerechnen write SetSofortBerechnen;
    property GrauZeichnen: Boolean read FGrauZeichnen write SetGrauZeichnen;
    property BtnGrauDown: Boolean read FBtnGrauDown write SetBtnGrauDown;
    property BtnBlauDown: Boolean read FBtnBlauDown write SetBtnBlauDown;

    property OnBeforeDraw: TNotifyEvent read FOnBeforeDraw write SetOnBeforeDraw;
    property OnAfterDraw: TNotifyEvent read FOnAfterDraw write SetOnAfterDraw;

    property WantOverlayedRiggs: Boolean read FWantOverlayedRiggs write SetWantOverlayedRiggs;
    property WantLineColors: Boolean read FWantLineColors write SetWantLineColors;
    property DarkMode: Boolean read FDarkMode write SetDarkMode;
    property UseQuickSort: Boolean read FUseQuickSort write SetUseQuickSort;

    property BitmapWidth: Integer read FBitmapWidth;
    property BitmapHeight: Integer read FBitmapHeight;
  end;

implementation

uses
  RiggVar.App.Main,
  RiggVar.FB.ActionConst,
  RiggVar.RG.Def,
  RggDisplay,
  RggZug3D,
  RggTestData;

{ TRotaForm1 }

constructor TRotaForm1.Create;
begin
  FScale := MainVar.Scale;
  KeepInsideItemChecked := True;
  FBitmapWidth := Round(1024 * FScale);
  FBitmapHeight := Round(768 * FScale);
  FBogen := True;

  { do almost nothing here,
    - Image reference needs to be injected first,
    later Init must be called, from the outside.
  }
end;

destructor TRotaForm1.Destroy;
begin
  Image := nil;
  Bitmap.Free;
  RaumGraph.Free;
  HullGraph.Free;
  Rotator.Free;
  Transformer.Free;
  inherited;
end;

procedure TRotaForm1.Init;
var
  b: TBitmap;
begin
  FDrawAlways := True;
  AlwaysShowAngle := False;

  Bitmap := TBGRABitmap.Create(
    Round(FBitmapWidth),
    Round(FBitmapHeight), CssWhite);

  b := TBitmap.Create;
  b.Width := Bitmap.Width;
  b.Height := Bitmap.Height;
  Image.Picture.Graphic := b;
  b.Free;

  FZoomBase := 0.05;
  FViewPoint := vp3D;
  FFixPoint := ooD0;
  FXPos := Round(-150 * FScale);
  FYPos := -50;

  Image.OnMouseDown := PaintBox3DMouseDown;
  Image.OnMouseMove := PaintBox3DMouseMove;
  Image.OnMouseUp := PaintBox3DMouseUp;

  InitGraph;
  InitRaumGraph;
  InitHullGraph;
  UpdateGraphFromTestData;
  SetViewPoint(FViewPoint);
end;

procedure TRotaForm1.InitGraph;
begin
  Rotator := TPolarKar.Create;
  Rotator.OnCalcAngle := Rotator.GetAngle2;
  InitRotaData;
  Transformer := TRggTransformer.Create;
  Transformer.Rotator := Rotator;
  Transformer.OnGetFixPunkt := OnGetFixPunkt;
  Transformer.WantOffset := True;
end;

procedure TRotaForm1.InitRaumGraph;
begin
  RaumGraph := TRaumGraph.Create(TZug3D.Create);
  RaumGraph.Transformer := Transformer;
  RaumGraph.FixPoint := FixPoint;
  RaumGraph.Zoom := FZoom;
  RaumGraph.ViewPoint := vp3D;
  RaumGraph.Bogen := FBogen;
end;

procedure TRotaForm1.InitHullGraph;
begin
  HullGraph := THullGraph0.Create;
  HullGraph.Transformer := Transformer;
end;

procedure TRotaForm1.UpdateGraphFromTestData;
begin
  RaumGraph.Salingtyp := stFest;
  RaumGraph.ControllerTyp := ctOhne;
  RaumGraph.Koordinaten := TRggTestData.GetKoordinaten420;
  RaumGraph.SetMastKurve(TRggTestData.GetMastKurve420);
  RaumGraph.WanteGestrichelt := False;
  Draw;
end;

procedure TRotaForm1.InitRotaData;

  function GetMatrix(Theta, Xrot: single): TMatrix3D;
  begin
    Rotator.Reset;
    Rotator.DeltaTheta := Theta;
    Rotator.XRot := Xrot;
    result := Rotator.Matrix;
  end;

begin
  with RotaData1 do
  begin
    Xpos := Round(-150 * FScale);
    Ypos := Round(-40 * FScale);
    Matrix := GetMatrix(0, 0);
    ZoomIndex := 3;
    FixPunktIndex := 7;
    IncrementIndex := 3;
    IncrementT := 10;
    IncrementW := 5;
  end;
  with RotaData2 do
  begin
    Xpos := Round(-150 * FScale);
    Ypos := Round(-50 * FScale);
    Matrix := GetMatrix(0, 90);
    ZoomIndex := 2;
    FixPunktIndex := 8;
    IncrementIndex := 3;
    IncrementT := 10;
    IncrementW := 5;
  end;
  with RotaData3 do
  begin
    Xpos := Round(-170 * FScale);
    Ypos := Round(-120 * FScale);
    Matrix := GetMatrix(-90, 90);
    ZoomIndex := 5;
    FixPunktIndex := 8;
    IncrementIndex := 3;
    IncrementT := 10;
    IncrementW := 5;
  end;
  with RotaData4 do
  begin
    Xpos := Round(-130 * FScale);
    Ypos := Round(-80 * FScale);
    Matrix := GetMatrix(90, -87);
    ZoomIndex := 8;
    FixPunktIndex := 8;
    IncrementIndex := 3;
    IncrementT := 10;
    IncrementW := 5;
  end;
end;

procedure TRotaForm1.UpdateMatrixText;
var
  m: TMatrix3D;
begin
  m := Rotator.Mat;
  MatrixTextU := Format('%8.4f %8.4f %8.4f',[m.m11, m.m12, m.m13]);
  MatrixTextV := Format('%8.4f %8.4f %8.4f',[m.m21, m.m22, m.m23]);
  MatrixTextW := Format('%8.4f %8.4f %8.4f',[m.m31, m.m32, m.m33]);
end;

procedure TRotaForm1.DrawMatrix(g: TBGRABitmap);
var
  oy: single;
  tx: single;
  th: single;

  StrokeColor: TColor;

  procedure TextOut(x, y: single; s: string);
  begin
    g.TextOut(
      x,
      y,
      s,
      StrokeColor,
      TAlignment.taLeftJustify);
  end;

begin
  oy := 10 * FScale;
  tx := 400 * FScale;
  th := 25 * FScale;
  StrokeColor := CssBlue;
  g.FontName := 'Consolas';
  g.FontHeight := Round(16 * FScale);
  TextOut(tx, oy + 0 * th, MatrixTextU);
  TextOut(tx, oy + 1 * th, MatrixTextV);
  TextOut(tx, oy + 2 * th, MatrixTextW);
end;

procedure TRotaForm1.DoOnceOnShow;
begin
  FXPos := (Image.Width - Bitmap.Width) - 250;
  FYPos := (Image.Height - Bitmap.Height) - 100;
end;

procedure TRotaForm1.DrawToImage(g: TBGRABitmap);
begin
  Painted := False;

  { Verschiebung erfolgt mit FXPos und FYPos }
  NullpunktOffset.X := FBitmapWidth / 2 + FXpos;
  NullpunktOffset.Y := FBitmapHeight / 2 + FYpos;
  Transformer.Offset := PointF(NullpunktOffset.X, NullpunktOffset.Y);

  g.LineCap := TPenEndCap.pecRound;
  g.JoinStyle := TPenJoinStyle.pjsRound;
  if WantOverlayedRiggs then
  begin
    DrawToCanvasEx(g)
  end
  else
  begin
    RaumGraph.Coloriert := True;
    WanteGestrichelt := WanteGestrichelt;
    RaumGraph.Koordinaten := RPN;
    DrawToCanvas(g);
  end;

  { Bitmap auf den Bildschirm kopieren }
  Bitmap.Draw(Image.Canvas, 0, 0, True);
  Image.Invalidate;

  Painted := True;
end;

procedure TRotaForm1.DrawToCanvasEx(g: TBGRABitmap);
begin
  if SingleDraw then
  begin
    RaumGraph.Coloriert := True;
    WanteGestrichelt := WanteGestrichelt;
    RaumGraph.Koordinaten := RPN;
    DrawToCanvas(g);
  end
  else
  begin
    { entspanntes Rigg grau zeichnen }
    if Grauzeichnen and BtnGrauDown then
    begin
      RaumGraph.Color := claEntspannt;
      RaumGraph.Coloriert := False;
      WanteGestrichelt := False; //WanteGestrichelt;
      RaumGraph.Koordinaten := RPE;
      DrawToCanvas(g);
      SkipOnceFlag := True;
    end;

    { Nullstellung hellblau zeichnen }
    if BtnBlauDown then
    begin
      RaumGraph.Color := claNullStellung;
      RaumGraph.Coloriert := False;
      RaumGraph.WanteGestrichelt := False;
      RaumGraph.Koordinaten := RPR;
      DrawToCanvas(g);
      SkipOnceFlag := True;
    end;

    { gespanntes Rigg farbig zeichnen}
    RaumGraph.Coloriert := True;
    WanteGestrichelt := WanteGestrichelt;
    RaumGraph.Koordinaten := RPN;
    DrawToCanvas(g);
  end;
end;

procedure TRotaForm1.DrawToCanvas(g: TBGRABitmap);
begin
  if SkipOnceFlag then
  begin
    { do not clear background }
  end
  else if not PaintItemChecked or EraseBK then
  begin
    g.FillRect(0, 0, Image.Width, Image.Height, CssWhite, dmSet);
    //g.DrawLineAntialias(0, 0, Bitmap.Width, Bitmap.Height, CssRed, 2);
    //g.DrawLineAntialias(0, Image.Height, Image.Width, 0, CssBlue, 2);
    EraseBK := False;
  end;

  SkipOnceFlag := False;

  if MatrixItemChecked then
  begin
    UpdateMatrixText;
    DrawMatrix(g);
  end;

  if UseDisplayList then
  begin
    UpdateDisplayListForBoth(False);
    TDisplayItem.NullpunktOffset := NullpunktOffset;;
    RaumGraph.DL.WantLegend := LegendItemChecked; // not RumpfItemChecked;
    RaumGraph.DL.Draw(g);
  end
  else
  begin
    RaumGraph.DrawToCanvas(g);
  end;

  { This method will first check whether this should be done at all. }
  DrawHullNormal(g);
end;

procedure TRotaForm1.DoTrans;
begin
  UpdateMinMax;

  if FXpos < xmin then
    FXpos := xmin;
  if FXpos > xmax then
    FXpos := xmax;
  if FYpos < ymin then
    FYpos := ymin;
  if FYpos > ymax then
    FYpos := ymax;

  if not PaintItemChecked then
    EraseBK := True;
end;

procedure TRotaForm1.UpdateMinMax;
begin
  if KeepInsideItemChecked then
  begin
    xmin := -FBitmapWidth / 2;
    ymin := -FBitmapHeight / 2;
    xmax := Abs(xmin);
    ymax := Abs(ymin);
    if xmax > xmin + Image.Width then
      xmax := xmin + Image.Width;
    if ymax > ymin + Image.Height then
      ymax := ymin + Image.Height;
  end
  else
  begin
    xmin := -3000;
    ymin := -3000;
    xmax := 3000;
    ymax := 3000;
  end;
end;

procedure TRotaForm1.ZoomInBtnClick(Sender: TObject);
begin
  ZoomIndex := FZoomIndex + 1;
end;

procedure TRotaForm1.ZoomOutBtnClick(Sender: TObject);
begin
  ZoomIndex := FZoomIndex - 1;
end;

procedure TRotaForm1.SetBtnBlauDown(const Value: Boolean);
begin
  FBtnBlauDown := Value;
end;

procedure TRotaForm1.SetBtnGrauDown(const Value: Boolean);
begin
  FBtnGrauDown := Value;
end;

procedure TRotaForm1.SetFixPoint(const Value: TRiggPoint);
begin
  FFixPoint := Value;
  RaumGraph.FixPoint := FixPoint;
  Draw;
end;

procedure TRotaForm1.SetGrauZeichnen(const Value: Boolean);
begin
  FGrauZeichnen := Value;
end;

procedure TRotaForm1.SetHullVisible(const Value: Boolean);
begin
  RumpfItemChecked := Value;
  Draw;
end;

procedure TRotaForm1.SetRiggLED(const Value: Boolean);
begin
  FRiggLED := Value;
  RaumGraph.RiggLED := Value;
end;

procedure TRotaForm1.SetSofortBerechnen(const Value: Boolean);
begin
  FSofortBerechnen := Value;
end;

procedure TRotaForm1.SetOnAfterDraw(const Value: TNotifyEvent);
begin
  FOnAfterDraw := Value;
end;

procedure TRotaForm1.SetOnBeforeDraw(const Value: TNotifyEvent);
begin
  FOnBeforeDraw := Value;
end;

procedure TRotaForm1.RumpfBtnClick(Sender: TObject);
begin
  RumpfItemChecked := not RumpfItemChecked;
  Draw;
end;

procedure TRotaForm1.PaintBtnClick(Sender: TObject);
begin
  PaintItemChecked := not PaintItemChecked;
  if not PaintItemChecked then
    EraseBK := True;
  Draw;
end;

procedure TRotaForm1.UseDisplayListBtnClick(Sender: TObject);
begin
  UseDisplayList := not UseDisplayList;
  Draw;
end;

procedure TRotaForm1.UseQuickSortBtnClick(Sender: TObject);
begin
  RaumGraph.DL.UseQuickSort := not RaumGraph.DL.UseQuickSort;
  RaumGraph.Update;
  Draw;
end;

procedure TRotaForm1.BogenBtnClick(Sender: TObject);
begin
  Bogen := not Bogen;
  Draw;
end;

procedure TRotaForm1.SetViewPoint(const Value: TViewPoint);
begin
  if not IsUp then
    Exit;

  FViewPoint := Value;
  case FViewPoint of
    vpSeite: RotaData := RotaData1;
    vpAchtern: RotaData := RotaData2;
    vpTop: RotaData := RotaData3;
    vp3D: RotaData := RotaData4;
  end;
  RaumGraph.Viewpoint := Value; // for GetriebeGraph

  FIncrementT := RotaData.IncrementT;
  FIncrementW := RotaData.IncrementW;

  { Rotationmatrix }
  Rotator.Matrix := RotaData.Matrix;
  Rotator.GetAngle(FPhi, FTheta, FGamma);

  { Zoom }
  FZoomIndex := RotaData.ZoomIndex;
  FZoom := FZoomBase * TRotaParams.LookUpRa10(FZoomIndex);
  Transformer.Zoom := FZoom;

  { FixPoint }
  RaumGraph.FixPoint := FixPoint; // --> Transformer.FixPoint

  RaumGraph.Update;
  HullGraph.Update;

  { Neuzeichnen }
  EraseBK := True;
  Draw;
end;

procedure TRotaForm1.PositionSaveItemClick(Sender: TObject);
begin
  case FViewPoint of
    vpSeite: RotaData := RotaData1;
    vpAchtern: RotaData := RotaData2;
    vpTop: RotaData := RotaData3;
    vp3D: RotaData := RotaData4;
  end;
  with RotaData do
  begin
    Xpos := FXpos;
    Ypos := FYpos;
    Matrix := Rotator.Matrix;
    ZoomIndex := FZoomIndex;
    IncrementT := FIncrementT;
    IncrementW := FIncrementW;
  end;
  case FViewPoint of
    vpSeite: RotaData1 := RotaData;
    vpAchtern: RotaData2 := RotaData;
    vpTop: RotaData3 := RotaData;
    vp3D: RotaData4 := RotaData;
  end;
end;

procedure TRotaForm1.PositionResetItemClick(Sender: TObject);
begin
  InitRotaData;
  SetViewPoint(FViewPoint);
end;

procedure TRotaForm1.KeepInsideItemClick(Sender: TObject);
begin
  KeepInsideItemChecked := not KeepInsideItemChecked;
  if KeepInsideItemChecked then
    Draw;
end;

procedure TRotaForm1.KoppelBtnClick(Sender: TObject);
begin
  RaumGraph.Koppel := not RaumGraph.Koppel;
  Draw;
end;

procedure TRotaForm1.PaintBox3DMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseDown := True;
  MouseButton := Button;
  prevx := x;
  MouseDownX := x;
  SavedXPos := FXPos;
  prevy := y;
  MouseDownY := y;
  SavedYPos := FYPos;

  FTranslation :=
    (Abs(NullPunktOffset.x - X) < TKR) and
    (Abs(NullPunktOffset.y - Y) < TKR);
end;

procedure TRotaForm1.PaintBox3DMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  wx, wy, wz: single;
begin
  if not MouseDown then
    Exit;
  if MouseButton = TMouseButton.mbLeft then
  begin
    wx := (x - prevx) * 0.15;
    wy := (y - prevy) * 0.15;
    wz := 0;
  end
  else
  begin
    wx := 0;
    wy := 0;
    wz := (x - prevx) * 0.3;
  end;

  if Painted then
  begin
    Painted := False;
    if FTranslation or (Shift = [ssLeft, ssRight]) then
      Translate(x,y)
    else
      Rotate(0, 0, 0, wx, wy, wz);
    Draw;
    prevx := x;
    prevy := y;
  end;
end;

procedure TRotaForm1.PaintBox3DMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseDown := False;
  if (prevx = MouseDownX) and (prevy = MouseDownY) then
    EraseBK := True;
  Draw;
end;

procedure TRotaForm1.Rotate(Phi, Theta, Gamma, xrot, yrot, zrot: single);
begin
  Rotator.DeltaPhi := Phi;
  Rotator.DeltaTheta := Theta;
  Rotator.DeltaGamma := Gamma;
  Rotator.XRot := Xrot;
  Rotator.YRot := Yrot;
  Rotator.ZRot := Zrot;
end;

procedure TRotaForm1.Translate(x, y: single);
begin
  FXpos := SavedXpos - (MouseDownX - x);
  FYpos := SavedYpos - (MouseDownY - y);
  DoTrans;
end;

procedure TRotaForm1.Draw;
begin
  if IsUp then
  begin
    DrawToImage(Bitmap);
    if Assigned(OnAfterDraw) then
      OnAfterDraw(Self);
  end;
end;

procedure TRotaForm1.DrawAlwaysItemClick(Sender: TObject);
begin
  FDrawAlways := not FDrawAlways;
end;

procedure TRotaForm1.LegendBtnClick(Sender: TObject);
begin
  LegendItemChecked := not LegendItemChecked;
  Draw;
end;

procedure TRotaForm1.MatrixItemClick(Sender: TObject);
begin
  MatrixItemChecked := not MatrixItemChecked;
  Draw;
end;

function TRotaForm1.OnGetFixPunkt: TPoint3D;
begin
  result := RPN.V[FFixPoint];
end;

procedure TRotaForm1.ToggleRenderOption(const fa: Integer);
begin
  case fa of
    faWantRenderE: RaumGraph.WantRenderE := not RaumGraph.WantRenderP;
    faWantRenderF: RaumGraph.WantRenderF := not RaumGraph.WantRenderF;
    faWantRenderH: RaumGraph.WantRenderH := not RaumGraph.WantRenderH;
    faWantRenderP: RaumGraph.WantRenderP := not RaumGraph.WantRenderP;
    faWantRenderS: RaumGraph.WantRenderS := not RaumGraph.WantRenderS;
  end;
end;

function TRotaForm1.QueryRenderOption(const fa: Integer): Boolean;
begin
  case fa of
    faWantRenderE: result := RaumGraph.WantRenderE;
    faWantRenderF: result := RaumGraph.WantRenderF;
    faWantRenderH: result := RaumGraph.WantRenderH;
    faWantRenderP: result := RaumGraph.WantRenderP;
    faWantRenderS: result := RaumGraph.WantRenderS;

    faRggBogen: result := RaumGraph.Bogen;
    faRggKoppel: result := RaumGraph.Koppel;
    faRggHull: result := RumpfItemChecked;
    else
      result := False;
  end;
end;

function TRotaForm1.GetMastKurvePoint(const Index: Integer): TPoint3D;
begin
  result := RaumGraph.GetMastKurvePoint(Index);
end;

procedure TRotaForm1.SetMastLineData(const Value: TLineDataR100; L, Beta: single);
begin
  RaumGraph.SetMastLineData(Value, L, Beta);
end;

procedure TRotaForm1.SetSalingTyp(const Value: TSalingTyp);
begin
  RaumGraph.SalingTyp := Value;
end;

procedure TRotaForm1.SetBogen(const Value: Boolean);
begin
  FBogen := Value;
  RaumGraph.Bogen := Value;
end;

procedure TRotaForm1.SetControllerTyp(const Value: TControllerTyp);
begin
  RaumGraph.ControllerTyp := Value;
end;

procedure TRotaForm1.SetKoordinaten(const Value: TRiggPoints);
begin
  RPN := Value;
end;

procedure TRotaForm1.SetKoordinatenE(const Value: TRiggPoints);
begin
  RPE := Value;
end;

procedure TRotaForm1.SetKoordinatenR(const Value: TRiggPoints);
begin
  RPR := Value;
end;

procedure TRotaForm1.SetKoppel(const Value: Boolean);
begin
  FKoppel := Value;
  RaumGraph.Koppel := Value;
end;

procedure TRotaForm1.SetKoppelKurve(const Value: TKoordLine);
begin
  RaumGraph.SetKoppelKurve(Value);
end;

procedure TRotaForm1.SetMastKurve(const Value: TMastKurve);
begin
  RaumGraph.SetMastKurve(Value);
end;

procedure TRotaForm1.SetWanteGestrichelt(const Value: Boolean);
begin
  FWanteGestrichelt := Value;
  RaumGraph.WanteGestrichelt := Value;
end;

procedure TRotaForm1.SetWantOverlayedRiggs(const Value: Boolean);
begin
  FWantOverlayedRiggs := Value;
end;

procedure TRotaForm1.SetZoomIndex(const Value: Integer);
begin
  if (Value < 1) then
    FZoomIndex := 1
  else if Value > 11 then
    FZoomIndex := 11
  else
    FZoomIndex := Value;

  FZoom := FZoomBase * TRotaParams.LookUpRa10(FZoomIndex);
  RaumGraph.Zoom := FZoom;
  Draw;
end;

procedure TRotaForm1.Zoom(Delta: single);
begin
  FZoom := FZoom + FZoom * FZoomBase * Sign(Delta);
  RaumGraph.Zoom := FZoom;
  Draw;
end;

procedure TRotaForm1.RotateZ(Delta: single);
begin
  Rotate(0, 0, 0, 0, 0, Delta * 0.3);
  Draw;
end;

procedure TRotaForm1.UpdateDisplayListForBoth(WithKoord: Boolean);
begin
  if not UseDisplayList then
    Exit;

  if WithKoord then
  begin
    { Koordinaten may be assigned by DawToCanvasEx }
    RaumGraph.Koordinaten := RPN;
  end;

  RaumGraph.Update;
  RaumGraph.UpdateDisplayList;

  if RumpfItemChecked then
  begin
    HullGraph.Coloriert := True;
    HullGraph.Update;
    HullGraph.AddToDisplayList(RaumGraph.DL);
  end;

  if Assigned(OnBeforeDraw) then
    OnBeforeDraw(Self);
end;

procedure TRotaForm1.DrawHullNormal(g: TBGRABitmap);
begin
  if RumpfItemChecked
    and not UseDisplayList
    and (not MouseDown or (MouseDown and FDrawAlways)) then
  begin
    HullGraph.Coloriert := True;
    HullGraph.Update;
    HullGraph.DrawToCanvas(g);
  end;
end;

function TRotaForm1.SingleDraw: Boolean;
begin
  result := True;

  if UseDisplayList then
  begin
    { DisplayList cannot draw multiple situations }
    Exit;
  end;

  if not WantOverlayedRiggs then
  begin
    { not wanted }
    Exit;
  end;

  if BtnBlauDown then
  begin
    { ok, draw refernce position in blue }
    result := False;
  end;

  if BtnGrauDown and SofortBerechnen then
  begin
    { ok, MultiDraw, draw relaxed position in gray }
    result := False;
  end;
end;

procedure TRotaForm1.UpdateCameraX(Delta: single);
begin
  FXPos := FXPos + Round(Delta) * 5;
  Draw;
end;

procedure TRotaForm1.UpdateCameraY(Delta: single);
begin
  FYPos := FYPos - Round(Delta) * 5;
  Draw;
end;

procedure TRotaForm1.UpdateHullTexture;
begin

end;

procedure TRotaForm1.InitPosition(w, h, x, y: single);
begin
  FBitmapWidth := Round(w);
  FBitmapHeight := Round(h);
  FXPos := Round(x);
  FYPos := Round(y);
end;

procedure TRotaForm1.Swap;
begin
  Image.OnMouseDown := PaintBox3DMouseDown;
  Image.OnMouseMove := PaintBox3DMouseMove;
  Image.OnMouseUp := PaintBox3DMouseUp;
//  Image.OnScreenScaleChanged := ImageScreenScaleChanged;
end;

procedure TRotaForm1.HandleAction(fa: Integer);
begin
  case fa of
    faReset:
    begin
      ViewPoint := FViewPoint;
    end;

    faResetPosition:
    begin
      FXPos := 0;
      FYPos := 0;
    end;

    faResetRotation:
    begin
      Rotator.Matrix := RotaData.Matrix;
      Rotator.GetAngle(FPhi, FTheta, FGamma);
    end;

    faResetZoom:
    begin
      FZoomIndex := RotaData.ZoomIndex;
      FZoom := FZoomBase * TRotaParams.LookUpRa10(FZoomIndex);
      Transformer.Zoom := FZoom;
    end;

    else
      Exit;
  end;

  FIncrementT := Round(RotaData.IncrementT);
  FIncrementW := Round(RotaData.IncrementW);

  RaumGraph.Update;
  HullGraph.Update;
  EraseBK := True;
  Draw;
end;

procedure TRotaForm1.SetDarkMode(const Value: Boolean);
begin
  FDarkMode := Value;
end;

procedure TRotaForm1.DoOnUpdateStrokeRigg;
begin

end;

function TRotaForm1.GetChecked(fa: Integer): Boolean;
begin
  result := RaumGraph.GetChecked(fa);
end;

procedure TRotaForm1.SetChecked(fa: Integer; Value: Boolean);
begin
  RaumGraph.SetChecked(fa, Value);
end;

procedure TRotaForm1.ImageScreenScaleChanged(Sender: TObject);
begin
  Draw;
end;

procedure TRotaForm1.SetWantLineColors(const Value: Boolean);
begin
  FWantLineColors := Value;
  RaumGraph.DL.WantLineColors := Value;
end;

procedure TRotaForm1.SetUseQuickSort(const Value: Boolean);
begin
  FUseQuickSort := Value;
  RaumGraph.DL.UseQuickSort := True;
end;

end.
