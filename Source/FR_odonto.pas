
{*****************************************}
{                                         }
{             FastReport v2.3             }
{         Odontograma Add-In Object       }
{                                         }
{  Copyright (c) 2009 by ADN Sistemas     }
{                                         }
{*****************************************}

unit FR_odonto;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Menus, FR_Class,
  Odontograma;


type
  TfrOdontogramaObject = class(TComponent)  // fake component
  end;

  TfrOdontogramaView = class(TfrView)
  private
    FOgrama:TOdontograma;
  public
    property Odontograma:TOdontograma read FOgrama write FOgrama;
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

constructor TfrOdontogramaView.Create;
begin
  inherited Create;
  Typ := gtAddIn;
  FrameWidth := 2;
  BaseName := 'Odontograma';
end;

procedure TfrOdontogramaView.Draw(Canvas: TCanvas);
begin
  BeginDraw(Canvas);
  Memo1.Assign(Memo);
  CalcGaps;
  ShowBackground;
  if Assigned(FOgrama) then begin
    FOgrama.Width := dx;
    FOgrama.Height := dy;
    FOgrama.PaintIn(Canvas,DRect.TopLeft);
  end;
  ShowFrame;
  RestoreCoord;
end;

procedure TfrOdontogramaView.Print(Stream: TStream);
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

procedure TfrOdontogramaView.DefinePopupMenu(Popup: TPopupMenu);
begin
  // no specific items in popup menu
end;

procedure TfrOdontogramaView.Assign(From: TfrView);
begin
  inherited;
  FOgrama := (From as TfrOdontogramaView).FOgrama;
end;

procedure TfrOdontogramaView.LoadFromStream(Stream: TStream);
begin
  inherited;
  if Assigned(FOgrama) then
    FOgrama.Load(Stream);
end;

procedure TfrOdontogramaView.SaveToStream(Stream: TStream);
begin
  inherited;
  if Assigned(FOgrama) then
    fOgrama.Save(Stream);
end;

var
  Bmp:TBitmap;
  
initialization
  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromResourceName(hInstance, 'Odonto');
    frRegisterObject(TfrOdontogramaView, Bmp, 'Odontograma', nil);
  finally
    Bmp.Free;
  end;

end.
