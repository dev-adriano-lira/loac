// Adriano Santos de Lira Júnior
// Lista de exercícios HDL do site de LOAC - ULA RISC-V 

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

    //Variaveis de operações
    parameter A_E_B = 'b000;
    parameter A_OU_B = 'b001;
    parameter SOMA = 'b010;
    parameter A_E_NAO_B = 'b100;
    parameter A_OU_NAO_B = 'b101;
    parameter SUBTRACAO = 'b110;
    parameter SLT = 'b111;
    parameter SAIDA_NOT_USED = 'b00; //Opção not used

    //Alocando tamanho
    parameter NBITS_OPERACAO = 2;
    parameter NBITS_SAIDA = 2;
    parameter CHAVE_CONTROLE = 3;

    logic [NBITS_OPERACAO-1:0] a;
    logic [NBITS_OPERACAO-1:0] b;
    logic [CHAVE_CONTROLE-1:0] chave_controle;
    
    //Atrubuindo entradas aos switches equivalentes
    always_comb a <= SWI[3:2];
    always_comb b <= SWI[1:0];
    always_comb chave_controle <= SWI[6:4];
    
    //Lógica do sistema
    always_comb
    case(chave_controle)
        A_E_B: LED[1:0] <= a & b;
        A_OU_B: LED[1:0] <= a | b;
        SOMA: LED[1:0] <= a + b;
        A_E_NAO_B: LED[1:0] <= a & (!b);
        A_OU_NAO_B: LED[1:0] <= a | (!b);
        SUBTRACAO: LED[1:0] <= a - b;
        SLT: LED[1:0] <= a < b;
        default: LED[1:0] <= SAIDA_NOT_USED;
    endcase

endmodule
