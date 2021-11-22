// Adriano Santos de Lira Júnior
// executar seu próprio código C na placa FPGA (com argumentos) | Verifica se a entrada é impar ou par.
#include "verifica_impar_par.h"

int verifica_impar_par(int numero1, int numero2, int numero3) {
    if ((numero1 + numero2 + numero3) % 2 == 0) {
        return 2;
    } else {
        return 1;
    } 
}
