// Adriano Santos de Lira Júnior
// Controlador das águas - Exercício 2 da lista de OAC

/*
Para manter o controle das águas do açude de boqueirão, está sendo utilizado um
sensor que emite quatro sinais possíveis, descritos a seguir. Descrever o funcionamento do circuito.

11 -> sensor está com defeito ou descalibrado (“d”).
10 -> volume de água até 30% (Nível baixo, “b”);
01 -> volume de água acima de 30% e até 80% (Nível normal, “n”);
00 -> volume de água acima de 80% (Nível alto, “A”)
*/


parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

    always_comb begin
        LED <= SWI;
        lcd_WriteData <= SWI;
        lcd_pc <= 'h12;
        lcd_instruction <= 'h34567890;
        lcd_SrcA <= 'hab;
        lcd_SrcB <= 'hcd;
        lcd_ALUResult <= 'hef;
        lcd_Result <= 'h11;
        lcd_ReadData <= 'h33;
        lcd_MemWrite <= SWI[0];
        lcd_Branch <= SWI[1];
        lcd_MemtoReg <= SWI[2];
        lcd_RegWrite <= SWI[3];
        for(int i=0; i<NREGS_TOP; i++)
            if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
            else                   lcd_registrador[i] <= ~SWI;
        lcd_a <= {56'h1234567890ABCD, SWI};
        lcd_b <= {SWI, 56'hFEDCBA09876543};
    end

    //Criando variaveis que referentes aos caracteres a serem mostrados no display
    parameter A = 'h77;
    parameter d = 'h5e; 
    parameter b = 'h7c; 
    parameter n = 'h54; 

    parameter NBITS_SINAL = 2; //Representação do sinal
    logic [NBITS_SINAL-1:0] sinal;

    always_comb sinal <= SWI;
    always_comb //Logica do sistema de acordo com 4 possiveis sinais descritos anteriormente.
        if (sinal == 0)
            SEG <= A; 
        else if (sinal == 1) 
            SEG <= n; 
        else if (sinal == 2) 
            SEG <= b; 
        else    
            SEG <= d;
endmodule
