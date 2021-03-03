------------------------------
-- Luis Angel Zavala Robles --
--       A01706481 			 --
------------------------------

--UNIDAD ARITMÉTICA Y LÓGICA (ALU) 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


ENTITY ALU1706481 is
PORT(
		rs_1706481, op_1706481 : in std_logic_vector (3 downto 0); -- Operandos
		Cin_1706481				  : in std_logic;			 				  -- Carry de Entrada
		Sel_1706481				  : in std_logic_vector (2 downto 0); -- Selector
		rd_1706481				  : out std_logic_vector(3 downto 0); -- Resultado
		statusreg_1706481		  : out std_logic_vector(1 downto 0));-- Flags (Overflow, Zero)

END ALU1706481;


ARCHITECTURE A01706481 of ALU1706481 is
signal auxAritm : signed(4 downto 0);
signal auxLogic : std_logic_vector(3 downto 0);

Begin	
-------------- SECCIÓN ARITMÉTICA -----------------------
	with Sel_1706481(1 downto 0) select
	auxAritm <=  ('0' & signed(rs_1706481)) + ('0' & signed(op_1706481)) 					 when "00",
					 ('0' & signed(rs_1706481)) + ('0' & signed(op_1706481)) + Cin_1706481 	 when "01",
					 ('0' & signed(rs_1706481)) - ('0' & signed(op_1706481))					    when "10",
					 ('0' & signed(rs_1706481)) - ('0' & signed(op_1706481)) + Cin_1706481	 when "11";
					 
-------------- SECCIÓN LÓGICA ---------------------------
	with Sel_1706481(1 downto 0) select
	auxLogic <= rs_1706481 AND op_1706481	 	  when "00",
					rs_1706481 OR  op_1706481 		  when "01",
					rs_1706481 XOR op_1706481 		  when "10",
					rs_1706481 AND (NOT op_1706481) when "11";

	
	
-------------- MULTIPLEXOR Y ASIGNACIÓN DE VALORES A STATUS REGISTRER-------------------------------
	PROCESS (auxAritm, auxLogic, Sel_1706481)
	BEGIN
		CASE Sel_1706481(2) IS
		WHEN '0' 	=> rd_1706481   			<= STD_LOGIC_VECTOR(auxAritm(3 downto 0));
							statusreg_1706481(0) <= auxAritm(4) XOR rs_1706481(3) XOR op_1706481(3) XOR auxAritm(3);
							statusreg_1706481(1) <= NOT(auxAritm(4) OR auxAritm(3) OR auxAritm(2) OR auxAritm(1) OR auxAritm(0));
		
		WHEN OTHERS => rd_1706481   <= auxLogic;
							statusreg_1706481(0) <= '0';
							statusreg_1706481(1) <= NOT(auxLogic(3) OR auxLogic(2) OR auxLogic(1) OR auxLogic(0));
		END CASE;
	END PROCESS;
			
END A01706481;

