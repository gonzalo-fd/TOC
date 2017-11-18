
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use	ieee.numeric_std.all;
use	work.definitions.all;

entity cell is
	port	(d :	in std_logic;	
			pattern_in :	in	t_pattern;	
			pattern_out :	out t_pattern;	
			count_in :	in	t_count;	
			count_out :	out t_count);	
end cell;

architecture Behavioral of cell is
signal pattern_i: t_pattern;
signal seleccion: std_logic_vector(2	downto 0);
signal operando: t_count;

	component um
			port (				op1:	in t_count;	
									op2:	in t_count;	
									sel:	in std_logic_vector(2	downto 0);	
									res:	out signed	(3	downto 0));
	end component;
	
begin
	p_pattern_out: process (pattern_in,	d)	is
	begin
			case pattern_in is
					when no_pattern =>
						operando <= "0000";
						seleccion <= "000";
						if(d = '1') then 
							pattern_i <= first_one;

						else 
							pattern_i <= no_pattern;

						end if;
					when first_one =>
						seleccion <= "000";
						operando <= "0000";
						if(d = '1') then 
							pattern_i <= one_one;
						else 
							pattern_i <= one_zero;

						end	if;
					when one_zero =>
						if(d = '1') then 
							pattern_i <= first_one;
							seleccion <= "000";
							operando <= "0001";
						else 
							pattern_i <= no_pattern;
							operando <= "0000";
							seleccion <= "000";
						end	if;
					when one_one =>
						if(d = '1') then 
							pattern_i <= one_one;
							seleccion <= "001";
							operando <= "0001";
						else 
							pattern_i <= one_zero;
							seleccion <= "000";
							operando <= "0000";
						end	if;
					when pattern_rec =>
						--if(d = '1') then pattern_i <= first_one;
						--else pattern_i <= no_pattern;
						--end	if;
							seleccion <= "000";
							operando <= "0000";
							pattern_i <= no_pattern;					
			end	case;
			
	end process p_pattern_out;
	
	pattern_out	<=	pattern_i;
	
	um_count: um port map(count_in, operando, seleccion, count_out);
		
end Behavioral;

