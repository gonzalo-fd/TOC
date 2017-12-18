library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_divider is
	generic	(n	:	natural	:=	8;	
				m:	natural :=	4);
	port	(clk,	reset:	in std_logic;	
				dividend:	in std_logic_vector(n-1	downto 0);	
				divisor:	in std_logic_vector(m-1	downto 0);	
				start:	in std_logic;	
				ready:	out std_logic;	
				clk_out: out std_logic;
				quotient:	out std_logic_vector(n-1	downto 0));		
end top_divider;	

architecture ARCH	of top_divider is
		--	<COMPLETAR>	(Componentes	controller	y	datapath)

		component controller is
			port(clk,	reset,	start:	in std_logic;	
				less_or_equals:	in std_logic;	
				MSB_dividend:	in std_logic;	
				control:	out std_logic_vector(8	downto 0);	
				ready:	out std_logic);	
		end component;	

		component data_path
			generic (n:	natural	:=	8;	
						m:	natural	:=	4);	
			port (clk,	reset:		in std_logic;	
					dividend:			in std_logic_vector(n	-	1	downto 0);	
					divisor:				in std_logic_vector(m	-	1	downto 0);	
					control:				in std_logic_vector(8	downto 0);
					quotient:			out std_logic_vector(n	-	1	downto 0);	
					less_or_equals:	out std_logic;	
					MSB_dividend:		out std_logic);	
		end component;	


		component divisor_f
			 port (
				  rst: in STD_LOGIC;
				  clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
				  clk_salida: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
			 );
		end component;
		
		signal clk_intermediate,	reset_intermediate,	start_intermediate:	std_logic;
		signal control:	std_logic_vector	(8	downto 0);
		signal less_or_equals,	MSB_dividend:	std_logic;	
begin

		--my_div: divisor_f port map ('0', clk, clk_intermediate);
		clk_intermediate	<=	clk;	

		clk_out <= clk_intermediate;

		reset_intermediate	<=	not reset;		--	Lógica	invertida	(botones)	
		start_intermediate	<=	not start;		--	Lógica	invertida	(botones)	
		
		my_datapath:	data_path GENERIC	MAP	(n,	m)		
				PORT	MAP(clk	=>	clk_intermediate,
							reset	=>	reset_intermediate,	
							dividend	=>	dividend,	
							divisor	=>	divisor,	
							control	=>	control,	
							quotient	=>	quotient,	
							less_or_equals	=>	less_or_equals,	
							MSB_dividend	=>	MSB_dividend);	
							
		my_controller:	controller	PORT	MAP	(clk	=>	clk_intermediate,
							reset	=>	reset_intermediate,	
							start	=>	start_intermediate,	
							MSB_dividend	=>	MSB_dividend,	
							less_or_equals	=>	less_or_equals,	
							control	=>	control,	
							ready	=>	ready);	
end	ARCH;	

