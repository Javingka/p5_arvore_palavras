/**
 *  Código para a criação de árvores compostas por palavras
 *  by Javier Cruz  
 *
*/

ArvorePalavras arvore;

void setup () {
  size (1200,700);
  arvore = new ArvorePalavras (8,3,25, "palabras5vocales.csv"); //niveis, galhos x nivel, altura do texto inicial, nome do arquivo com as palavras
}

void draw () {
  background(0);
  stroke(255);

  arvore.desenhaArvore();
  arvore.seePosiciones();

  text("click para criar uma nova árvore", width*.5, height*.95);
}

void mousePressed() {
   arvore.criaNovaArvore(); 
}
