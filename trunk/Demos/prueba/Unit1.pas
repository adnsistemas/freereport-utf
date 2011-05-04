unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, FR_DSet, FR_DBSet, IBCustomDataSet, IBQuery, IBDatabase, FR_Class,
  FR_Rich, StdCtrls, FR_Dock, ExtCtrls, FR_View;

type
  TForm1 = class(TForm)
    frReport1: TfrReport;
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    IBQuery1: TIBQuery;
    frDBDataSet1: TfrDBDataSet;
    DataSource1: TDataSource;
    Button1: TButton;
    IBQuery2: TIBQuery;
    frDBDataSet2: TfrDBDataSet;
    frPreview1: TfrPreview;
    frToolBar1: TfrToolBar;
    procedure frDBDataSet1Next(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses UDataEntity, UFRBaseReport, UADatabase;
{$R *.DFM}

procedure TForm1.frDBDataSet1Next(Sender: TObject);
var
  qrv:TfrRichView;
  bs:TStream;
begin
  qrv := frReport1.FindObject('Rich1')as TfrRichView;
  bs := IbQuery1.CreateBlobStream(IBQuery1.FindField('Notas'),bmRead);
  try
    qrv.LoadFromStream(bs);
  finally
    bs.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  DE:TDataEntity;
  RP:TFRBaseReport;
begin
  EntityBroker.DataBase := DataBase.MainDatabase;
  ReportBroker.AllwaysPrint := True;
  DE := EntityBroker.getEntity('Recibo');
  RP := ReportBroker.getReport('Recibo');
  RP.DataEntity := DE;
  De.Open;
  Rp.Reporte.ShowReport;
end;

end.
