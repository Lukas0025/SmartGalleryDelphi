unit uceni;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ExtDlgs, neuralNetwork, imageActions;

type
  TForm4 = class(TForm)
    Image1: TImage;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Button1: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    bmp: tbitmap;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses inteligentnigalerie;
{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
var learn: outputArray;
    i: integer;
begin
     Self.Enabled := False;

     if ComboBox1.ItemIndex <> -1 then begin
        learn := neauralNetwork.targetToOutput(ComboBox1.ItemIndex);
        neauralNetwork.learn(ImgActions.GetSymptomsForNN(bmp), learn);
        close;
     end else MessageDlg('Zadejte o jaký obrázek se jedná!', mtError, [mbOK], 0)
end;

procedure TForm4.FormCreate(Sender: TObject);
var i: integer;
begin
      OpenPictureDialog1.FileName := '';
      if OpenPictureDialog1.Execute then begin
            Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
            //Vytvoøení bitmapy
            bmp := ImgActions.loadBitmap(OpenPictureDialog1.FileName);
            bmp := ImgActions.ResizeBitmap(bmp, 100, 100);
            bmp := ImgActions.to64Color(bmp);

            //Nastavení aktuálního motivu
            self.Color := TForm1.themeColor.background;
            for i := 0 to self.ComponentCount - 1 do
                if self.Components[i] is TLabel then (self.Components[i] as TLabel).Font.Color := TForm1.themeColor.text;
      end else
        //Nelze použit close protože okno ještì neexistuje tak vytvoøím systémovou správu na zavøení (Spustí se až FormCreate bude dokonèeno)
        PostMessage(Handle, WM_CLOSE, 0, 0);
end;

end.
