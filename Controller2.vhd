-- use this file instead on controller.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity controller is port(
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
end controller;

architecture bh of controller is
	type possible_states is (IDLE,LOAD,TAB, AND_t, OR_t,ADD, comp2_2,comp2_1,SRL_t,OUT_t);
	signal state_rn: possible_states := IDLE;
	
	constant SEL_IN: std_logic_vector( 1 downto 0) := "00";
	constant SEL_OUT: std_logic_vector( 1 downto 0) := "01";
	constant SEL_A: std_logic_vector( 1 downto 0) := "10";
	constant SEL_B: std_logic_vector( 1 downto 0) := "11";
begin
	process(clk,reset)
	begin
		if(reset = '0') then 
						state_rn <= IDLE;
						done <= '1';
						SELA <= SEL_A;
						SELB <= SEL_B;
						OP	<= "000";
		elsif(rising_edge(clk)) then
						cin(0) <= cout;
						case (state_rn) is 
								when IDLE =>
									if( start = '1') then 
										--next state logic
										if(inst = "000") then
											done <= '0';
											if(dest_is_A = '1') THEN
												SELA <= SEL_IN;
												SELB <= SEL_B;
												OP <= "000";
											ELSE
												SELA <= SEL_A;
												SELB <= SEL_IN;
												OP <= "000";
											END IF;
											state_rn <= LOAD;
										elsif(inst = "001") then
											done <= '0';
											if (dest_is_A = '1') THEN
												SELA <= SEL_B;
												SELB <= SEL_B;
												OP <= "000";--changed
											 else 
												SELA <= SEL_A;
												SELB <= SEL_A;
												OP <= "000";--changed
											end if;
											state_rn <= TAB;
										elsif(inst = "010") then
											done <= '0';
											if (dest_is_A = '1') THEN
												SELA <= SEL_OUT;
												SELB <= SEL_B;
												OP <= "001";--changed
											 else 
												SELA <= SEL_A;
												SELB <= SEL_OUT;
												OP <= "001";--changed
											end if;
											state_rn <= AND_t;
										elsif(inst = "011") then
											done <= '0';
											if (dest_is_A = '1') THEN
												SELA <= SEL_OUT;
												SELB <= SEL_B;
												OP <= "010";--changed
											else
												SELA <= SEL_A;
												SELB <= SEL_OUT;
												OP <= "010";--changed
											end if;
											state_rn <= OR_t;
										elsif(inst = "100") then
											done <= '0';
											if (dest_is_A = '1') THEN
												SELA <= SEL_OUT;
												SELB <= SEL_B;
												OP <= "011";--changed
											else
												SELA <= SEL_A;
												SELB <= SEL_OUT;
												OP <= "011";--changed
											end if;
											state_rn <= ADD;
										elsif(inst = "101") then -- 2s complement
											done <= '0';--changed
											state_rn <= comp2_1;
											SELA <= SEL_OUT;
											OP <= "000";--changed
											SELB <= SEL_IN;
										elsif(inst = "110") then
											done <= '0';
											if(dest_is_A = '1') then
												SELA <= SEL_OUT;
												SELB <= SEL_B;
												OP <= "111";--changed
											else
												SELA <= SEL_OUT;
												SELB <= SEL_B;
												OP <= "111";--changed
											end if;
											state_rn <= SRL_t;
										elsif(inst = "111") then
											done <= '0';
											if(dest_is_A = '1') then
												SELA <= SEL_A;
												SELB <= SEL_B;
												OP <= "100";--subject to change
											else
												SELA <= SEL_A;
												SELB <= SEL_B;
												OP <= "101";--subject to change
											end if;
											state_rn <= OUT_t;
										end if;
									else
										-- do nothing
										state_rn <= IDLE;
										SELA <= SEL_A;
										SELB <= SEL_B;
										OP <= "000";
										done <= '1';
									end if;
								WHEN comp2_1 =>
									if(dest_is_A = '1') then
										SELA <= SEL_OUT;
										SELB <= SEL_B;
										OP <= "011";
									else
										SELA <= SEL_A;
										SELB <= SEL_OUT;
										OP <= "011";
									end if;
									done <= '0';
									state_rn <= comp2_2;
								when others =>
									state_rn <= IDLE;
									SELA <= SEL_A;
									SELB <= SEL_B;
									OP <= "000";
									done <= '1';
								--	state_rn <= comp2_2;
						end case;
		end if;
	end process;
end bh;
