// Adriano Santos de Lira Júnior
// Simulador caça-níquel com 3 contadores

parameter divide_by= 40000000;  // divisor do clock de referência
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
  end
		
	//Inicializando variáveis
  	parameter INICIO = 0;
  	parameter INCREMENTO = 1;
  	parameter DIGITO1 = 3;
    parameter NBITS_CONTADOR = 4;
	parameter FIM = 6;
  	parameter DIGITO2 = 7;
  	parameter DIGITO3 = 11;

  	logic reinicia, trava1, trava2, trava3; //Chaves de entrada
	logic [NBITS_CONTADOR-1:0] contador1;
	logic [NBITS_CONTADOR-1:0] contador2;
	logic [NBITS_CONTADOR-1:0] contador3;
   
    //Atribuindo entradas aos switchs equivalentes
	always_comb	reinicia <= SWI[0];
	always_comb	trava1 <= SWI[1];
	always_comb	trava2 <= SWI[2];
	always_comb	trava3 <= SWI[3];

    //Lógica do sistema
    always_ff@(posedge clk_2) begin
		if(~reinicia) begin
			if(~trava1 && contador1 < FIM) 
                contador1 <= contador1 + INCREMENTO;
			else if(~trava1 && contador1 == FIM) 
                contador1 <= INICIO;
			else 
                contador1 <= contador1;
			if(~trava2 && contador2 < FIM) 
                contador2 <= contador2 + INCREMENTO;
			else if(~trava2 && contador2 == FIM) 
                contador2 <= INICIO;
			else 
                contador2 <= contador2;
			if(~trava3 && contador3 < FIM) 
                contador3 <= contador3 + INCREMENTO;
			else if(~trava3 && contador3 == FIM) 
                contador3 <= INICIO;
			else 
                contador3 <= contador3;
		end

		else begin
			contador1 <= INICIO;
			contador2 <= INICIO;
			contador3 <= INICIO;
		end
	end

    //lcd a recebe a saída.
	always_comb begin
		lcd_a[DIGITO1:0] <= contador1;
		lcd_a[DIGITO2:4] <= contador2;
		lcd_a[DIGITO3:8] <= contador3;
	end

endmodule
