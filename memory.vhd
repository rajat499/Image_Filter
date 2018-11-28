----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/28/2018 11:51:15 PM
-- Design Name: 
-- Module Name: memory - Behavioral
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
use IEEE.numeric_std.ALL;
use work.array_type.all;

package check is
function fill(a: input_type; x: integer; y: integer) return std_logic_vector;
end package check;

package body check is
function fill(a: input_type; x: integer; y: integer) return std_logic_vector is
        constant filter1: filter_type := ((8,16,8),(16,32,16),(8,16,8));
        constant filter2: filter_type := ((-14,-14,-14),(-14,242,-14),(-14,-14,-14));
        constant filterarray: array_type :=(filter1, filter2);
        variable sum: integer:= 0;
        --variable output: output_type;
begin
           mult_row_loop: for i in 0 to 2 loop
               mult_col_loop: for j in 0 to 2 loop
                   if((i+x-1)<0 or (i+x-1)>6 or (j+y-1)<0 or (j+y-1)>23) then
                       sum:=sum+0;
                   else
                       sum:= sum + filter2(i,j)*(to_integer(signed(a(i+x-1,j+y-1))));                        
                   end if;
               end loop mult_col_loop;
           end loop mult_row_loop;
           if(sum<0) then
               return "00000000";
           else
               return std_logic_vector(to_unsigned(sum/128, 8));
           end if;
   --return output;    
end fill;
end package body check;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.array_type.all;
use work.check.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory is
    Port ( doutb : out STD_LOGIC_VECTOR(7 downto 0);
           dina : in STD_LOGIC_VECTOR(7 downto 0);
           addra1, addra2 : in integer;
           addrb1, addrb2 : in integer; 
           clk : in STD_LOGIC;
           enb : in STD_LOGIC;
           wea : in STD_LOGIC);
end memory;

architecture Behavioral of memory is
type Arr is array (0 to 255 ) of std_logic_vector(7 downto 0 );
signal addressArray : input_type;
--signal outputArray: output_type;
SIGNAL b : INTEGER ;
 

    attribute ram_style: string;
    attribute ram_style of addressArray: signal is "block";
    --attribute ram_style of outputArray: signal is "block";
begin
--    A: entity work.filter(arch_filter) port map(addressArray, outputArray, clk);
    PROCESS(clk)BEGIN
            IF(clk = '1' AND clk'EVENT) THEN 
                if(wea = '1')then
                    addressArray((addra1),(addra2)) <= dina;
                end if;
                if(enb = '1')then
                    doutb<= fill(addressArray, addrb1, addrb2);
                    --doutb <= outputArray(addrb1, addrb2);
                end if;
            END IF;
 END PROCESS;

end Behavioral;
