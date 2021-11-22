// Adriano Santos de Lira Júnior
// Atividade: HDL: Lógica combinatória
/*
1. Expediente 
2. Agência
3. Estufa
4. Aeronave
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
  
  parameter NBITS_ENTRADA = 1; //Tamanho dos bits de entrada. Comum para todos os problemas.

  //1. EXPEDIENTE

  //criando variaveis de entrada
  logic eh_noite;
  logic maquinas_fora_operacao;
  logic eh_sexta;
  logic producao_atendida;

  //Alocando as entradas às variaveis
  always_comb eh_noite <= SWI[4];
  always_comb maquinas_fora_operacao <= SWI[5];
  always_comb eh_sexta <= SWI[6];
  always_comb producao_atendida <= SWI[7];

  //criando variavel de saída e alocando ao LED[2]
  logic sirene;
  always_comb LED[2] <= sirene;

  //Solução lógica
  always_comb sirene <= (eh_noite & maquinas_fora_operacao) | (eh_sexta & producao_atendida & maquinas_fora_operacao);

  //2. AGÊNCIA

  //Criando variaveis de entrada
  logic porta_cofre;
  logic relogio_expediente;
  logic interruptor_gerente;

  //Alocando switches às entradas
  always_comb porta_cofre <= SWI[0];
  always_comb relogio_expediente <= SWI[1];
  always_comb interruptor_gerente <= SWI[2];

  //criando variavel de saída e alocando ao SEG[0]
  logic alarme;
  always_comb SEG[0] <= alarme;

  //Solução lógica
  always_comb alarme<= porta_cofre & !(relogio_expediente & !interruptor_gerente);

  //3. ESTUFA

  //Criando variaveis de entrada
  logic temp_15;
  logic temp_20;

  //Alocando switches as entradas
  always_comb temp_15 <= SWI[3];
  always_comb temp_20 <= SWI[4];

  //Criando variavel de saida armazenando 3 bit.
  parameter NBITS_CONTROLE = 3;
  logic [NBITS_CONTROLE-1:0] controle;

  //Solução lógica
  always_comb 
    if (temp_15 == 0)
      if (temp_20 == 0) controle <= 'b001;
      else controle <= 'b100;
    else
      if (temp_20 == 1) controle <= 'b010;
      else controle <= 'b000;

  //Saídas
  always_comb LED[6] <= controle[0];
  always_comb LED[7] <= controle[1];
  always_comb SEG[7] <= controle[2];

  //4. AERONAVES

  //Criando variaveis de entrada
  logic banheiro_1;
  logic banheiro_2;
  logic banheiro_3;

  //Alocando switches as entradas
  always_comb banheiro_1 <= SWI[0];
  always_comb banheiro_2 <= SWI[1];
  always_comb banheiro_3 <= SWI[2];

  //Criando variáveis de informação de banheiro livre
  logic banheiro_livre_mulher;
  logic banheiro_livre_homem;

  //Atribuiçao de LEDs a cada banheiro
  always_comb LED[0] <= banheiro_livre_mulher;
  always_comb LED[1] <= banheiro_livre_homem;

  //Solução lógica
  always_comb banheiro_livre_mulher <= !(banheiro_1 & banheiro_2 & banheiro_3);
  always_comb banheiro_livre_homem <= !(banheiro_2 & banheiro_3);
  
endmodule
