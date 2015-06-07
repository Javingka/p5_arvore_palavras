/**
 * A classe cria uma árvore utilizando palavras desde um arquivo .csv
 * nesse caso: 
 * http://www.solosequenosenada.com/2010/12/07/todas-las-palabras-que-contienen-todas-las-vocales-aeiou-listado-completo/
*/

class ArvorePalavras {
  String palavras[]; //array com todas as palavras pegadas do arquivo .csv
  PVector pos; //posição inicial desde onde cresce a árvore
  float anguloAberturaInicial; //angulo máximo de abertura inicial, vai se acrescentando por quanto cresce a árvore
  FloatList timesNoises; //Lista de floats que permite valores de 'Perlin noise' diferentes pra cada galho da árvore

  int contInt; //contador temporal de cada iteração dentro da função recursiva (ou contador de nós da árvore)
  int niveis; //quantos niveis de galhos terá a árvore
  int quantGalhos; //cant de galhos por nivel
  int nivelActual; //variavel para conhecer qual é o nivel que se esta desenhando em cada momento
  float tamTronco; //valor inicial pra a largura do tronco (altura do texto)
  StringList palavrasArvore; //lista com as palavras que serão parte do novo árvore que se cria

  ArrayList <PVector> Posiciones = new ArrayList <PVector>(); //não esta sendo utilizado
  PVector vectorDinamico; //um vetor que pega as coordenadas globais da posição dos galhos, vai se atualizando com cada novo galho desenhado
  
  PFont impa;
  
  ArvorePalavras (int _niveis, int _quantGalhos, float _tamanhoTronco, String arq) {
    palavras  = loadStrings(arq); //carregamos o array com as palavras de algum documento .csv
    println("Tem " + palavras.length + " palavras");
    impa = loadFont ("AndaleMono-48.vlw"); //A fonte a utilizar
    textFont(impa);
    niveis = _niveis;
    quantGalhos = _quantGalhos;
    tamTronco = _tamanhoTronco;
    pos = new PVector (width*.33, height*1.01);
    vectorDinamico = new PVector(0,0);
    anguloAberturaInicial = PI*.2;

    timesNoises = new FloatList();
    palavrasArvore = new StringList();

    novasPalavrasArvore(quantGalhos, niveis); //Gera o primeiro grupo de palavras para formar a árvore
  }

  void novasPalavrasArvore (int gal, int niv) {
    int pal = (int)pow(gal, niv); //a quantidade de palavras = quantidade de galhos ^ quantidade de niveis
    println ("Quantidade de palavras: "+pal);

    if (palavrasArvore.size() > 0) {
      palavrasArvore.clear();
      timesNoises.clear();
    }
    
    for (int p=0 ; p<niv ; p++)
      timesNoises.append(random(200)); //um numero entre 0 e o total de palavras disponíveis
      
    for (int p=0 ; p<pal ; p++) {
      int index = (int)random (palavras.length);
      String palavra = palavras[index];
      palavrasArvore.append(palavra);
    }
  }

  float colocaTexto(float altoPalavra) {
    pushMatrix();
    pushStyle();
      rotate(-PI/2);
      textSize(altoPalavra);
      String p = palavrasArvore.get(contInt);
      float sw = textWidth(p);
      text (p, 0, 0);
    popMatrix();
    popStyle();
    contInt++;
    return sw;
  }
  
  void updateArbol (){
    contInt=0; //o contador de nós volta a cero em cada novo frame
    vectorDinamico = new PVector(0,0); 
    Posiciones.clear(); 
    
    for (int t=0; t<timesNoises.size() ; t++)
       timesNoises.add (t, .005);
  }
  
  void desenhaArvore() {
    updateArbol ();
    
    pushMatrix();
    translate(pos.x, pos.y); //Deslocamento da posição inicial da árvore
    vectorDinamico.add (pos.x, pos.y, 0);
    
    float largoTexto = colocaTexto(tamTronco); //Desenha o texto e pega a largura dele
    translate(0, -largoTexto); //Deslocamento ao final do texto para desenhar os galhos seguintes
    vectorDinamico.add (0, -largoTexto, 0);
    //Primeira chamada à função 'branch' para desenhar a árvore
    branch(niveis, tamTronco, quantGalhos, anguloAberturaInicial);
    popMatrix();
  }

  void branch(int nivel, float altoPalabra, int cantR, float angInMax) {
    nivelActual = abs(nivel-niveis); //Calculo do nível atual (o tronco é nivel 0, cada novo nó soma um nível de profundidade)
    float onTime = timesNoises.get(nivelActual); //Cada nivel tem um valor Perlin para gerar o movimento tipo vento
    float thetaIn = noise (onTime)*angInMax; //se aplica Perlin Noise para obter um angulo de apertura dos galhos
    
    if (nivelActual > 4) 
              imprimeNiveis();

    textSize(altoPalabra); //define a altura da palavra
    altoPalabra *= .66; //a palavra desminui 1/3 o tamanho para o próximo galho
    angInMax *= 1.2; //O angulo de apertura cresci pra próximo galho
    nivel--; //disminui um nível de profundidade no desenho dos galhos

    if (nivelActual == 0 ) {
       // ellipse (0,0,50,50);
    }
    //Muda a quantidade de galhos, pra que os mais baixos sejan menos
    int cantRamaInt = cantR; 
    if (nivelActual < (niveis/2-2)) 
      cantRamaInt = cantR-1;
    if (nivel > 0) { //Por quanto estiver dentro dos niveis definidos
      for (int r=0 ; r<cantRamaInt ; r++)  {
        desenhaGalho (thetaIn, r, nivel, altoPalabra, cantR, angInMax); // desenha um novo galho
      }
    }
  }

  void desenhaGalho (float ang, int ramaNum, int nivel, float altoPalabra, int cantR, float angInMax) {
    //calculos para definit o ángulo de cada novo galho 
    float angXgalhos;
    switch (ramaNum) {
    case 0:
      angXgalhos  = ang;
      break;
    case 1:
      angXgalhos  = -ang;
      break;
    default:
      if (nivel<niveis/2) angXgalhos  = -ang*.5;
      else angXgalhos  = ang*.5;
      break;
    }

    pushStyle();
    pushMatrix();    //Guarda o estado atual de transformação, antes de aplicar novas transformações
    rotate(angXgalhos); //rotação segundo angXgalhos
    
    float largoTexto = colocaTexto(altoPalabra);
    
    translate(0, -largoTexto); //Desloca-se para o final do galho
    branch(nivel, altoPalabra, cantR, angInMax); //chamada pra desenhar novos galhos
    popMatrix();    
    popStyle();
  }

  void imprimeNiveis() {
    pushStyle();
    textSize(12);
    fill(255, 50+contInt%200);
    text (nivelActual, 25, 5); 
    popStyle();
    println ("nivelActual: "+nivelActual+" / contInt: "+contInt);
  }
  
  void criaNovaArvore () {
    novasPalavrasArvore(quantGalhos, niveis); 
  }
  
  void seePosiciones () {
    for (PVector p : Posiciones){
      line (0,0, p.x, p.y);
    }  
  }
  
}

