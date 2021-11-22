// Adriano Santos de Lira júnior	
// Contador de 4 bits

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
    SEG <= SWI;
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
  end

  //iniciando variaveis
  parameter ENTRADA = 1;
  parameter ENTRADA_DECREMENTO = 3;
  parameter NBITS_CONTAGEM = 4;

  //valores default
  parameter INICIO_CRESCENTE = 0;
  parameter INICIO_DECRESCENTE = 15;

  logic incrementa_3, decrescente, satura_contagem, congela_contagem, reset;
  logic [NBITS_CONTAGEM-1:0] contagem;

  //atribuindo SWI[] a cada uma funcionalidade
  always_comb	begin
		reset <= SWI[0]; //reseta a contagem para 0 enquanto esta ativado, ao desativar a contagem é inicializada
		decrescente <= SWI[1]; //faz a contagem decrescente a partir do momento que é ativado
		incrementa_3 <= SWI[2]; //incrementa de 3 em 3 a partir do momento que é ativado
		congela_contagem <= SWI[3]; //pausa a contagem enquanto esta ativado, ao desativar a contagem retorna normalmente
		satura_contagem <= SWI[4]; //satura a contagem em 0 ou F dependendo do momento que é ativado.
	end

  //Lógica do sistema
	always_ff @(posedge clk_2) begin
		if (~congela_contagem) begin
			if ((contagem == INICIO_CRESCENTE || contagem == INICIO_DECRESCENTE) && satura_contagem) 
        contagem <= contagem;
      else begin
				  if (reset) 
            contagem <= INICIO_CRESCENTE;
				  else if (decrescente) begin
					  if (incrementa_3) 
              contagem <= contagem - ENTRADA_DECREMENTO;
					  else 
              contagem <=  contagem - ENTRADA;
				  end
				else begin 
					if (incrementa_3) 
            contagem <= contagem + ENTRADA_DECREMENTO;
					else 
            contagem <=  contagem + ENTRADA;			
				end	
			end
		end
		else begin
			contagem <= contagem;
		end

	end
    
	always_comb begin
		lcd_b = contagem;
	end

endmodule
