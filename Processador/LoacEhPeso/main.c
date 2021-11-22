// Adriano Santos de Lira Júnior
// executar seu próprio código C na placa FPGA (com argumentos) | Verifica se a entrada é impar ou par.
#include "verifica_impar_par.h"

void __attribute__ ((naked)) main() {
    volatile int * const io = (int *)(0x3F*4);

    int numero1, numero2, numero3;

    numero1 = *io; // Obtém o valor do primeiro lado de SWI[4:0]
    numero2 = *io; // Obtém o valor do primeiro lado de SWI[4:0]
    numero3 = *io; // Obtém o valor do primeiro lado de SWI[4:0]

   /*
        A partir da função verifica_impar_par, o programa verificar as entradas passadas e 
        assim verifica se o numero passado é ímpar ou par. A verificação é mostrada da seguinte maneira:
        - par: acende o LED 2;
        - ímpar: acende o LED 1.
   */
    *io = verifica_impar_par(numero1, numero2, numero3); // Resultado da análise irá para saída - LED[4:0]
}
