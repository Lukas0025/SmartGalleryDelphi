# Smart Gallery Delphi
CS:

Inteligentní Galerie je aplikací Umělé neuronové sítě

Je nutné si uvědomit že se jedná o algoritmus AI (Umělé inteligence) a díky tomu je se program schopný "poučit ze svých chyb"

z toho vyplývají tyto nevýhody:


	Pokud 3x provedeme nové (učení od 0) učení je možné že bude mít pokaždé jiné vysledky (synaptické váhy jsou na začátku nastaveny náhodně mezi 0 a 1)
	
	Aby byla neuronová sít při klasifikaci co nejúspěšnější je nutné učení zopakovat mnohokrát po sobě (Klidně se stejnýmy obrázky)
        
	pro účel ke kterému neuronovou síť používám by bylo vhodné zapokavat učící sadu alespoň 50 000
        
	Bohužel dephi není příliž jazykem rychlím a tolik opakování není časově přípustné
        
	Z tohoto důvodu soubor přiložený na disku (Ukázka synaptických vah po učení - paměť neuronové sítě) má za sebou pouze 4 000 opakování
        
	toto je důvod proč neuronavá síť nejspíše spoustu neznámých obrázků (Nebyly v učící sadě) zařadí špatně



Postup pro spuštění (Klasifikace obrázků)
	
	Spusťte aplikaci
	
        menu>soubor>otevřít soubor paměti...
	
        vyberte soubor paměti
	
        menu>možnosti>adresář s obrázky...
	
        vyberte adresář který chcete klasifikovat
	
	Nyní se provede klasifikace obrázků
	
	Klikněte na kategorii ze které obrázky chcete zobrazit


Postup pro spuštění (učení)
	
	Spusťte aplikaci
        
	menu>soubor>spustit učení ze složky...
        
	vyberte adresář který obashuje učící sadu (40 obrázků) 0..9 -> interiér, 10..19 -> scan, 20..29 -> noční krajina, 30..39 -> krajina
        
	menu>možnosti>adresář s obrázky...
		Poznámka: Učení nepřinese příliž zlepšení, protože trénovací sadu si spustí pouze 101 (Lze změnit v kódu jedná se o konstantu) díky tomu většinu obrázků nezařadí správně, nicméně by již měla být schopná nějaká obrázek/obrázky zařadit správně
        
	vyberte adresář který chcete klasifikovat
	
	Nyní se provede klasifikace obrázků
	
	Klikněte na kategorii ze které obrázky chcete zobrazit
	

Konstanty:
	
	learnLoop ... Počet opakování učící sady
	
	numOfNeuronInHiddenLayer ... počet neuronů + 1 v skrytých vrstevách neuronové sítě. (čím větší tím více se neuronová sít zaměruje na detaily)
	
	learnspeed ... rychlost učení ovlivňuje velikost korekcí synaptických vah (Zmenšuje/Zvětšuje) 1 je normální rychlost
	
 EN:
 
 The Intelligent Gallery is an Artificial Neural Network application
 
It is necessary to realize that it is an algorithm of AI (Artificial Intelligence) and that is why the program is able to "learn from its mistakes"

there are the following disadvantages:
```
If we do 3 times (learning from 0) learning, it is possible that they will have different results each time (synaptic scales are at random set at random between 0 and 1)

In order for the neural network to be the most successful in classifying, it is necessary to repeat the teachings many times in 

succession (Quietly with the same pictures)
        
for the purpose to which I am using the neuron network, it would be advisable to engage a learning set of at least 50,000
        
Unfortunately, dephi is not a fast language, and so many repetitions are not time-consuming
        
For this reason, the file attached to the disk (Synaptic Weighing Sample - Neural Network Memory) has only 4,000 reps
        
this is why the neural network probably has a lot of unknown images (They were not in the learning set)
```


Startup procedure (Image Classification)
```
Run the app
        
menu> file> open memory file ...
        
select a memory file
        
menu> options> folder with pictures ...
        
select the directory you want to classify

Image classification is now performed
	
Click on the category from which images you want to view
```

Startup procedure (learning)
```
Run the app
	
menu> file> start learning from folder ... (40 pictures) 0..9 -> interior, 10..19 -> scan, 20..29 -> night landscape, 30..39 -> landscape
	
menu> options> folder with pictures ...
	
Note: Learning will not bring any improvement, because the training set will only start 101 (It can be changed in the code is a constant), because most of the pictures do not perform correctly, but some picture should be able
```	
