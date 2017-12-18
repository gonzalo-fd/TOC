library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_subtracter is
	generic (n : natural := 8);
	port(A, B: in std_logic_vector(n-1 downto 0);
			op: in std_logic;
			O: out std_logic_vector(n-1 downto 0));
end adder_subtracter;

architecture ARCH of adder_subtracter is

	signal O_aux: signed(n-1 downto 0);

begin

	process(A, B, op)
	begin
		if (op = '0') then	
			O_aux <= signed(A) + signed(B); 
		else
			O_aux <= signed(A) - signed(B);	
		end if;
	end process;

	O <= std_logic_vector(O_aux);
	
end ARCH;