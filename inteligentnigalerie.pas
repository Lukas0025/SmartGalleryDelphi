unit inteligentnigalerie;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls, System.DateUtils,
  Vcl.Imaging.jpeg, FileCtrl, System.IOUtils, imageActions, System.Types, oaplikaci, zobrazeniobrazku, uceni, NeuralNetwork, System.StrUtils, manual;

const
  learnLoop = 100; //Poèet Opakování uèení +1

type
  sortImgArray = array[0..3] of array of string; //Dynamická array

  TForm1 = class(TForm)
    Image1: TImage;
    Image3: TImage;
    Image5: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    Soubor1: TMenuItem;
    Otovtsouborpamti1: TMenuItem;
    Uloitsouborpamti1: TMenuItem;
    N1: TMenuItem;
    Spustituen1: TMenuItem;
    Monosti1: TMenuItem;
    mavvzhled1: TMenuItem;
    Svtlvzhled1: TMenuItem;
    Pomoc1: TMenuItem;
    Npovda1: TMenuItem;
    Oprogramu1: TMenuItem;
    N2: TMenuItem;
    Adressobrzky1: TMenuItem;
    N3: TMenuItem;
    Label5: TLabel;
    Spustituenzesouboru1: TMenuItem;
    Image2: TImage;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    progressLabel: TLabel;
    Panel1: TPanel;
    procedure Oprogramu1Click(Sender: TObject);
    procedure Spustituen1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Adressobrzky1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Spustituenzesouboru1Click(Sender: TObject);
    procedure Uloitsouborpamti1Click(Sender: TObject);
    procedure Otovtsouborpamti1Click(Sender: TObject);
    procedure mavvzhled1Click(Sender: TObject);
    procedure showProgress;
    procedure hideProgress;
    procedure Npovda1Click(Sender: TObject);
  private
    procedure sortImages;
    procedure learnFromDir(learnDir: string);
    { Private declarations }
  public
    { Public declarations }
    class var themeColor: record text: TColor;
                                 background: Tcolor;
          end;
    class var sortImg: sortImgArray;
    class var dir: string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{
Interier: 0;
Sken: 1;
Nocni Scena: 2;
Krajina: 3;
}

procedure TForm1.showProgress;
begin
     self.Menu := nil;
     Panel1.Visible := false;
     progressLabel.Visible := true;
end;

procedure TForm1.hideProgress;
begin
     self.Menu := MainMenu1;
     Panel1.Visible := true;
     progressLabel.Visible := false;
end;

