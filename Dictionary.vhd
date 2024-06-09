library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
use work.Config.all;

entity Dictionary is
  port (
    CLK: in std_logic;
    inbyte: in std_logic;
    write: in boolean;
    dict: inout DictType;
    dictSz: inout integer := 0
  );
end entity;

architecture Dictionary of Dictionary is
begin
    write_process: process(CLK)
    begin
        if(rising_edge(CLK) and write)then
            if(dictSz = Ds)then
                for i in 0 to DS-2 loop
                    dict(i) <= dict(i+1);
                end loop;
                dict(DS-1) <= inbyte;
            else
                dict(dictSz) <= inbyte;
                dictSz <= dictSz + 1;
            end if;
        end if;
    end process;
end architecture;
