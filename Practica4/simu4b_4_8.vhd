LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY simu4b_4_8 IS
	 GENERIC (n : natural := 8;
				 m : natural := 4);
END simu4b_4_8;

ARCHITECTURE behavior OF simu4b_4_8 IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT divider
	 GENERIC (n : natural;
				 m : natural);
    PORT(
       clk : IN  std_logic;
	    reset : IN  std_logic;
		 dividend : IN  std_logic_vector(n-1 downto 0);
       divisor : IN  std_logic_vector(m-1 downto 0);
		 start : IN  std_logic;
	    ready : OUT  std_logic;
		 quotient : OUT  std_logic_vector(n-1 downto 0)
    );
    END COMPONENT;


   --Inputs
   signal dividend : std_logic_vector(n-1 downto 0) := (others => '0');
   signal divisor : std_logic_vector(m-1 downto 0) := (others => '0');
   signal start : std_logic := '0';
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal quotient : std_logic_vector(n-1 downto 0);
   signal ready: std_logic;

   -- Clock period definitions
   constant clk_period : time := 80 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: divider GENERIC MAP(
						n => n,
						m => m
					 )
	PORT MAP (
	       clk => clk,
          reset => reset,
          dividend => dividend,
          divisor => divisor,
			 start => start,
	       ready => ready,
			 quotient => quotient
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
   begin
      reset<='0';
		wait for 80 ns;

		--244/10=24
		reset<='0';
		start<='0';
		dividend<="11110100";
		divisor<="1010";
      wait for 2*clk_period;

		start<='1';
		wait for 50*clk_period;

		reset<='0';
      wait for 100 ns;

		--61/8=7
		reset <= '0';
		start<='0';
		dividend<="00111101";
		divisor<="1000";
		wait for 2*clk_period;

		start<='1';
		wait for 50*clk_period;

		reset<='0';
      wait for 100 ns;

		--116/9=12
		reset <= '0';
		start<='0';
		dividend<="01110100";
		divisor<="1001";
		wait for 2*clk_period;

		start<='0';
		wait for 50*clk_period;

		reset<='0';
      wait for 100 ns;

		--82/15=5
		reset <= '0';
		start<='0';
		dividend<="01010010";
		divisor<="1111";
		wait for 2*clk_period;

		start<='1';
		wait for 50*clk_period;

		reset<='0';
      wait for 100 ns;

		--35/11=3
		reset <= '0';
		start<='0';
		dividend<="00100011";
		divisor<="1011";
		wait for 2*clk_period;

		start<='1';
      wait;

   end process;

END;