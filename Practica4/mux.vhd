library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
generic (n : natural := 8);
port(A: in std_logic_vector(n-1 downto 0);	
	B: in std_logic_vector(n-1 downto 0);	
	control: in std_logic;
	result: out std_logic_vector(n-1 downto 0));	
end mux;

architecture ARCH of mux is
begin

	process(control, A, B)
	begin
		if(control = '0') then 
			result <= A;
		else
			result <= B;
		end if;
	end process;

end ARCH;

