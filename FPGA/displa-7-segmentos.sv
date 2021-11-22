// Adriano Santos de Lira Júnior
// Dislay 7 segmentos: Brincamos com display de sete segmentos - Atividade da lista segunda lista HDM do site de LOAC

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

    //Variável de controle
    logic unsigned [5:0]entrada;

    //Criando parâmetros com códigos em hexadecimal dos números hexadecimais do display de 7 segmentos de acordo com a questão
    parameter zero = 'h3f;
    parameter um   = 'h06;
    parameter dois = 'h5b;
    parameter tres = 'h4f;
    parameter quatro = 'h66;
    parameter cinco = 'h6d;
    parameter seis  = 'h7d;
    parameter sete  = 'h7;
    parameter oito  = 'h7f;
    parameter nove  = 'h6F;
    parameter maiscula_A = 'h77;
    parameter minuscula_b = 'h7c;
    parameter maiscula_C = 'h39;
    parameter minuscula_d = 'h5e;
    parameter maiscula_E = 'h79;
    parameter maiscula_F = 'h71;

    //Criando parâmentros com códigos em hexadecimal das letras e símbolos de acordo com a questão
	parameter minuscula_c  = 'h58;
    parameter minuscula_g = 'h6f;
    parameter maiscula_H = 'h76;
    parameter minuscula_h  = 'h74;
    parameter minuscula_i  = 'h10;
    parameter maiscula_I = 'h6;
	parameter maiscula_J = 'h1e;
    parameter maiscula_L = 'h38;
    parameter minuscula_n = 'h54;
    parameter maiscula_O = 'h3f;
    parameter minuscula_o  = 'h5c;
    parameter maiscula_P = 'h73;
	parameter minuscula_q = 'h67;
    parameter minuscula_r = 'h50;
    parameter maiscula_S = 'h6d;
    parameter minuscula_t = 'h78;
    parameter maiscula_U = 'h3e;
    parameter minuscula_v = 'h1c;
	parameter minuscula_y = 'h6e;
    parameter GRAU    = 'h63;

    //atribuindo a entrada chaves que controlam a exibição no display conforme especificado. 
    always_comb begin entrada <= SWI[5:0];
		
		//Logica do sistema. SWITCH/CASE para demostrar cada caso.
	    case (entrada)
            0: SEG  <= zero;
			1: SEG  <= um;
			2: SEG  <= dois;
			3: SEG  <= tres;
			4: SEG  <= quatro;
			5: SEG  <= cinco;
			6: SEG  <= seis;
			7: SEG  <= sete;
			8: SEG  <= oito;
			9: SEG  <= nove;
			10: SEG <= maiscula_A;
			11: SEG <= minuscula_b;
			12: SEG <= maiscula_C;
			13: SEG <= minuscula_d;
			14: SEG <= maiscula_E;
			15: SEG <= maiscula_F;
			16: SEG <= maiscula_A;
			17: SEG <= minuscula_b;
			18: SEG <= maiscula_C;
			19: SEG <= minuscula_c;
			20: SEG <= minuscula_d;
			21: SEG <= maiscula_E;
			22: SEG <= maiscula_F;
			23: SEG <= minuscula_g;
			24: SEG <= maiscula_H;
			25: SEG <= minuscula_h;
			26: SEG <= minuscula_i;
			27: SEG <= maiscula_I;
			28: SEG <= maiscula_J;
			29: SEG <= maiscula_L;
			30: SEG <= minuscula_n;
			31: SEG <= maiscula_O;
			32: SEG <= minuscula_o;
			33: SEG <= maiscula_P;
			34: SEG <= minuscula_q;
			35: SEG <= minuscula_r;
			36: SEG <= maiscula_S;
			37: SEG <= minuscula_t;
			38: SEG <= maiscula_U;
			39: SEG <= minuscula_v;
			40: SEG <= minuscula_y;
			41: SEG <= GRAU;
			default: SEG <= 0;
		endcase

	end

endmodule