procedure TForm1.Adressobrzky1Click(Sender: TObject);
begin
     if FileCtrl.SelectDirectory(dir, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then sortImages;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     neauralNetwork.Create;
     themeColor.background := clBtnFace;
     themeColor.text := clBlack;
end;

procedure TForm1.Image1Click(Sender: TObject);
var id: integer;
begin
     id := (Sender as TComponent).Tag;
     if Length(sortImg[id]) > 0 then with TForm2.Create(nil) do
        try
          typ := id;
          index := 0;
          Image1.Picture.LoadFromFile(TForm1.sortImg[id][index]);

          ShowModal;
        finally
          //Uvolnìní pamìti
          Free
     end else MessageDlg('Neexistuje žádný obrázek zaøezaný do této kategorie. Prosím vyberte adresáø s obrázky který takový obrázek obsahuje (hlavní menu > možnosti > adresáø s obrázky)', mtError, [mbOK],0);

end;

procedure TForm1.mavvzhled1Click(Sender: TObject);
var i: integer;
begin
   (Sender as TMenuItem).Checked := true;

   if mavvzhled1.Checked then begin
                                  themeColor.background := RGB(91, 91, 91);
                                  themeColor.text := clWhite;
                         end else begin
                                  themeColor.background := clBtnFace;
                                  themeColor.text := clBlack;
                         end;

   self.Color := TForm1.themeColor.background;
   for i := 0 to self.ComponentCount - 1 do
       if self.Components[i] is TLabel then (self.Components[i] as TLabel).Font.Color := TForm1.themeColor.text;
end;

procedure TForm1.Npovda1Click(Sender: TObject);
begin
    with TForm5.Create(nil) do
      try
        ShowModal;
      finally
        //Uvolnìní pamìti
        Free;
    end;
end;

procedure TForm1.SortImages;
var images: System.Types.TStringDynArray;
    i, index: Integer;
    bmp: TBitmap;
begin
     for i := 0 to 3 do SetLength(sortImg[i], 0);

     images :=  System.IOUtils.TDirectory.GetFiles(dir, '*.jpg');
     showProgress;
     progressLabel.Caption := 'Klasifikuji obrázeky 0%';

     for i := 0 to Length(images) - 1 do begin
            //Vytvoøení bitmapy
            bmp := ImgActions.loadBitmap(images[i]);
            bmp := ImgActions.ResizeBitmap(bmp, 100, 100);
            bmp := ImgActions.to64Color(bmp);
            index := neauralNetwork.outputToTarget(neauralNetwork.think(ImgActions.GetSymptomsForNN(bmp)));
            //Zmìna velikosti array
            SetLength(sortImg[index], Length(sortImg[index]) + 1);
            sortImg[index][Length(sortImg[index]) - 1] := images[i];
            progressLabel.Caption := 'Klasifikuji obrázeky ' + IntToStr(round(i / (Length(images) - 1) * 100)) + '%';
            //Fix Form freezes by loop
            Application.ProcessMessages;
     end;
     bmp.Free;
     hideProgress;
end;

procedure TForm1.Oprogramu1Click(Sender: TObject);
begin
    with TForm3.Create(nil) do
      try
        ShowModal;
      finally
        //Uvolnìní pamìti
        Free;
    end;
end;

procedure TForm1.Otovtsouborpamti1Click(Sender: TObject);
var f: file of synapticRecord;
begin
    OpenDialog1.FileName := '';
    if openDialog1.Execute then begin
        AssignFile(f, OpenDialog1.FileName);
        reset(f);
        if not Eof(f) then begin
           read(f, neauralNetwork.synapticWeights);
           CloseFile(f);
           MessageDlg('Naèteno', mtInformation, [mbOK], 0);
        end else MessageDlg('Naètení se nezdaøilo', mtError, [mbOK], 0);
    end;
end;

procedure TForm1.Spustituen1Click(Sender: TObject);
begin
  with TForm4.Create(nil) do
      try
        ShowModal;
      finally
        //Uvolnìní pamìti
        Free;
    end;
end;

procedure TForm1.learnFromDir(learnDir: string);
var images, imageSplit: System.Types.TStringDynArray;
    i, j, index: Integer;
    numlearn, time: real;
    timewr: string[100];
    bmp: TBitmap;
begin
     images :=  System.IOUtils.TDirectory.GetFiles(learnDir, '*.jpg');
     showProgress;
     numlearn := Length(images) * (learnLoop + 1);
     timewr := '??';
     progressLabel.Caption := 'Provádím uèení  0 / ' + FloatToStr(numlearn) + ' - ' + timewr + ' minut';

     for j := 0 to learnLoop do begin
            time := MillisecondOfTheDay(Now);
            for i := 0 to Length(images) - 1 do begin
                //Vytvoøení bitmapy
                bmp := ImgActions.loadBitmap(images[i]);
                bmp := ImgActions.ResizeBitmap(bmp, 100, 100);
                bmp := ImgActions.to64Color(bmp);
                imageSplit := SplitString(images[i], '\');
                index := StrToInt(StringReplace(imageSplit[Length(imageSplit) - 1], '.jpg', '', [rfReplaceAll, rfIgnoreCase]));
                neauralNetwork.learn(ImgActions.GetSymptomsForNN(bmp), neauralNetwork.targetToOutput(index div 10));
                progressLabel.Caption := 'Provádím uèení ' + IntToStr(i +  (j * Length(images))) + ' / ' + FloatToStr(numlearn) + ' - ' + timewr + ' minut';
                //Fix Form freezes by loop
                Application.ProcessMessages;
            end;
          time := (MillisecondOfTheDay(Now) - time) / 1000;
          timewr := FloatToStr(round(time * (learnLoop - j) / 60));
      end;
      bmp.Free;
      hideProgress;
end;

procedure TForm1.Spustituenzesouboru1Click(Sender: TObject);
var learnDir: string;
begin
     if FileCtrl.SelectDirectory(learnDir, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then learnFromDir(learnDir);
end;

procedure TForm1.Uloitsouborpamti1Click(Sender: TObject);
var f: file of synapticRecord;
begin
     SaveDialog1.FileName := '';
     if saveDialog1.Execute then begin
        AssignFile(f, saveDialog1.FileName);
        ReWrite(f);
        Write(f, neauralNetwork.synapticWeights);
        CloseFile(f);
        MessageDlg('Uloženo', mtInformation, [mbOK], 0);
     end;
end;

end.
