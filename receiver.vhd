----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/25/2018 03:38:44 PM
-- Design Name: 
-- Module Name: receiver - Behavioral
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

entity receiver is
    Port ( rxclk : in STD_LOGIC;
           rx_in : in STD_LOGIC;
           rx_en : in STD_LOGIC;
           reset : in STD_LOGIC;
           rx_empty : out STD_LOGIC;
           uld_rx: in STD_LOGIC;
           rx_data : out STD_LOGIC_VECTOR(7 downto 0));
end receiver;

architecture Behavioral of receiver is
type state is(idle,start,s0,s1,s2,s3,s4,s5,s6,s7,stop);
SIGNAL rx_state : state := idle;
Signal receiverCount :Integer:=0;
SIGNAL rx_data_sig : STD_LOGIC_VECTOR(7 downto 0);

begin

    PROCESS(rxclk)BEGIN
        if(reset = '1')then
                      rx_data <= "00000000" ;
                      rx_empty <= '1';
                      rx_state <= idle;  
        elsif(rxclk = '1' AND rxclk'EVENT) THEN 
                    if(receiverCount = 15) then
                        receiverCount <= 0;
                    ELSE 
                        receiverCount <= receiverCount + 1;
                    END IF;
                    if(rx_state = idle)then
                        if(uld_rx = '1') then
                            rx_data <= rx_data_sig;
                            rx_empty <= '1';
                        end if;
                    end if;
                    if(rx_en='1')then
                                        case rx_state is
                                        
                                        when idle=> if(rx_in='0')then rx_state<=start;receiverCount<=0; end if;              
                                        when start=> if(receiverCount = 6 and rx_in='0')then rx_state<=s0;elsif(receiverCount<7 and rx_in='1')then rx_state<=idle; end if;  
                                        when s0=> if(receiverCount = 6)then rx_data_sig(0) <= rx_in;rx_state<=s1;end if;
                                        when s1=> if(receiverCount = 6)then rx_data_sig(1) <= rx_in;rx_state<=s2;end if;
                                        when s2=> if(receiverCount = 6)then rx_data_sig(2) <= rx_in;rx_state<=s3;end if;
                                        when s3=> if(receiverCount = 6)then rx_data_sig(3) <= rx_in;rx_state<=s4;end if;
                                        when s4=> if(receiverCount = 6)then rx_data_sig(4) <= rx_in;rx_state<=s5;end if;
                                        when s5=> if(receiverCount = 6)then rx_data_sig(5) <= rx_in;rx_state<=s6;end if;                                          
                                        when s6=> if(receiverCount = 6)then rx_data_sig(6) <= rx_in;rx_state<=s7;end if;
                                        when s7=> if(receiverCount = 6)then rx_data_sig(7) <= rx_in;rx_state<=stop;end if;
                                        when stop=> if(receiverCount = 6)then if(rx_in='0')then rx_state<=idle;else rx_empty <= '0';rx_state<=idle;end if;end if;
                                        end case;
                    end if;
            
         end if;
           
    end process;

end Behavioral;
