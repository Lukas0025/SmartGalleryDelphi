unit zobrazeniobrazku;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    typ: integer;
    index: integer;
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses inteligentnigalerie;

{$R *.dfm}

procedure TForm2.FormResize(Sender: TObject);
begin
     SpeedButton1.Top := (ClientHeight - SpeedButton1.Height) div 2;
     SpeedButton2.Top := (ClientHeight - SpeedButton2.Height) div 2;
     SpeedButton1.Left := ClientWidth - SpeedButton1.Width - 5;

    if ((Image1.Picture.Width * ClientHeight) div Image1.Picture.Height) > ClientWidth then begin
      Image1.Width := ClientWidth;
      Image1.Height := (Image1.Picture.Height * ClientWidth) div Image1.Picture.Width;
    end else begin
      Image1.Height := ClientHeight;
      Image1.Width := (Image1.Picture.Width * ClientHeight) div Image1.Picture.Height;
    end;

    Image1.Top := (ClientHeight - Image1.Height) div 2;
    Image1.left := (ClientWidth - Image1.Width) div 2;
end;



procedure TForm2.SpeedButton1Click(Sender: TObject);
begin
    if Length(TForm1.sortImg[typ]) > index + 1 then begin
      index := index + 1;
      Image1.Picture.LoadFromFile(TForm1.sortImg[typ][index]);
      FormResize(self);
    end;
end;

procedure TForm2.SpeedButton2Click(Sender: TObject);
begin
    if index > 0 then begin
       index := index - 1;
       Image1.Picture.LoadFromFile(TForm1.sortImg[typ][index]);
       FormResize(self);
    end;
end;

end.
