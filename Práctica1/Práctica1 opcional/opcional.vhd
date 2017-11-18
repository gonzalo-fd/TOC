--------------------------------------------------------------------------------------
------ Company: 
------ Engineer: 
------ 
------ Create Date:    12:03:04 10/03/2017 
------ Design Name: 
------ Module Name:    opcional - circuito 
------ Project Name: 
------ Target Devices: 
------ Tool versions: 
------ Description: 
------
------ Dependencies: 
------
------ Revision: 
------ Revision 0.01 - File Created
------ Additional Comments: 
------
--------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----
------ Uncomment the following library declaration if using
------ arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
----
------ Uncomment the following library declaration if instantiating
------ any Xilinx primitives in this code.
------library UNISIM;
------use UNISIM.VComponents.all;



entity opcional is
	port(rst,clk,cuenta: in std_logic;
		salida : out std_logic_vector( 3 downto 0));
end opcional;



architecture circuito of opcional is

	
	component sumador
	port(A,B: in std_logic_vector(3 downto 0);
		C: out std_logic_vector(3 downto 0));
	end component;
	
	component reg_paralelo
	port(rst,clk,load: in std_logic;
	E: in std_logic_vector(3 downto 0);
	S: out std_logic_vector(3 downto 0));
	end component;
	
	component divisor
	port(
	 rst: in STD_LOGIC;
        clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
        clk_salida: out STD_LOGIC); -- reloj que se utiliza en los process del programa principal
	end component;
	signal scont, sreg: std_logic_vector(3 downto 0);
	signal sdiv: std_logic;
	
	
begin

	mod_sumador: sumador port map("0001", sreg,scont);
	mod_registro : reg_paralelo port map(rst,sdiv,cuenta,scont,sreg);
	mod_divisor: divisor port map(rst,clk,sdiv);
	salida <= sreg;
end circuito;

