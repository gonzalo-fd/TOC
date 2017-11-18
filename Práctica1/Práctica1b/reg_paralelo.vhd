----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:03:04 10/03/2017 
-- Design Name: 
-- Module Name:    reg_paralelo - circuito 
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

entity reg_paralelo is
	port(rst,clk,load: in std_logic;
	E: in std_logic_vector(3 downto 0);
	S: out std_logic_vector(3 downto 0));

end reg_paralelo;

architecture circuito of reg_paralelo is

begin
	process(rst,clk)
		begin
			if clk'event and clk = '1' then
				if rst = '1' then
					S<= "0000";
				elsif load = '1' then
					S<= E;
				end if;
			end if;
		end process;
end circuito;

