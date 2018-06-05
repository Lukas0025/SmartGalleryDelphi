program inteligentnigalerie_proj;

uses
  Vcl.Forms,
  inteligentnigalerie in 'inteligentnigalerie.pas' {Form1},
  zobrazeniobrazku in 'zobrazeniobrazku.pas' {Form2},
  oaplikaci in 'oaplikaci.pas' {Form3},
  uceni in 'uceni.pas' {Form4},
  neuralNetwork in 'neuralNetwork.pas',
  imageActions in 'imageActions.pas',
  manual in 'manual.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
