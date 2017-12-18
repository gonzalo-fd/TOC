library ieee;
use ieee.std_logic_1164.all;

entity left_right_shift_reg is
generic (n: natural := 8);
	port	(clk,	reset, load, right_shift, left_shift: in std_logic;
			 parallel_in: in std_logic_vector(n-1 downto 0);	
			 parallel_out: out std_logic_vector(n-1 downto 0));
end left_right_shift_reg;

architecture ARCH of left_right_shift_reg is

	signal parallel_out_aux : std_logic_vector(n-1 downto 0);

begin

	process (clk) 
	begin 
		if clk'event and clk = '1' then
			if reset = '1' then 
				parallel_out_aux <= (others => '0'); 
			elsif load = '1' then 
				parallel_out_aux <= parallel_in; 
			elsif right_shift = '1' then 
				parallel_out_aux <= '0' & parallel_out_aux (n-1 downto 1);
			elsif left_shift = '1' then
				parallel_out_aux <= parallel_out_aux(n-2 downto 0) & '0';
			end if; 
		end if; 
	end process;

	parallel_out <= parallel_out_aux;

end ARCH;
