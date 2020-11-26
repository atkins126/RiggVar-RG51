﻿unit RiggVar.RG.Speed04;

interface

{$ifdef fpc}
{$mode delphi}
{$endif}

uses
  RiggVar.FB.SpeedBar,
  RiggVar.FB.SpeedColor,
  Classes,
  Buttons;

type
  TActionSpeedBarRG04 = class(TActionSpeedBar)
  private
    ColorModeBtn: TSpeedButton;
    FontSizeBtn: TSpeedButton;

    SeiteBtn: TSpeedButton;
    TopBtn: TSpeedButton;
    AchternBtn: TSpeedButton;
    NullBtn: TSpeedButton;

    ZoomInBtn: TSpeedButton;
    ZoomOutBtn: TSpeedButton;

    BogenBtn: TSpeedButton;
    KoppelBtn: TSpeedButton;

    MemoryBtn: TSpeedButton;
    MemoryRecallBtn: TSpeedButton;
  private
    procedure ToggleColorModeBtnClick(Sender: TObject);
    procedure ToggleFontSizeBtnClick(Sender: TObject);
  protected
    procedure SpeedButtonClick(Sender: TObject); override;
  public
    procedure InitSpeedButtons; override;
    procedure UpdateSpeedButtonDown; override;
    procedure UpdateSpeedButtonEnabled; override;
  end;

implementation

uses
  FrmMain,
  RiggVar.App.Main,
  RggTypes,
  RiggVar.FB.ActionConst;

{ TActionSpeedBarRG04 }

procedure TActionSpeedBarRG04.SpeedButtonClick(Sender: TObject);
var
  fa: Integer;
begin
  fa := (Sender as TComponent).Tag;
  Main.ActionHandler.Execute(fa);

  Exit;

  case fa of
    faViewpointS: FormMain.SeiteBtnClick(Sender);
    faViewpointA: FormMain.AchternBtnClick(Sender);
    faViewpointT: FormMain.TopBtnClick(Sender);
    faViewpoint3: FormMain.NullBtnClick(Sender);

    faRggZoomIn: FormMain.RotaForm.ZoomInBtnClick(Sender);
    faRggZoomOut: FormMain.RotaForm.ZoomOutBtnClick(Sender);

    faRggBogen: FormMain.BogenBtnClick(Sender);
    faRggKoppel: FormMain.KoppelBtnClick(Sender);

    faMemoryBtn: FormMain.MemoryBtnClick(Sender);
    faMemoryRecallBtn: FormMain.MemoryRecallBtnClick(Sender);
  end;
end;

procedure TActionSpeedBarRG04.UpdateSpeedButtonDown;
begin
  SeiteBtn.Down := False;
  TopBtn.Down := False;
  AchternBtn.Down := False;
  NullBtn.Down := False;

  ZoomInBtn.Down := False;
  ZoomOutBtn.Down := False;

  BogenBtn.Down := Main.GetChecked(faRggBogen);
  KoppelBtn.Down := Main.GetChecked(faRggKoppel);

  MemoryBtn.Down := False;
  MemoryRecallBtn.Down := False;
end;

procedure TActionSpeedBarRG04.UpdateSpeedButtonEnabled;
begin
end;

procedure TActionSpeedBarRG04.InitSpeedButtons;
var
  sb: TSpeedBtn;
begin
  { Special Buttons }

  BtnColorValue := clvScheme;

  sb := AddSpeedBtn('FontSizeBtn', BtnGroupSpace);
  FontSizeBtn := sb;
  sb.Caption := 'FS';
  sb.Hint := 'Toggle FontSize';
  sb.OnClick := ToggleFontSizeBtnClick;
  sb.Tag := faNoop;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('ColorModeBtn');
  ColorModeBtn := sb;
  sb.Caption := 'CM';
  sb.Hint := 'Toggle ColorMode';
  sb.OnClick := ToggleColorModeBtnClick;
  sb.Tag := faNoop;
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

  { Bogen and Koppel }

  BtnColorValue := clvBogen;

  sb := AddSpeedBtn('BogenBtn', BtnGroupSpace);
  BogenBtn := sb;
  sb.AllowAllUp := True;
  sb.Tag := faRggBogen;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('KoppelBtn', 0);
  KoppelBtn := sb;
  sb.AllowAllUp := True;
  sb.Tag := faRggKoppel;
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

procedure TActionSpeedBarRG04.ToggleColorModeBtnClick(Sender: TObject);
begin
  Main.ToggleDarkMode;
end;

procedure TActionSpeedBarRG04.ToggleFontSizeBtnClick(Sender: TObject);
begin
  FormMain.ToggleSpeedPanelFontSize;
end;

end.
