﻿unit RiggVar.RG.Speed01;

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
  TActionSpeedBarRG01 = class(TActionSpeedBar)
  private
    MT0Btn: TSpeedButton;
    ReadTrimmFileBtn: TSpeedButton;
    SaveTrimmFileBtn: TSpeedButton;
    CopyTrimmFileBtn: TSpeedButton;
    CopyTrimmItemBtn: TSpeedButton;
    PasteTrimmItemBtn: TSpeedButton;
    CopyAndPasteBtn: TSpeedButton;

    M1Btn: TSpeedButton;
    M10Btn: TSpeedButton;
    P1Btn: TSpeedButton;
    P10Btn: TSpeedButton;

    SandboxedBtn: TSpeedButton;
    AllPropsBtn: TSpeedButton;
    AllTagsBtn: TSpeedButton;

    ColorModeBtn: TSpeedButton;
    FontSizeBtn: TSpeedButton;

    procedure M10BtnClick(Sender: TObject);
    procedure M1BtnClick(Sender: TObject);
    procedure P1BtnClick(Sender: TObject);
    procedure P10BtnClick(Sender: TObject);

    procedure SandboxedBtnClick(Sender: TObject);
    procedure AllTagsBtnClick(Sender: TObject);

    procedure MT0BtnClick(Sender: TObject);

    procedure CopyAndPasteBtnClick(Sender: TObject);
    procedure CopyTrimmFileBtnClick(Sender: TObject);
    procedure CopyTrimmItemBtnClick(Sender: TObject);

    procedure PasteTrimmItemBtnClick(Sender: TObject);
    procedure ReadTrimmFileBtnClick(Sender: TObject);
    procedure SaveTrimmFileBtnClick(Sender: TObject);

    procedure ToggleColorModeBtnClick(Sender: TObject);
    procedure ToggleFontSizeBtnClick(Sender: TObject);
  protected
    procedure SpeedButtonClick(Sender: TObject); override;
  public
    procedure InitSpeedButtons; override;
    procedure UpdateSpeedButtonDown; override;
  end;

implementation

uses
  FrmMain,
  RiggVar.App.Main,
  RiggVar.FB.ActionConst;

{ TActionSpeedBarRG01 }

procedure TActionSpeedBarRG01.InitSpeedButtons;
var
  sb: TSpeedBtn;
begin
  { Special Buttons }

  BtnColorValue := clvData;

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

  { Check Box Buttons }

  BtnColorValue := clvOption;

  sb := AddSpeedBtn('SandboxedBtn', BtnGroupSpace);
  SandboxedBtn := sb;
  sb.Caption := 'SX';
  if MainConst.MustBeSandboxed then
  begin
    sb.Hint := 'Sandboxed (Store)';
    sb.AllowAllUp := True;
    sb.GroupIndex := NextGroupIndex;
    sb.Down := False;
    sb.OnClick := nil;
    sb.Tag := faNoop;
    InitSpeedButton(sb);
    sb.Enabled := False;
  end
  else
  begin
  sb.Hint := 'Sandboxed';
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Down := False;
  sb.OnClick := SandboxedBtnClick;
  sb.Tag := faToggleSandboxed;
  InitSpeedButton(sb);
  end;

  BtnColorValue := clvProp;

  sb := AddSpeedBtn('AllPropsBtn');
  AllPropsBtn := sb;
  sb.Caption := 'ATP';
  sb.Hint := 'All Trimm Props';
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Down := False;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('AllTagsBtn');
  AllTagsBtn := sb;
  sb.Caption := 'AXT';
  sb.Hint := 'All Xml Tags';
  sb.AllowAllUp := True;
  sb.GroupIndex := NextGroupIndex;
  sb.Down := False;
  sb.Tag := faToggleAllTags;
  sb.OnClick := AllTagsBtnClick;
  InitSpeedButton(sb);

  { Data Buttons }

  BtnColorValue := clvData;

  sb := AddSpeedBtn('MT0Btn', BtnGroupSpace);
  MT0Btn := sb;
  sb.Caption := 'MT0';
  sb.Hint := 'Update Trimm 0';
  sb.OnClick := MT0BtnClick;
  sb.Tag := faUpdateTrimm0;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('ReadTrimmFileBtn');
  ReadTrimmFileBtn := sb;
  sb.Caption := 'rtf';
  sb.Hint := 'Read Trimm File';
  sb.OnClick := ReadTrimmFileBtnClick;
  sb.Tag := faReadTrimmFile;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('SaveTrimmFileBtn');
  SaveTrimmFileBtn := sb;
  sb.Caption := 'stf';
  sb.Hint := 'Save Trimm File';
  sb.OnClick := SaveTrimmFileBtnClick;
  sb.Tag := faSaveTrimmFile;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('CopyTrimmFileBtn');
  CopyTrimmFileBtn := sb;
  sb.Caption := 'ctf';
  sb.Hint := 'Copy Trimm File';
  sb.OnClick := CopyTrimmFileBtnClick;
  sb.Tag := faCopyTrimmFile;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('CopyTrimmItemBtn');
  CopyTrimmItemBtn := sb;
  sb.Caption := 'cti';
  sb.Hint := 'Copy Trimm Item';
  sb.OnClick := CopyTrimmItemBtnClick;
  sb.Tag := faCopyTrimmItem;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('PasteTrimmItemBtn');
  PasteTrimmItemBtn := sb;
  sb.Caption := 'pti';
  sb.Hint := 'Paste Trimm Item';
  sb.OnClick := PasteTrimmItemBtnClick;
  sb.Tag := faPasteTrimmItem;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('CopyAndPasteBtn');
  CopyAndPasteBtn := sb;
  sb.Caption := 'M';
  sb.Hint := 'Copy And Paste';
  sb.OnClick := CopyAndPasteBtnClick;
  sb.Tag := faCopyAndPaste;
  InitSpeedButton(sb);

  { Param Value Buttons }

  BtnColorValue := clvWheel;

  sb := AddSpeedBtn('M10Btn', BtnGroupSpace);
  M10Btn := sb;
  sb.Caption := '-10';
  sb.Hint := 'Param Value Minus 10';
  sb.OnClick := M10BtnClick;
  sb.Tag := faParamValueMinus10;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('M1Btn');
  M1Btn := sb;
  sb.Caption := '-1';
  sb.Hint := 'Param Value Minus 1';
  sb.OnClick := M1BtnClick;
  sb.Tag := faParamValueMinus1;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('P1Btn');
  P1Btn := sb;
  sb.Caption := '+1';
  sb.Hint := 'Param Value Plus 1';
  sb.OnClick := P1BtnClick;
  sb.Tag := faParamValuePlus1;
  InitSpeedButton(sb);

  sb := AddSpeedBtn('P10Btn');
  P10Btn := sb;
  sb.Caption := '+10';
  sb.Hint := 'Param Value Plus 10';
  sb.OnClick := P10BtnClick;
  sb.Tag := faParamValuePlus10;
  InitSpeedButton(sb);
