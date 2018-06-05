unit neuralNetwork;

interface

Const
  numOfNeuronInHiddenLayer = 5; // poèet neuronù + 1 v skrytých vrstevách neuronové sítì. (èím vìtší tím více se neuronová sít zamìruje na detaily)
  learnspeed = 0.8;

type
  inputArray = array [0 .. 255] of integer;
  outputArray = array [0 .. 3] of double;

  synapticRecord = record
    Layer1: Array [0 .. numOfNeuronInHiddenLayer, 0 .. 255] of double;
    Layer2, Layer3: Array [0 .. numOfNeuronInHiddenLayer,
      0 .. numOfNeuronInHiddenLayer] of double;
    LayerO: Array [0 .. 3, 0 .. numOfNeuronInHiddenLayer] of double;
  end;

  neauralNetwork = Class
  private
    // Slouží k predávání dat mezi vrstvamy
    class var outputData: record Layer1, Layer2, Layer3: Array [0 .. numOfNeuronInHiddenLayer] of double;
    end;

  class function sigmoid(x: double): double;
  class function derivative(x: double): double;
  class function CalcCorectWeights(input: double; fail: double; thinkout: double): double;

public
  class var synapticWeights: synapticRecord;
  constructor Create;
  Destructor  Destroy; override;
  class procedure RandomSynapticWeights;
  class procedure learn(input: inputArray; target: outputArray);
  class function think(input: inputArray): outputArray;
  class function targetToOutput(target: integer): outputArray;
  class function outputToTarget(output: outputArray): integer;
end;

implementation

uses SysUtils, Windows, Math;

constructor neauralNetwork.Create;
begin
  RandomSynapticWeights;
end;

destructor neauralNetwork.Destroy;
begin
  FreeAndNil(synapticWeights);
  FreeAndNil(outputData);
end;

class function neauralNetwork.targetToOutput(target: integer): outputArray;
var i: integer;
    o: outputArray;
begin
     for i:= 0 to 3 do if i = target then o[i] := 1
                       else o[i] := 0;

     targetToOutput := o;
end;

class function neauralNetwork.outputToTarget(output: outputArray): integer;
var i, max: integer;
begin
     max := 0;

     for i:= 1 to 3 do if output[max] < output[i] then max := i;

     outputToTarget := max;
end;

class procedure neauralNetwork.RandomSynapticWeights;
var
  i, j: integer;
begin
  with synapticWeights do
  begin
    for i := 0 to numOfNeuronInHiddenLayer do
    begin
      Randomize;
      // Vrstva 1
      for j := 0 to 255 do
        Layer1[i][j] := Random(100) / 100;
      // Vrstva 2 a 3
      for j := 0 to numOfNeuronInHiddenLayer do
      begin
        Layer2[i][j] := Random(100) / 100;
        Layer3[i][j] := Random(100) / 100;
      end;

    end;

    // Vrstva o
    for i := 0 to 3 do
      for j := 0 to numOfNeuronInHiddenLayer do
        LayerO[i][j] := Random(100) / 100;

  end;
end;

// Sigmoid, popisuje køivku tvaru S
// Normalizuje mezi 0 a 1
class function neauralNetwork.sigmoid(x: double): double;
begin
  // exp() provádí e na x-tou
  sigmoid := 1 / (1 + exp(-x));
end;

// Derivace pro Sigmoidní køivku
class function neauralNetwork.derivative(x: double): double;
begin
  derivative := x * (1 - x);
end;

class function neauralNetwork.CalcCorectWeights(input: double; fail: double; thinkout: double): double;
begin
  CalcCorectWeights := input * fail * derivative(thinkout) * learnspeed;
end;

class procedure neauralNetwork.learn(input: inputArray; target: outputArray);
var thinkOutput: outputArray;
    fail: record Layer1, Layer2, Layer3: Array [0 .. numOfNeuronInHiddenLayer] of double;
                 LayerO: array [0..3] of double;
          end;
    i, j: integer;
    s: double;
