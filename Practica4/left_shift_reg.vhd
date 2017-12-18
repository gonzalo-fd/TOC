library ieee;
use ieee.std_logic_1164.all;

entity left_shift_reg is
generic (n : natural := 8);
	port	(clk,	reset, load, shift, serial_in: in std_logic;
			 parallel_in: in std_logic_vector(n-1 downto 0);	
			 parallel_out : out std_logic_vector(n-1 downto 0));
end left_shift_reg;

architecture ARCH of left_shift_reg is

	signal parallel_out_aux : std_logic_vector(n-1 downto 0);

begin

	PROCESS (clk, reset) 
	begin 
		if clk'event and clk = '1' then
			if reset = '1' then 
				parallel_out_aux <= (others => '0'); 
			elsif load = '1' then 
				parallel_out_aux <= parallel_in; 
			elsif shift = '1' then 
				parallel_out_aux <= parallel_out_aux (n - 2 downto 0) & serial_in;
			end if; 
		end if; 
	end process;

	parallel_out <= parallel_out_aux;

end ARCH;