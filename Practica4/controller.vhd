library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
	port(clk,	reset,	start:	in std_logic;	
		less_or_equals:	in std_logic;	
		MSB_dividend:	in std_logic;	
		control:	out std_logic_vector(8	downto 0);	
		ready:	out std_logic);	
end controller;	

architecture ARCH	of controller is
		type	STATES	is	(reposo, inicio, resta, comp1, load_0_coc, load_1_coc, desp_suma, comp2);				--Definir	aquí	los	estados	
		signal	STATE,	NEXT_STATE:	STATES;	
		signal control_aux:	std_logic_vector(8	downto	0);
		alias load_dividend	:	std_logic is control_aux(0); --
		alias load_divisor	:	std_logic is control_aux(1); --
		alias shift_right_divisor:	std_logic is control_aux(2); --
		alias load_quotient	:	std_logic is control_aux(3); --
		alias shift_left_quotient	:	std_logic is control_aux(4); --
		alias load_k	:	std_logic is control_aux(5);	--Rk --
		alias count_k	:	std_logic is control_aux(6);	--Rk --
		alias mux_dividend	:	std_logic is control_aux(7); --	
		alias operation	:	std_logic is control_aux(8); --
begin
		control <= control_aux;				
	--Procesos	SYNC	y	COMB	de	la	máquina	de	estados	(como	en	la	práctica	2)	
		SYNC: process (clk, reset)
			begin	
				if clk'event and clk	='1' then	
					if	reset ='1' then		
						STATE <= reposo;	
					else	
						STATE <= NEXT_STATE;	
					end if;	
				end if;	
		end process SYNC;
				
		COMB: process (STATE, start, less_or_equals, MSB_dividend)
		begin

				control_aux <= (others => '0');
				
				case STATE is
				
						when reposo =>
							ready <= '1';
							if (start = '1') then 
									NEXT_STATE <= inicio;
							else  NEXT_STATE <= reposo;	
							end	if;
						when inicio =>
							ready <= '0';
							load_dividend <= '1';
							mux_dividend <= '1';
							load_divisor <= '1';
							load_quotient <= '1';
							load_k <= '1'; --para que no de que no se usa, pero no sive para nada.
							NEXT_STATE <= resta;
						when resta =>
							ready <= '0';
							--los desactivas para no machacar los valores.
							load_quotient <= '0'; 
							load_divisor <= '0';
							operation <= '1'; --resta.
							mux_dividend <= '0';
							load_dividend <= '1';
							NEXT_STATE <= comp1;
						when comp1 =>
							ready <= '0';
							--los desactivas para no machacar los valores.
							load_dividend <= '0';
							if(MSB_dividend = '1') then 
								NEXT_STATE <= load_0_coc;
							else 
								NEXT_STATE <= load_1_coc;
							end if;
						when load_0_coc =>
							ready <= '0';
							operation <= '0'; --suma.
							mux_dividend <= '0';
							load_dividend <= '1';
							shift_left_quotient <= '1';
							NEXT_STATE <= desp_suma;
						when load_1_coc =>
							ready <= '0';
							shift_left_quotient <= '1';
							NEXT_STATE <= desp_suma;
						when desp_suma =>
							ready <= '0';
							--los desactivas para no machacar los valores.
							load_dividend <= '0';
							shift_left_quotient <= '0';
							shift_right_divisor <= '1';
							count_k <= '1';
							NEXT_STATE <= comp2;
						when comp2 =>
							ready <= '0';
							--los desactivas para no machacar los valores.
							shift_right_divisor <= '0';
							count_k <= '0';
							if(less_or_equals = '0') then
								NEXT_STATE <= reposo;
							else 
								NEXT_STATE <= resta;
							end if;
						when others =>
							NEXT_STATE <= reposo;
				end case;
			
		
		end process;
end ARCH;	

