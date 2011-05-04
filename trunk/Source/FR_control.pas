
{*****************************************}
{                                         }
{             FastReport v2.3             }
{         Odontograma Add-In Object       }
{                                         }
{  Copyright (c) 2009 by ADN Sistemas     }
{                                         }
{*****************************************}

unit FR_control;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Menus, FR_Class,
  controls;


type
  TfrPrintableControl = class(TControl)
  protected
    function ControlName:string;virtual;abstract;
    procedure PaintIn(DstCanvas:TCanvas;Offset:TPoint;EraseBack:boolean=False;DrawFocus:boolean=False);virtual;abstract;
    procedure SetSize(dx,dy:integer);virtual;abstract;
    procedure SaveToStream(Stream:TStream);virtual;abstract;
    procedure LoadFromStream(Stream:TStream);virtual;abstract;
  end;

  TfrControlObject = class(TComponent)  // fake component
  end;

  TfrControlView = class(TfrView)
  private
    FControl:TfrPrintableControl;
  public
    property Control:TfrPrintableControl read FControl write FControl;
    constructor Create; override;
    procedure Assign(From: TfrView); override;
    procedure Draw(Canvas: TCanvas); override;
    procedure Print(Stream: TStream); override;
    procedure DefinePopupMenu(Popup: TPopupMenu); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
  end;


implementation

uses FR_Intrp, FR_Pars, FR_Utils, FR_Const, FR_DBRel;

{$R *.RES}

constructor TfrControlView.Create;
begin
  inherited Create;
  Typ := gtAddIn;
  FrameWidth := 2;
  BaseName := 'Control';
end;

procedure TfrControlView.Draw(Canvas: TCanvas);
begin
  BeginDraw(Canvas);
  Memo1.Assign(Memo);
  CalcGaps;
  ShowBackground;
  if Assigned(FControl) then begin
    FControl.SetSize(dx,dy);
    FControl.PaintIn(Canvas,DRect.TopLeft,False,False);
  end;
  ShowFrame;
  RestoreCoord;
end;

procedure TfrControlView.Print(Stream: TStream);
begin
  BeginDraw(Canvas);
  Memo1.Assign(Memo);
  CurReport.InternalOnEnterRect(Memo1, Self);
  frInterpretator.DoScript(Script);
  if not Visible then Exit;
  Stream.Write(Typ, 1);
  frWriteString(Stream, ClassName);
  SaveToStream(Stream);
end;

procedure TfrControlView.DefinePopupMenu(Popup: TPopupMenu);
begin
  // no specific items in popup menu
end;

procedure TfrControlView.Assign(From: TfrView);
begin
  inherited;
  FControl := (From as TfrControlView).FControl;
end;

procedure TfrControlView.LoadFromStream(Stream: TStream);
var
  hasc:byte;
  cname:string;
  cmp:TComponent;
begin
  inherited;
  Stream.Read(hasc,1);
  if hasc = 0 then
    FControl := nil
  else begin
    cname := frReadString(Stream);
    if not Assigned(FControl) or (FControl.ControlName <> cname) then begin
      FControl := nil;
      cmp := frFindComponent(CurReport.Owner,cname);
      if Assigned(cmp) then
        FControl := TfrPrintableControl(cmp);
    end;
  end;
  if Assigned(FControl) then
    FControl.LoadFromStream(Stream);
end;

procedure TfrControlView.SaveToStream(Stream: TStream);
var
  hasc:byte;
begin
  inherited;
  hasc := 0;
  if Assigned(Fcontrol) then
    hasc := 1;
  Stream.Write(hasc,1);
  if Assigned(FControl) then begin
    frWriteString(Stream,FControl.ControlName);
    FControl.SaveToStream(Stream);
  end;
end;

var
  Bmp:TBitmap;

initialization
  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromResourceName(hInstance, 'Imagen');
    frRegisterObject(TfrControlView, Bmp, 'Control', nil);
  finally
    Bmp.Free;
  end;

end.
