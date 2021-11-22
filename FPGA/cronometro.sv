// Adriano Santos de Lira Júnior
// Cronômetro de 0 a 9s com parada, congelamento e reset

//Mudando o valor de clock para ter a frequência 1
parameter divide_by=50000000;  // divisor do clock de referência
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

  // Criando variaveis a serem exibidas no display de 7 segmentos
  parameter NUM_ZERO = 'h3f;
  parameter NUM_UM = 'h06;
  parameter NUM_DOIS = 'h5b;
  parameter NUM_TRES = 'h4f;
  parameter NUM_QUATRO = 'h66;
  parameter NUM_CINCO = 'h6d;
  parameter NUM_SEIS = 'h7d;
  parameter NUM_SETE = 'h7;
  parameter NUM_OITO = 'h7f;
  parameter NUM_NOVE = 'h6F;
  parameter NUM_DEZ = 'h77; // A contagem é de 0 a 9, o 10 em hexadecimal representa que Acabou ou 10 em Hexadecimal.
  parameter VAZIO = 'h00; //Display vazio setado como default

  parameter NBITS_CONTADOR = 4;

  logic [NBITS_CONTADOR-1:0] contador;

  always_comb begin 
    case (contador)
      0: SEG <= NUM_ZERO;
      1: SEG <= NUM_UM;
      2: SEG <= NUM_DOIS;
      3: SEG <= NUM_TRES;
      4: SEG <= NUM_QUATRO;
      5: SEG <= NUM_CINCO;
      6: SEG <= NUM_SEIS;
      7: SEG <= NUM_SETE;
      8: SEG <= NUM_OITO;
      9: SEG <= NUM_NOVE;
      10: SEG <= NUM_DEZ;
      default:SEG <= VAZIO;
    endcase
  end

  //Atribuindo funções de controle como: congelar, reiniciar e inverter.
  logic congelar, reiniciar, inverter;
  
  always_comb begin
    reiniciar <= SWI[0]; //Atribui ao Switch[0] a função de reiniciar o cronometro e fica parado ate ser desligado.
    congelar <= SWI[1];  //Atribui ao Switch[1] a função de congelar o cronometro enquanto está ativado.
    inverter <= SWI[2]; //Atribui ao Switch[2] a função de reverter o cronometro e contar de tras pra frente.
  end

  always_ff @(posedge clk_2) begin
    if (reiniciar) 
      contador <= 0; //Reseta a contagem para 0 quando o switch é ativado.
    else if (congelar) 
      contador <= contador; //Para a contagem enquanto está ativado
    else if (~inverter && contador < 10) 
      contador <= contador + 1; //Incremento do contador enquanto é menor que 10
    else if (inverter && contador != 0) 
      contador <= contador-1;
    else 
      contador <= 0; //Quando o contador chega a A(10 em hexadecimal) ele volta a 0 nao parando a contagem.
  end

endmodule
