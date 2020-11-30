﻿unit RiggVar.RG.Speed02;

interface

{$ifdef fpc}
{$mode delphi}
{$endif}

uses
  RiggVar.FB.SpeedBar,
  RiggVar.FB.SpeedColor,
  Classes,
  Buttons;

{.$define WantSegmentButtons}
{.$define WantSpecialButtons}

type
  TActionSpeedBarRG02 = class(TActionSpeedBar)
  private
{$ifdef WantSpecialButtons}
    ToggleDarkModeBtn: TSpeedButton;
    ToggleButtonSizeBtn: TSpeedButton;
{$endif}
    UseDisplayListBtn: TSpeedButton;
    UseQuickSortBtn: TSpeedButton;
    LegendBtn: TSpeedButton;
    LineColorBtn: TSpeedButton;
{$ifdef WantSegmentButtons}
    FixpunktBtn: TSpeedButton;
    RumpfBtn: TSpeedButton;
    SalingBtn: TSpeedButton;
    WanteBtn: TSpeedButton;
    MastBtn: TSpeedButton;
    VorstagBtn: TSpeedButton;
    ControllerBtn: TSpeedButton;
    AchsenBtn: TSpeedButton;
{$endif}
    SeiteBtn: TSpeedButton;
    TopBtn: TSpeedButton;
    AchternBtn: TSpeedButton;
    NullBtn: TSpeedButton;

    ZoomInBtn: TSpeedButton;
    ZoomOutBtn: TSpeedButton;

    BogenBtn: TSpeedButton;

    MemoryBtn: TSpeedButton;
    MemoryRecallBtn: TSpeedButton;

    SofortBtn: TSpeedButton;
    GrauBtn: TSpeedButton;
    BlauBtn: TSpeedButton;
    MultiBtn: TSpeedButton;
    KoppelBtn: TSpeedButton;

    MatrixBtn: TSpeedButton;
  public
    procedure InitSpeedButtons; override;
  end;

implementation

uses
  RiggVar.FB.ActionConst;

{ TActionSpeedBarRG02 }

procedure TActionSpeedBarRG02.InitSpeedButtons;
var
  sb: TSpeedBtn;
begin
{$ifdef WantSegmentButtons}
  { Special Buttons }

  BtnColorValue := clvScheme;

  sb := AddSpeedBtn('ToggleButtonSizeBtn', BtnGroupSpace);
  ToggleButtonSizeBtn := sb;
  sb.AllowAllUp := True;
  sb.Tag := faToggleButtonSize;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('ToggleDarkModeBtn');
  ToggleDarkModeBtn := sb;
  sb.AllowAllUp := True;
  sb.Tag := faToggleDarkMode;
  InitSpeedButton(sb);
{$endif}

  { DisplayList Graph Toggle }

  BtnColorValue := clvGraph;

  sb := AddSpeedBtn('UseDisplayListBtn', BtnGroupSpace);
  UseDisplayListBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faToggleUseDisplayList;
  InitSpeedButton(sb);

  { DisplayList Graph Options }

  BtnColorValue := clvOption;

  sb := AddSpeedBtn('UseQuickSortBtn', BtnGroupSpace);
  UseQuickSortBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faToggleUseQuickSort;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('LegendBtn', 0);
  LegendBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faToggleShowLegend;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('LineColorBtn');
  LineColorBtn := sb;
  sb.GroupIndex := NextGroupIndex;
  sb.AllowAllUp := True;
  sb.Tag := faToggleLineColor;
  InitSpeedButton(sb);

{$ifdef SegmentButtons}

  { DisplayList Graph Segments }

  BtnColorValue := clvSegment;

  sb := AddSpeedBtn('FixpunktBtn', BtnGroupSpace);
  FixpunktBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faToggleSegmentF;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('RumpftBtn', 0);
  RumpfBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faToggleSegmentR;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('SalingBtn', 0);
  SalingBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faToggleSegmentS;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('MastBtn', 0);
  MastBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faToggleSegmentM;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('VorstagBtn', 0);
  VorstagBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faToggleSegmentV;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('WanteBtn', 0);
  WanteBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faToggleSegmentW;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('ControllerBtn', 0);
  ControllerBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faToggleSegmentC;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('AchsenBtn', 0);
  AchsenBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faToggleSegmentA;
  InitSpeedButton(sb);
{$endif}

  { Bogen and Koppel }

  BtnColorValue := clvBogen;

  sb := AddSpeedBtn('BogenBtn', BtnGroupSpace);
  BogenBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faRggBogen;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('KoppelBtn', 0);
  KoppelBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faRggKoppel;
  InitSpeedButton(sb);

  { Image Elements, and Matrix Text }

  BtnColorValue := clvImage;

  sb := AddSpeedBtn('MatrixBtn', 0);
  MatrixBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faToggleMatrixText;
  InitSpeedButton(sb);

  { Memory Buttons }

  BtnColorValue := clvMemory;

  sb := AddSpeedBtn('MemoryBtn', BtnGroupSpace);
  MemoryBtn := sb;
  sb.Tag := faMemoryBtn;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('MemoryRecallBtn', 0);
  MemoryRecallBtn := sb;
  sb.Tag := faMemoryRecallBtn;
  InitSpeedButton(sb);

  { Rigg Buttons }

  BtnColorValue := clvRigg;

  sb := AddSpeedBtn('SofortBtn', BtnGroupSpace);
  SofortBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faSofortBtn;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('GrauBtn', 0);
  GrauBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faGrauBtn;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('BlauBtn', 0);
  BlauBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faBlauBtn;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('MultiBtn', 0);
  MultiBtn := sb;
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Tag := faMultiBtn;
  InitSpeedButton(sb);

  { Zoom Buttons }

  BtnColorValue := clvZoom;

  sb := AddSpeedBtn('ZoomOutBtn', BtnGroupSpace);
  ZoomOutBtn := sb;
  sb.Tag := faRggZoomOut;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('ZoomInBtn', 0);
  ZoomInBtn := sb;
  sb.Tag := faRggZoomIn;
  InitSpeedButton(sb);

  { ViewPoint Buttons }

  BtnColorValue := clvView;

  sb := AddSpeedBtn('SeiteBtn', BtnGroupSpace);
  SeiteBtn := sb;
  sb.Tag := faViewpointS;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('AchternBtn', 0);
  AchternBtn := sb;
  sb.Tag := faViewpointA;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('TopBtn', 0);
  TopBtn := sb;
  sb.Tag := faViewpointT;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('NullBtn', 0);
  NullBtn := sb;
  sb.Tag := faViewpoint3;
  InitSpeedButton(sb);
end;

end.
