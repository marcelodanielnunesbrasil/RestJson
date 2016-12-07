unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects, FMX.ListView, System.JSON,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdSSLOpenSSL;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    Image1: TImage;
    btnDownImage: TButton;
    Panel1: TPanel;
    btnLoad: TButton;
    btnDelete: TButton;
    btnExit: TButton;
    IdHTTP1: TIdHTTP;
    procedure btnDownImageClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ReadWebImage(imgAddress : string);
    function retira_aspas(str : string) : string;
  end;

var
  Form1: TForm1;
  mydata: string;
  jsv : TJsonValue;
  originalObject : TJsonObject;
  jsPair : TJsonPair;
  jsArr : TJsonArray;
  jso : TJsonObject;
  i : integer;
  LItem : TListViewItem;

implementation

{$R *.fmx}

procedure TForm1.btnDeleteClick(Sender: TObject);
begin
  ListView1.Items.Clear;
end;

procedure TForm1.btnDownImageClick(Sender: TObject);
begin
   ReadWebImage('https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcRscFsJVHyan9uXKyLT7II4bYyEn911yjBotzbNmyOQ0ms3HQD6dA');
end;

function GetURLAsString(const aurl: string): string;
var
  iHTTP : TidHTTP;
begin
    iHTTP := TIdHTTP.Create(nil);
    try
      iHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(iHTTP);
      result := iHTTP.Get(aurl);
    finally
       iHTTP.Free;
    end;
end;

procedure main;
begin
     try
        mydata := GetURLAsString('https://api.computersciencebr.me/index.php?token=marcelo2409&id=1');

     except
        on E: exception do

     end;

     try
        jsv := TJSONObject.ParseJSONValue(mydata);

        try
           originalObject := jsv as TJSONObject;

           jspair := originalObject.Get('usuario');

           jsArr := jsPair.JsonValue as TJsonArray;

           for I := 0 to jsArr.Size - 1 do
           begin
               jso := jsArr.Get(i) as TJsonObject;

               for jsPair in jso do
               begin
                   if jsPair.JsonString.Value = 'nome' then                   
                   begin
                       form1.ListView1.BeginUpdate;
                       LItem := form1.ListView1.Items.Add;
                       Litem.Text:= jso.GetValue('nome').ToString;
                       LItem.Detail := jso.GetValue('nome').ToString;
                       Litem.IndexTitle := jso.GetValue('foto').ToString;
                       form1.ListView1.EndUpdate;
                   end;
               end;      
           end;
        finally
         jsv.Free();
        end;

     except
           on E: Exception do
     end;
end;

procedure TForm1.btnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.btnLoadClick(Sender: TObject);
begin
  main;
end;

procedure TForm1.ReadWebImage(imgAddress : string);
var
 memStream : TMemoryStream;
begin
     memStream := TMemoryStream.Create;
     try
        IdHTTP1.Get(imgAddress, memStream);
     except
        ShowMessage('Image not found at: ' + imgAddress);
        memStream.Free;
        exit;
     end;

     try
         memStream.Position := 0;
         Image1.Bitmap.LoadFromStream(memStream);
     except
         memStream.Free;
     end;
end;

function TForm1.retira_aspas(str: string): string;
var
 tamanho : integer;
begin
     tamanho := Length(str);
     str := copy(str, 2, tamanho - 2);
     result := str;
end;

end.
