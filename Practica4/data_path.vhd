library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_path is
	generic (n:	natural	:=	8;	
				m:	natural	:=	4);	
	port (clk,	reset:		in std_logic;	
			dividend:			in std_logic_vector(n	-	1	downto 0);	
			divisor:				in std_logic_vector(m	-	1	downto 0);	
			control:				in std_logic_vector(8	downto 0);
			quotient:			out std_logic_vector(n	-	1	downto 0);	
			less_or_equals:	out std_logic;	
			MSB_dividend:		out std_logic);	
end data_path;	

architecture ARCH	of data_path is

component adder_subtracter is
	generic (n : natural := 8);
	port(A, B: in std_logic_vector(n-1 downto 0);
			op: in std_logic;
			O: out std_logic_vector(n-1 downto 0));
end component;

component counter is
	generic (n: integer := 8);
	port (clk, reset, count: in std_logic;
				output: out std_logic_vector (n-1 downto 0));
end component;

component left_right_shift_reg is
generic (n: natural := 8);
	port	(clk,	reset, load, right_shift, left_shift: in std_logic;
			 parallel_in: in std_logic_vector(n-1 downto 0);	
			 parallel_out: out std_logic_vector(n-1 downto 0));
end component;

component left_shift_reg is
generic (n : natural := 8);
	port	(clk,	reset, load, shift, serial_in: in std_logic;
			 parallel_in: in std_logic_vector(n-1 downto 0);	
			 parallel_out : out std_logic_vector(n-1 downto 0));
end component;


component mux is
generic (n : natural := 8);
port(A: in std_logic_vector(n-1 downto 0);	
	B: in std_logic_vector(n-1 downto 0);	
	control: in std_logic;
	result: out std_logic_vector(n-1 downto 0));	
end component;


component register_n is
	generic (n: integer := 8);
	port (clk, reset, load: in std_logic; 
			D: in std_logic_vector(n-1 downto 0);
			Q: out std_logic_vector(n-1 downto 0));
end component;
	
			signal control_aux:	std_logic_vector(8	downto 0);	
			alias load_dividend	:	std_logic is control_aux(0);
			alias load_divisor	:	std_logic is control_aux(1);
			alias shift_right_divisor:	std_logic is control_aux(2);
			alias load_quotient	:	std_logic is control_aux(3);
			alias shift_left_quotient	:	std_logic is control_aux(4);	
			alias load_k	:	std_logic is control_aux(5);	
			alias count_k	:	std_logic is control_aux(6);	
			alias mux_dividend	:	std_logic is control_aux(7);	
			alias operation	:	std_logic is control_aux(8);	
-- <COMPLETAR>	(Componentes	y	señales	intermedias)
			signal divisor_aux : std_logic_vector(n	downto 0);
			signal dvsr_despl: std_logic_vector(n	downto 0);
			signal dividendo_out: std_logic_vector(n	downto 0);
			signal sum_rest_out: std_logic_vector(n	downto 0);
			signal dividend_aux: std_logic_vector(n	downto 0);
			signal mux_out: std_logic_vector(n	downto 0);
			signal V: std_logic_vector(n	-	1	downto 0);
			signal count_out: std_logic_vector(n	-	1	downto 0);
			signal zeroes: std_logic_vector(n - m - 1 downto 0);
			signal cociente: std_logic_vector(n	-	1	downto 0);
			signal bmsnegado, reset_k: std_logic;

begin
	control_aux	<=	control;
	
	--Registro divisor.
	zeroes <= (others => '0');
	divisor_aux <= '0' & divisor & zeroes; --0&divisor&0..0
	Rdivisor: left_right_shift_reg generic map (n+1) port map(clk, reset, load_divisor, 
	shift_right_divisor, '0', divisor_aux, dvsr_despl);
	
	--Registro dividendo.
	Rdividendo: register_n generic map (n+1) port map(clk, reset, load_dividend, mux_out, dividendo_out);
	MSB_dividend <= dividendo_out(n); --Asignacion a la salida.
	bmsnegado <= not dividendo_out(n); --Bit mas significativo negado.
	
	--Registro cociente.
	V <= (others	=>	'0'); --0..0.
	Rquotient: left_shift_reg generic map (n) port map(clk, reset, load_quotient, shift_left_quotient,
	bmsnegado, V, cociente);
	quotient <= cociente; --Asignacion a la salida.
	
	--Sumador/Restador.
	sum_rest: adder_subtracter generic map (n+1) port map(dividendo_out, dvsr_despl,
	operation, sum_rest_out);
	
	--Multiplexor.
	dividend_aux <= '0' & dividend; --0&dividend.
	muxDiv: mux generic map (n+1) port map(sum_rest_out, dividend_aux, mux_dividend, mux_out);
	
	reset_k <= reset or load_k;
	
	--Registro contador.	
	Rcount: counter port map(clk, reset_k, count_k, count_out);
	--CMP.
	process(count_out)	
	begin
			if signed(count_out) < n-m then
				less_or_equals	<=	'1'; --Asignacion a la salida.
			elsif signed(count_out) = n-m then
				less_or_equals	<=	'1'; --Asignacion a la salida.
			else less_or_equals	<=	'0'; --Asignacion a la salida.
			end if;
	end process;
end	ARCH;

