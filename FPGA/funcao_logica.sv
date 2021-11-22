// Adriano Santos de Lira Júnior
// Implementação de função lógica - Exercício 3 da lista de OAC

/*
Implementar a função lógica F = AB+B´C+A´BC´
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

    //Criando variaveis referentes ao que sera mostrado no display de 7 segmentos
    parameter VAZIO = 'h00;
    parameter ZERO = 'h3f;
    parameter UM = 'h06;

    //Representação da expressão com a quantidade de bits necessario.
    parameter NBITS_EXPRESSAO = 3;
    logic [NBITS_EXPRESSAO-1:0] bits;

    always_comb bits <= SWI;
    always_comb 
        //entrada 000
        if (bits == 0)
            SEG <= ZERO;
        //entrada 001
        else if (bits == 1) 
            SEG <= UM; 
        //entrada 010
        else if (bits == 2) 
            SEG <= UM; 
        //entrada 011
        else if (bits == 3) 
            SEG <= ZERO; 
        //entrada 100
        else if (bits == 4) 
            SEG <= ZERO; 
        //entrada 101
        else if (bits == 5) 
            SEG <= UM; 
        //entrada 110
        else if (bits == 6) 
            SEG <= UM; 
        //entrada 111
        else if (bits == 7) 
            SEG <= UM;
        //vazio
        else                
            SEG <= VAZIO;
        
endmodule
