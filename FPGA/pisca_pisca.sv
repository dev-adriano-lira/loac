// Adriano Santos de Lira Júnior
// Pisca-pisca com reset, congelamento e mudança de sentido

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

  parameter NBITS_PISCA = 8; //Número de bits da saída do pisca-pisca (LEDs)
  parameter INICIO_DIREITA = 'b10000000; //Inicio do sentido para a direita
  parameter INICIO_ESQUERDA = 'b00000001; //Inicio do sentido para a esquerda
  parameter NBITS_ENTRADA = 1; //Número de bits das entradas das funcionalidades

  logic [NBITS_PISCA-1:0] saida; //Atribuindo a saída do pisca pisca aos LEDs
  logic [NBITS_ENTRADA-1:0] reset; //Atribuindo entrada do reset
  logic [NBITS_ENTRADA-1:0] parar; //Atribuindo entrada da parada
  logic [NBITS_ENTRADA-1:0] muda_sentido; //Atribuindo entrada do sentido

  always_comb begin
    reset <= SWI[0]; //Atribuindo entrada da funcionalidade do reset, só volta a funcionar o led quando o switch é desativado.
    parar <= SWI[1]; //Atribuindo entrada da funcionalidade do congelamento
    muda_sentido <= SWI[2]; //Atribuindo entrada da funcionalidade de mudança de sentido
  end

  //Logica do sistema
  always_ff @(posedge clk_2 ) begin
    if ((saida == 0 || reset == 1) && muda_sentido == 0) 
        saida <= INICIO_DIREITA; //Reinicia o sentido quando esta para direita ou faz um overflow.
    else if ((saida == 0 || reset == 1) && muda_sentido == 1) 
        saida <= INICIO_ESQUERDA; //Reinicia o sentido quando esta para esquerda ou faz um overflow.
    else if (parar == 1) 
        saida <= saida; //Congelamento
    else if (muda_sentido == 1) 
        saida <= saida*2; //Para a esquerda
    else 
        saida <= saida/2; //Para a direita
  end

  always_comb begin 
    LED <= saida; //Atribuindo o valor da saída aos LEDs
  end

endmodule