begin
  thinkOutput := think(input);

  //Výpoèet odchilky pro výstupní vrstvu
  for i := 0 to 3 do
    fail.LayerO[i] := target[i] - thinkOutput[i];


  //Výpoèet odchylky pro skryté vrstvy
  //Podle https://brilliant.org/wiki/backpropagation/
  //derivát(výstup) * suma(následující_vrstva_error * váha_vstupu_na_následijící_vrstvì)

  //Vrstva 3
  for i := 0 to numOfNeuronInHiddenLayer do begin
      s := 0;

      for j := 0 to 3 do begin
        s := s + (synapticWeights.LayerO[j][i] * fail.LayerO[i]);
      end;

      fail.Layer3[i] := derivative(outputData.Layer3[i]) * s;
  end;

  //Vrstva 2
  for i := 0 to numOfNeuronInHiddenLayer do begin
      s := 0;

      for j := 0 to numOfNeuronInHiddenLayer do begin
        s := s + (synapticWeights.Layer3[j][i] * fail.Layer3[i]);
      end;

      fail.Layer2[i] := derivative(outputData.Layer2[i]) * s;
  end;

  //Vrstva 1
  for i := 0 to numOfNeuronInHiddenLayer do begin
      s := 0;

      for j := 0 to numOfNeuronInHiddenLayer do begin
        s := s + (synapticWeights.Layer2[j][i] * fail.Layer2[i]);
      end;

      fail.Layer1[i] := derivative(outputData.Layer1[i]) * s;
  end;

  //Korekce synaptických vah

  //Vrstva O
  for i := 0 to 3 do
    for j := 0 to numOfNeuronInHiddenLayer do synapticWeights.LayerO[i][j] := synapticWeights.LayerO[i][j] + CalcCorectWeights(outputData.Layer3[j], fail.LayerO[i], thinkoutput[i]);

  //Vrstva 3
  for i := 0 to numOfNeuronInHiddenLayer do
    for j := 0 to numOfNeuronInHiddenLayer do synapticWeights.Layer3[i][j] := synapticWeights.Layer3[i][j] + CalcCorectWeights(outputData.Layer2[j], fail.Layer3[i], outputData.Layer3[i]);

  //Vrstva 2
  for i := 0 to numOfNeuronInHiddenLayer do
    for j := 0 to numOfNeuronInHiddenLayer do synapticWeights.Layer2[i][j] := synapticWeights.Layer2[i][j] + CalcCorectWeights(outputData.Layer1[j], fail.Layer2[i], outputData.Layer2[i]);

  //Vrstva 1
  for i := 0 to numOfNeuronInHiddenLayer do
    for j := 0 to 255 do synapticWeights.Layer1[i][j] := synapticWeights.Layer1[i][j] + CalcCorectWeights(input[j], fail.Layer1[i], outputData.Layer1[i]);
end;

class function neauralNetwork.think(input: inputArray): outputArray;
var
  i, j: integer;
  a: outputArray;
begin
  // Nulování array
  for i := 0 to 3 do
    a[i] := 0;
  for i := 0 to numOfNeuronInHiddenLayer do
    with outputData do
    begin
      Layer1[i] := 0;
      Layer2[i] := 0;
      Layer3[i] := 0;
    end;

  // Vrstva 1
  for i := 0 to numOfNeuronInHiddenLayer do begin
    for j := 0 to 255 do outputData.Layer1[i] := outputData.Layer1[i] + synapticWeights.Layer1[i][j] * (input[j] / 5000);
    outputData.Layer1[i] := sigmoid(outputData.Layer1[i]);
  end;

  // Vrstva 2
  for i := 0 to numOfNeuronInHiddenLayer do begin
    for j := 0 to numOfNeuronInHiddenLayer do outputData.Layer2[i] := outputData.Layer2[i] + synapticWeights.Layer2[i][j] * outputData.Layer1[j];
    outputData.Layer2[i] := sigmoid(outputData.Layer2[i]);
  end;

  // Vrstva 3
  for i := 0 to numOfNeuronInHiddenLayer do begin
    for j := 0 to numOfNeuronInHiddenLayer do outputData.Layer3[i] := outputData.Layer3[i] + synapticWeights.Layer3[i][j] * outputData.Layer2[j];
    outputData.Layer3[i] := sigmoid(outputData.Layer3[i]);
  end;

  // Výstupní vrstva
  for i := 0 to 3 do begin
    for j := 0 to numOfNeuronInHiddenLayer do a[i] := a[i] + synapticWeights.LayerO[i][j] * outputData.Layer3[j];
    a[i] := sigmoid(a[i]);

  end;

  //Ladìní
  i := outputToTarget(a);
  OutputDebugString(PChar('Idetifikována situace ' + IntToStr(i) + ' s pravdìpodobností ' + FloatToStr(a[i])));

  think := a;
end;

end.

