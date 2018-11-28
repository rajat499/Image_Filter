library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
package array_type is
    type input_type is array(0 to 6, 0 to 23) of std_logic_vector(7 downto 0);
    type output_type is array(0 to 6, 0 to 23) of std_logic_vector(7 downto 0);
    type filter_type is array(0 to 2, 0 to 2) of integer;
    type array_type is array(0 to 1) of filter_type;
end package array_type;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use work.array_type.all;



entity filter is 
port(
    input: in input_type;
     output: out output_type;
     clk: in std_logic);
     --filtering_type: in std_logic);  
end filter;

architecture arch_filter of filter is
    constant filter1: filter_type := ((8,16,8),(16,32,16),(8,16,8));
    constant filter2: filter_type := ((-14,-14,-14),(-14,242,-14),(-14,-14,-14));
    constant filterarray: array_type :=(filter1, filter2);
    signal sum: integer;
    
    attribute ram_style: string;
    attribute ram_style of input: signal is "block";
    attribute ram_style of output: signal is "block";
begin

process(clk)
variable i,j,x,y: std_logic;
begin
    row_loop: for i in 0 to 6 loop
        col_loop: for j in 0 to 23 loop
            sum<=0;
            mult_row_loop: for x in 0 to 2 loop
                mult_col_loop: for y in 0 to 2 loop
                    if((i+x-1)<0 or (i+x-1)>6 or (j+y-1)<0 or (j+y-1)>23) then
                        sum<=sum+0;
                    else
                        sum<= sum + filter1(x,y)*(to_integer(unsigned(input(i+x-1,j+y-1))));                        
                    end if;
                end loop mult_col_loop;
            end loop mult_row_loop;
            if(sum<0) then
                output(i,j)<="00000000";
            else
                output(i,j)<=std_logic_vector(to_unsigned(sum/128, 8));
            end if;
        end loop col_loop;
    end loop row_loop;
end process;


end arch_filter;
