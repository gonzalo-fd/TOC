
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
begin
	p_pattern_out: process (pattern_in,	d)	is
	begin
			case pattern_in is
					when no_pattern =>
						if(d = '1') then pattern_i <= first_one;
						else pattern_i <= no_pattern;
						end if;
					when first_one => 
						if(d = '1') then pattern_i <= one_one;
						else pattern_i <= one_zero;
						end	if;
					when one_zero =>
						if(d = '1') then pattern_i <= pattern_rec;
						else pattern_i <= no_pattern;
						end	if;
					when one_one =>
						if(d = '1') then pattern_i <= pattern_rec;
						else pattern_i <= one_zero;
						end	if;
					when pattern_rec =>
						if(d = '1') then pattern_i <= first_one;
						else pattern_i <= no_pattern;
						end	if;
			end	case;	
	end process p_pattern_out;
	pattern_out	<=	pattern_i;	
	p_count_out:	process (count_in,	pattern_i)	is
	begin
			if pattern_i	=	pattern_rec then
						count_out	<=	count_in	+	1;		
			else
						count_out	<=	count_in;	
			end if;	
	end process p_count_out;	

end Behavioral;

