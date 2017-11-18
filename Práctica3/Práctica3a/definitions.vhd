library IEEE;
use IEEE.STD_LOGIC_1164.all;	
use	ieee.numeric_std.all;	
package definitions is
			constant C_G_WIDTH_DATA:	integer :=	9;	
			constant C_G_WIDTH_COUNT:	integer :=	5;	
			type t_pattern is (no_pattern,	first_one,	one_zero,	one_one,		
			pattern_rec);	
			subtype t_count is unsigned	(C_G_WIDTH_COUNT	-	1	downto	0);	
			type t_pattern_vector is array	(C_G_WIDTH_DATA	downto	0)	of t_pattern;	
			type t_count_vector is array	(C_G_WIDTH_DATA	downto	0)	of t_count;	
end package definitions;