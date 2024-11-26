
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab5 is port(
clk: in std_logic;
reset: in std_logic;

inst: in std_logic_vector(2 downto 0); 
dest_is_A: in std_logic;
done: out std_logic;
start: in std_logic; 

input_bus: in std_logic_vector( 3 downto 0); --is this 3downto 0 or 2downto 0

SSG0: OUT std_logic_vector(6 downto 0);
SSG1: out std_logic_vector(6 downto 0);
SSG2:out std_logic_vector(6 downto 0);
SSG3:out std_logic_vector(6 downto 0)

);
end lab5;


architecture bh of lab5 is
component RALU port( 
	input_bus : in std_logic_vector(3 downto 0);
	clk: in std_logic;
	CIN: IN STD_LOGIC_vector(0 downto 0);
	RESET: IN STD_LOGIC;

	SELA: IN std_logic_vector(1 downto 0);
	SELB: IN std_logic_vector(1 downto 0);
	OP_CODE: IN std_logic_vector(2 downto 0);

		
	COUT : OUT STD_LOGIC;
	SSG0: OUT std_logic_vector(6 downto 0);
	SSG1: out std_logic_vector(6 downto 0);
	SSG2:out std_logic_vector(6 downto 0);
	SSG3:out std_logic_vector(6 downto 0)
	
	
);
end component;

component controller port(
	clk: in std_logic;
	reset : in std_logic;
	start : in std_logic;
	cout: in std_logic;
	inst : in std_logic_vector( 2 downto 0);
	dest_is_A: in std_logic;

	SELA: out std_logic_vector(1 downto 0);
	SELB: out std_logic_vector(1 downto 0);
	OP: out std_logic_vector(2 downto 0);

	cin: out std_logic_vector(0 downto 0);
	done: out std_logic
);
end component;
signal cin: std_logic_vector(0 downto 0);
signal cont_SELA: std_logic_vector( 1 downto 0);
signal cont_SELB: std_logic_vector( 1 downto 0);
signal cont_OP_CODE: std_logic_vector( 2 downto 0);
signal cout: std_logic;


begin
	RALU_inst: RALU
		port map(input_bus => input_bus,clk => clk,cin => cin,reset => reset,SELA => cont_SELA,SELB => cont_SELB,OP_CODE => cont_OP_CODE,cout => cout,SSG0 => SSG0,SSG1  => SSG1,SSG2 => SSG2,SSG3 => SSG3);
	controller_inst: controller
		port map(clk => clk,reset => reset,start => start,cout => cout,inst => inst,dest_is_A => dest_is_A,SELA => cont_SELA,SELB => cont_SELB,OP => cont_OP_CODE,cin => cin,done => done);



end bh;
