unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Actions,
  System.ImageList,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ActnList,
  Vcl.ImgList,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.ToolWin,
  Vcl.Menus,
  Vcl.ExtDlgs,

  hyiedefs,
  hyieutils,
  iexBitmaps,
  iesettings,
  iemio,
  iexLayers,
  iexRulers,
  iexToolbars,
  iexUserInteractions,
  imageenio,
  imageenproc,
  imageenview,
  ieview,
  iemview;

type
  TfrmMain = class(TForm)
    ImageEnMView1: TImageEnMView;
    ImageEnView1: TImageEnView;
    ImageEnIO1: TImageEnIO;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    Splitter1: TSplitter;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    ActionList1: TActionList;
    PopupMenu1: TPopupMenu;
    acRefresh: TAction;
    acSaveAs: TAction;
    SavePictureDialog1: TSavePictureDialog;
    mmSaveAs: TMenuItem;
    ToolButton2: TToolButton;
    procedure ExecSaveAs(Sender: TObject);
    procedure ImageEnMView1ImageSelect(Sender: TObject; idx: Integer);
    procedure ExecRefresh(Sender: TObject);
    procedure acSaveAsUpdate(Sender: TObject);
  strict private
    const
      WALL_PATH = 'Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets';
  private
    procedure Fill;
    procedure LoadFromIndex(const AIndex: Integer);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TForm1 }

uses
  System.IOUtils;

procedure TfrmMain.acSaveAsUpdate(Sender: TObject);
begin
  acSaveAs.Enabled := not ImageEnView1.IsEmpty;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;

  Fill;
end;

procedure TfrmMain.ExecRefresh(Sender: TObject);
begin
  Fill;
end;

procedure TfrmMain.ExecSaveAs(Sender: TObject);
begin
  with SavePictureDialog1 do
  begin
    if Execute(Handle) then
      ImageEnView1.IO.SaveToFileJpeg(FileName);
  end;
end;

procedure TfrmMain.Fill;
begin
  var LPath := ExtractFilePath(TPath.GetHomePath) + WALL_PATH;
  var LFiles := TDirectory.GetFiles(LPath, '*.*');

  ImageEnView1.Clear;
  ImageEnMView1.Clear();

  if Length(LFiles) > 0 then
  begin
    for var LFile in LFiles do
    begin
      var LIndex := ImageEnMView1.AppendImage;
      ImageEnMView1.ImageFileName[LIndex] := LFile;
    end;
  end;
end;

procedure TfrmMain.ImageEnMView1ImageSelect(Sender: TObject; idx: Integer);
begin
  LoadFromIndex(idx);
end;

procedure TfrmMain.LoadFromIndex(const AIndex: Integer);
begin
  ImageEnView1.IO.LoadFromFile(ImageEnMView1.ImageFileName[AIndex]);
  ImageEnView1.FitToWidth;
end;

end.
