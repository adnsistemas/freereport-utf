
{*****************************************}
{                                         }
{             FastReport v2.3             }
{           Text export filter            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit fr_e_pdf;

interface

{$I FR.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Dialogs, FR_Class, SynPDF;

type
  TfrPDFExport = class(TComponent) // fake component
  end;

  TfrPDFExportFilter = class(TfrExportFilter)
  private
    FPDF:TPDFDocumentGDI;
    FPDFPage:TPdfPage;
    FFirstPage:boolean;
  public
    procedure OnBeginPage; override;
    procedure OnBeginDoc; override;
    procedure OnEndDoc; override;
    procedure OnData(x, y: Integer; View: TfrView); override;
  end;


implementation

uses FR_Utils, FR_Const;


procedure TfrPDFExportFilter.OnData(x, y: Integer; View: TfrView);
begin
  if View <> nil then
    View.Draw(FPDF.VCLCanvas);
end;

procedure TfrPDFExportFilter.OnEndDoc;
begin
  FPDF.SaveToStream(Stream);
  FPDF.Free;
end;

procedure TfrPDFExportFilter.OnBeginDoc;
begin
  FPDF := TPDFDocumentGDI.Create();
  FPDF.NewDoc;
  FPDFPage := FPDF.AddPage;
  FFirstPage := True;
end;

procedure TfrPDFExportFilter.OnBeginPage;
begin
  if not FFirstPage then
    FPDFPage := FPDF.AddPage;
  FFirstPage := False;
end;


initialization
  frRegisterExportFilter(TfrPDFExportFilter, 'PDF (*.pdf)', '*.pdf');

end.
