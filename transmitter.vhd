----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/25/2018 03:40:22 PM
-- Design Name: 
-- Module Name: transmitter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmitter is
    Port ( txclk : in STD_LOGIC;
           tx_out : out STD_LOGIC;
           tx_en : in STD_LOGIC;
           reset : in STD_LOGIC;
           tx_empty : out STD_LOGIC;
           ld_tx: in STD_LOGIC;
           temp: in std_logic;
           tx_data : in STD_LOGIC_VECTOR(7 downto 0));
end transmitter;

architecture Behavioral of transmitter is
type state is(idle,start,s0,s1,s2,s3,s4,s5,s6,s7);
SIGNAL tx_state : state := idle;
SIGNAL tx_empty_sig : STD_LOGIC := '1';
SIGNAL tx_data_sig : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

begin
    process(tx_empty_sig)begin
        tx_empty <= tx_empty_sig;
    end process;
    
    PROCESS(txclk,reset)BEGIN
          if(reset = '1')then
                tx_empty_sig <= '1';
                tx_out <= '1';
                tx_state <= idle; 
          elsif(txclk = '1' AND txclk'EVENT) THEN 
                    if(tx_state = idle and tx_empty_sig='1')then
                        tx_out <='1';
                        if(ld_tx='1')then
                            tx_data_sig<=tx_data;
                            tx_empty_sig<='0';
                        end if;
                    end if;
                    if(tx_en = '0')then
                        tx_out <= '1';
                        tx_state <= idle;
                    end if;
                    IF(tx_en = '1' and tx_empty_sig = '0' and temp = '1')  THEN
                        case tx_state is
                        
                        when idle=> tx_out <= '0';tx_state<=start;              
                        when start=> tx_out <=tx_data(0) ;tx_state<=s0; 
                        when s0=> tx_out <=tx_data_sig(1) ;tx_state<=s1;
                        when s1=> tx_out <=tx_data_sig(2) ;tx_state<=s2;
                        when s2=> tx_out <=tx_data_sig(3) ;tx_state<=s3;
                        when s3=> tx_out <=tx_data_sig(4) ;tx_state<=s4;
                        when s4=> tx_out <=tx_data_sig(5) ;tx_state<=s5;
                        when s5=> tx_out <=tx_data_sig(6) ;tx_state<=s6;                                            
                        when s6=> tx_out <=tx_data_sig(7) ;tx_state<=s7;
                        when s7=> tx_out <='1' ;tx_state<=idle;tx_empty_sig <='1';
                        end case;
                     end if;   
          end if;          
    end process;

end Behavioral;