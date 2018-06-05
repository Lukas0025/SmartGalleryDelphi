unit imageActions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, neuralNetwork;

type
  RGBArray = record
                  r: Byte;
                  g: Byte;
                  b: Byte;
  end;

  HistogramArray = array[0..63] of integer;

  ImgActions = Class

  private
    class procedure addHistToInput(var addto: inputArray; add: HistogramArray; index: byte);

  public
    Destructor  Destroy; override;
    class function getPixelColor(x: integer; y: integer; Bitmap: TBitmap): RGBArray;
    class function to64Color(Bitmap: TBitmap): TBitmap;
    class function ResizeBitmap(Bitmap: TBitmap; Width, Height: integer): TBitmap;
    class function loadBitmap(location: String): TBitmap;
    class function GetSymptomsForNN(bitmap: TBitmap): inputArray;
    class function get64ColorIndex(value: byte): byte;
    class function getHistogram(formX: integer; fromY: integer; toX: integer; toY: integer; Bitmap: TBitmap): HistogramArray;

end;

implementation

class procedure ImgActions.addHistToInput(var addto: inputArray; add: HistogramArray; index: byte);
var i, from: integer;
begin
    from := 64 * index;
    for i := from to from + 63 do addto[i] := add[i - from];
end;

destructor ImgActions.Destroy;
begin
  inherited;
end;

class function ImgActions.getPixelColor(x: integer; y: integer; Bitmap: TBitmap): RGBArray;
var Color: longint;
    Output: RGBArray;
begin
     Color := ColorToRGB(Bitmap.Canvas.Pixels[x,y]);
     Output.R := GetRValue(Color);
     Output.G := GetGValue(Color);
     Output.B := GetBValue(Color);

     getPixelColor := Output;
end;

class function ImgActions.ResizeBitmap(Bitmap: TBitmap; Width, Height: integer): TBitmap;
var
  buffer: TBitmap;
begin
  buffer := TBitmap.Create;
  try
    buffer.SetSize(Width, Height);
    buffer.Canvas.StretchDraw(Rect(0, 0, Width, Height), Bitmap);
    Bitmap.SetSize(Width, Height);
    Bitmap.Canvas.Draw(0, 0, buffer);
  finally
    ResizeBitmap := Bitmap;
    buffer.Free;
  end;
end;

class function ImgActions.loadBitmap(location: string): TBitmap;
var Picture: TPicture;
begin
     Picture := TPicture.Create;
     Picture.LoadFromFile(location);
     loadBitmap := TBitmap.Create;
     loadBitmap.Width := Picture.Width;
     loadBitmap.Height := Picture.Height;
     loadBitmap.Canvas.Draw(0, 0, Picture.Graphic);
     Picture.Free;
end;

//http://fd501.com/home/blog/coco-color-palette/
class function ImgActions.to64Color(Bitmap: TBitmap): TBitmap;
var i, j: integer;
    RGBcolor: RGBArray;
begin
     for i := 0 to Bitmap.Height - 1 do
        for j := 0 to Bitmap.Width - 1 do begin
             //Získání z pixelu
             RGBcolor := getPixelColor(j, i, Bitmap);
             //Pøevod na baravný model s 64 barvamy
             RGBcolor.r := get64ColorIndex(RGBcolor.r) * 85;
             RGBcolor.g := get64ColorIndex(RGBcolor.g) * 85;
             RGBcolor.b := get64ColorIndex(RGBcolor.b) * 85;
             //Zapsaní do pixelu
             Bitmap.Canvas.Pixels[j, i] := RGB(RGBcolor.r, RGBcolor.g, RGBcolor.b);
        end;

        to64Color := Bitmap;

end;

class function ImgActions.get64ColorIndex(value: byte): byte;
begin
     get64ColorIndex := round(value / 85);
end;

class function ImgActions.GetSymptomsForNN(bitmap: TBitmap): inputArray;
var i, j, halfX, halfY: integer;
    Histogram: HistogramArray;
    output: inputArray;
begin
    halfX := round(Bitmap.Width / 2);
    halfY := round(Bitmap.Height / 2);

    //Okraj na levé a pravé stranì
    addHistToInput(output, getHistogram(0, 0, halfX, Bitmap.Height, bitmap), 0);
    addHistToInput(output, getHistogram(halfX, 0, Bitmap.Width, Bitmap.Height, bitmap), 1);

    //Horní a spodní èást
    addHistToInput(output, getHistogram(0, 0, Bitmap.Width, halfY, bitmap), 2);
    addHistToInput(output, getHistogram(0, halfY, Bitmap.Width, Bitmap.Height, bitmap), 3);

    GetSymptomsForNN := output;
end;

class function ImgActions.getHistogram(formX: integer; fromY: integer; toX: integer; toY: integer; Bitmap: TBitmap): HistogramArray;
var i, j: integer;
    Histogram: HistogramArray;
    index: byte;
    RGBcolor: RGBArray;
begin
     //nulování array
     for i := 0 to 63 do Histogram[i] := 0;

     for i := formX to toX do
        for j := fromY to toY do begin
            RGBcolor := getPixelColor(i, j, Bitmap);
            //R + (G * 4 ** 1) + (B * 4 ** 2)
            //Max cislo pro RGB je 3 poèítáno od nuly
            index := get64ColorIndex(RGBcolor.r) + (get64ColorIndex(RGBcolor.g) * 4) + (get64ColorIndex(RGBcolor.b) * 16);
            Histogram[index] := Histogram[index] + 1;
        end;

     getHistogram := Histogram;

end;

end.
