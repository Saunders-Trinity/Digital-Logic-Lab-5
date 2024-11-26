library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity RALU is port(
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
END RALU;

architecture bh of RALU is
component alu port(
	A:IN std_logic_vector(3 downto 0);
	B:IN std_logic_vector(3 downto 0);
	CIN:IN std_logic_vector(0 downto 0);
	OP_CODE:IN std_logic_vector(2 downto 0);

	COUT: out std_logic;
	ALU_OUT: out std_logic_vector(3 downto 0)
);
end component;

component REG port(
	DS: IN STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	QS: OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	reset: IN STD_LOGIC;
	clk: IN STD_LOGIC
);
end component;

component BIG_MUX port(
	SEL: in std_logic_vector( 1 downto 0);
	A: in std_logic_vector( 3 downto 0);
	B: in std_logic_vector( 3 downto 0);
	C: in std_logic_vector( 3 downto 0);
	D: in std_logic_vector( 3 downto 0);
	MUX_OUT: out std_logic_vector(3 downto 0)
);
end component;

component decode7seg port(
	input : in STD_LOGIC_VECTOR (3 downto 0);
	output : out STD_LOGIC_VECTOR (6 downto 0)
);
end component;


signal alu_out: std_logic_vector(3 downto 0);
signal REGA: std_logic_vector(3 downto 0);
signal REGB: std_logic_vector(3 downto 0);
signal REGA_DS: std_logic_vector(3 downto 0);
signal REGB_DS: std_logic_vector(3 downto 0);

begin 
MUXA: BIG_MUX	
		port map(SEL => SELA, A => input_bus, B=> alu_out, C=> REGA, D => REGB, MUX_OUT => REGA_DS);
MUXB: BIG_MUX	
		port map(SEL => SELB, A => input_bus, B=> alu_out, C=> REGA, D => REGB, MUX_OUT => REGB_DS);
REGA_inst: REG
		port map( DS => REGA_DS, QS =>REGA, reset => reset, clk => clk);
REGB_inst: REG	
		port map( DS => REGB_DS, QS =>REGB, reset => reset, clk => clk);
ALU_inst: alu
		port map(A => REGA, B => REGB, CIN => CIN, OP_CODE => OP_CODE, COUT => COUT, ALU_OUT => alu_out);
decode7seg0_inst: decode7seg
		port map(input => REGA, output => SSG0);
decode7seg1_inst: decode7seg
		port map(input => REGB, output => SSG1);
decode7seg2_inst: decode7seg
		port map(input => alu_out, output => SSG2);
decode7seg3_inst: decode7seg
		port map(input => input_bus, output => SSG3);

end bh;
