----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:22:36 10/23/2017 
-- Design Name: 
-- Module Name:    reflejo - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reflejo	is
			port(clk,	rst,	boton,	switch:	in std_logic;		
		luces:	out std_logic_vector(4	downto	0));	
			end	reflejo;	

architecture Behavioral of reflejo is

type	ESTADOS	is	(espera,	ilumina, rapido, medio, lento, error, ledRapido,ledMedio, ledLento, ledError);
signal ESTADO, SIG_ESTADO: ESTADOS;
component divider port (
	rst: in std_logic;
	clk_entrada: in std_logic;
	clk_salida: out std_logic);
	end component;
signal clk_inter: std_logic;
	begin
	divide: divider port map(rst => '0', clk_entrada => clk, clk_salida => clk_inter);
	--clk_inter <= clk;
	

	SYNC:	process(clk_inter,rst)	
	begin	
	if clk_inter'event and clk_inter	='1' then	
		if	rst ='1' then		
			ESTADO <= espera;	
			else	
			ESTADO <= SIG_ESTADO;	
			end if;	
			end if;	
	end process	SYNC;	

	COMB:	process	(ESTADO,boton, switch)	
	begin	
		luces	<=	"00000";
		case	ESTADO is	

			when	espera =>	
				--luces	<=	"00000";
				SIG_ESTADO<=ilumina;	
				
			when	ilumina	=>	
				luces	<=	"10000";	
				SIG_ESTADO<=rapido;	

			when	rapido	=>		
			if	(boton='1')	then SIG_ESTADO<=ledRapido;	
			else	SIG_ESTADO<=medio;	
			end	if;
				
			when	medio	=>		
			if	(boton='1')	then	SIG_ESTADO<=ledMedio;	
			else	SIG_ESTADO<=lento;	
			end	if;

			when	lento	=>		
			if	(boton='1')	then	SIG_ESTADO<=ledLento;	
			else	SIG_ESTADO<=error;	
			end	if;

			when	error	=>		
			SIG_ESTADO<=ledError;	

			when	ledRapido	=>	
			luces <="00001";	
			if	(switch = '1')	then	SIG_ESTADO<=espera;	
			else SIG_ESTADO<= ESTADO;
			end	if;

			when	ledMedio	=>	
			luces <="00010";	
			if	(switch ='1')	then	SIG_ESTADO<=espera;	
			else SIG_ESTADO<= ESTADO;			
			end	if;

			when	ledLento	=>	
			luces <="00100";	
			if	(switch ='1')	then	SIG_ESTADO<=espera;	
			else SIG_ESTADO<= ESTADO;			
			end	if;

			when	ledError	=>	
			luces <="01000";	
			if	(switch ='1')	then	SIG_ESTADO<=espera;		
			else SIG_ESTADO<= ESTADO;
			end	if;

			end	case;	
	end	process	COMB;

end Behavioral;