end;

procedure TActionSpeedBarRG01.CopyTrimmItemBtnClick(Sender: TObject);
begin
  Main.CopyTrimmItem;
  FormMain.ShowTrimm;
end;

procedure TActionSpeedBarRG01.PasteTrimmItemBtnClick(Sender: TObject);
begin
  Main.PasteTrimmItem;
  FormMain.ShowTrimm;
end;

procedure TActionSpeedBarRG01.CopyAndPasteBtnClick(Sender: TObject);
begin
  Main.CopyAndPaste;
  FormMain.ShowTrimm;
end;

procedure TActionSpeedBarRG01.CopyTrimmFileBtnClick(Sender: TObject);
begin
  Main.CopyTrimmFile;
  FormMain.ShowTrimm;
end;

procedure TActionSpeedBarRG01.ReadTrimmFileBtnClick(Sender: TObject);
begin
  Main.ReadTrimmFile;
  FormMain.ShowTrimm;
end;

procedure TActionSpeedBarRG01.SaveTrimmFileBtnClick(Sender: TObject);
begin
  Main.SaveTrimmFile;
  FormMain.ShowTrimm;
end;

procedure TActionSpeedBarRG01.MT0BtnClick(Sender: TObject);
begin
  Main.UpdateTrimm0;
  FormMain.ShowTrimm;
end;

procedure TActionSpeedBarRG01.SandboxedBtnClick(Sender: TObject);
begin
  if not MainConst.MustBeSandboxed then
    Main.ActionHandler.Execute(faToggleSandboxed);
end;

procedure TActionSpeedBarRG01.AllTagsBtnClick(Sender: TObject);
begin
  { All XML Tags or not }
  Main.ActionHandler.Execute(faToggleAllTags);
end;

procedure TActionSpeedBarRG01.M10BtnClick(Sender: TObject);
begin
  Main.HandleAction(faParamValueMinus10);
  FormMain.ShowTrimm;
end;

procedure TActionSpeedBarRG01.M1BtnClick(Sender: TObject);
begin
  Main.HandleAction(faParamValueMinus1);
  FormMain.ShowTrimm;
end;

procedure TActionSpeedBarRG01.P10BtnClick(Sender: TObject);
begin
  Main.HandleAction(faParamValuePlus10);
  FormMain.ShowTrimm;
end;

procedure TActionSpeedBarRG01.P1BtnClick(Sender: TObject);
begin
  Main.HandleAction(faParamValuePlus1);
  FormMain.ShowTrimm;
end;

procedure TActionSpeedBarRG01.UpdateSpeedButtonDown;
begin
  SandboxedBtn.Down := MainConst.MustBeSandboxed or MainVar.IsSandboxed;
  AllPropsBtn.Down := FormMain.AllProps;
  AllTagsBtn.Down := FormMain.ReportManager.XMLAllTags;
end;

procedure TActionSpeedBarRG01.SpeedButtonClick(Sender: TObject);
var
  fa: Integer;
begin
  fa := (Sender as TComponent).Tag;
  case fa of
    faUpdateTrimm0: MT0BtnClick(Sender);

    faReadTrimmFile: ReadTrimmFileBtnClick(Sender);
    faSaveTrimmFile: SaveTrimmFileBtnClick(Sender);
    faCopyTrimmFile: CopyTrimmFileBtnClick(Sender);

    faCopyTrimmItem: CopyTrimmItemBtnClick(Sender);
    faPasteTrimmItem: PasteTrimmItemBtnClick(Sender);
    faCopyAndPaste: CopyAndPasteBtnClick(Sender);

    faParamValueMinus1: M1BtnClick(Sender);
    faParamValueMinus10: M10BtnClick(Sender);
    faParamValuePlus1: P1BtnClick(Sender);
    faParamValuePlus10: P10BtnClick(Sender);

    faToggleSandboxed: SandboxedBtnClick(Sender);
    faToggleAllProps: FormMain.AllProps := not FormMain.AllProps;
    faToggleAllTags: AllTagsBtnClick(Sender);
  end;
end;

procedure TActionSpeedBarRG01.ToggleColorModeBtnClick(Sender: TObject);
begin
  Main.ToggleDarkMode;
end;

procedure TActionSpeedBarRG01.ToggleFontSizeBtnClick(Sender: TObject);
begin
  FormMain.ToggleSpeedPanelFontSize;
end;

end.
