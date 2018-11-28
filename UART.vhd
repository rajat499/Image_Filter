----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2018 02:52:44 PM
-- Design Name: 
-- Module Name: UART - Behavioral
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
use IEEE.numeric_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART is
    Port ( Clk : in STD_LOGIC;
           rx_in : in STD_LOGIC;
           rx_en : in STD_LOGIC;
           tx_out : out STD_LOGIC;
           tx_en : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (7 downto 0);
            LEDt : out STD_LOGIC_VECTOR (7 downto 0);
           reset : in STD_LOGIC);
end UART;

 architecture Behavioral of UART is

component receiver
PORT(
    rxclk : in std_logic;
    reset : in std_logic;
    rx_en : in std_logic;
    uld_rx : in std_logic;
    rx_in : in std_logic;
    rx_data : out std_logic_vector (7 downto 0);
    rx_empty : out std_logic
    );
end component;

component transmitter
PORT(
    txclk : in std_logic;
    reset : in std_logic;
    tx_en : in std_logic;
    ld_tx : in std_logic;
    tx_out : out std_logic;
    tx_data : in std_logic_vector (7 downto 0);
    tx_empty : out std_logic;
    temp : in std_logic
    );
end component;

component memory
PORT(
    doutb : out STD_LOGIC_VECTOR(7 downto 0);
    dina : in STD_LOGIC_VECTOR(7 downto 0);
    addra1, addra2 : in integer;
    addrb1, addrb2 : in integer;
    clk : in STD_LOGIC;
    enb : in STD_LOGIC;
    wea : in STD_LOGIC
    );
end component;


signal rxclk, uld_rx,txclk,ld_tx,enb,wea: std_logic := '0' ;
signal rx_empty,tx_empty : std_logic;
signal temp : std_logic := '1';
signal rtemp,ttemp : Integer := 0;
signal rx_data,tx_data,doutb,dina: std_logic_vector (7 downto 0):="00000000";
signal addrb1, addrb2: integer := 0;
signal addra1, addra2: integer:= 0;

signal receiverCounter,transmitterCounter : Integer := 0;

begin
    
rx_instance: receiver port map(
    rxclk => rxclk,
    reset => reset,
    rx_en => rx_en,
    uld_rx => uld_rx,
    rx_in => rx_in,
    rx_data => rx_data,
    rx_empty => rx_empty
);

tx_instance: transmitter port map(
    txclk => txclk,
    reset => reset,
    tx_en => tx_en,
    ld_tx => ld_tx,
    tx_out => tx_out,
    tx_data => tx_data,
    tx_empty => tx_empty,
    temp => temp
);

memory_instance: memory port map(
    doutb => doutb,
    dina => dina,
    addra1 => addra2,
    addra2 => addra1,
    addrb1 => addrb2,
    addrb2 => addrb1,
    clk => rxclk,
    enb => enb,
    wea => wea
);

    PROCESS(Clk)BEGIN
                IF(Clk = '1' AND Clk'EVENT) THEN 
                    IF(transmitterCounter = 5207)  THEN
                        txclk <= NOT txclk;
                        transmitterCounter <= 0;
                    ELSE 
                        transmitterCounter <= transmitterCounter + 1;
                    END IF;
                END IF;
     END PROCESS;

    PROCESS(Clk)BEGIN
                IF(Clk = '1' AND Clk'EVENT) THEN 
                    IF(receiverCounter = 325)  THEN
                        rxclk <= NOT rxclk;
                        receiverCounter <= 0;
                    ELSE 
                        receiverCounter <= receiverCounter + 1;
                    END IF;
                END IF;
     END PROCESS;
     
     
     PROCESS(Clk,reset)BEGIN
        if(reset = '1') then
            uld_rx <='0';
            ld_tx <='0';
            addra1 <= 0 ;
            addra2 <= 0;
            addrb1 <= 0 ;
            addrb2 <= 0 ;
            
        elsif(Clk = '1' AND Clk'EVENT) THEN
            
            if(rx_empty='0')then
                uld_rx <= '1';
                wea <= '0';
                if(rtemp=0)then
                            temp <= '1';
                            if (addra1 = 23 and addra2 = 6) then
                                addra1 <= 0;
                                addra2 <= 0;
                            elsif (addra1 = 23) then
                                addra1 <= 0;
                                addra2 <= addra2 +1;
                            else
                                addra1<= addra1+1;
                            end if;
                end if;
                rtemp <= rtemp + 1;
            else
                wea <= '1';
                rtemp <= 0;
                uld_rx <= '0';
                
            end if;
            if(tx_en = '0')then
             addrb1 <= 0;
             addrb2 <= 0;
 --          enb <= '0';
            end if;
            
            if(tx_empty = '1') then
                        
                        if(ttemp=0)then
                            
--                            if( ((addrb > addra)or(addra = addrb)) and not(addra = "00000000") )then
--                                temp<='0';
--                                addrb <= "00000000";
--                            else                                          
--                                addrb <= std_logic_vector(unsigned(addrb) + 1) ;
--                            end if;
                              if (addrb1 = 23 and addrb2 = 6) then
                                temp<='0';
                                addrb1 <= 0;
                                addrb2 <= 0;
                              elsif (addrb1 = 23) then
                                addrb1 <= 0;
                                addrb2 <= addrb2 +1;
                              else
                                addrb1 <= addrb1 + 1;
                              end if;                                
                        end if;  
                  enb <= '1'; 
                  ld_tx <= '1';
                  ttemp <= ttemp + 1; 
                else
                  
                  ttemp <= 0;
                  enb <= '0';
                  ld_tx <= '0';
            end if;
        LED <= rx_data;
        LEDt <= tx_data;
        dina <= rx_data;
        tx_data <= doutb;
        end if;
    end process;
end Behavioral;