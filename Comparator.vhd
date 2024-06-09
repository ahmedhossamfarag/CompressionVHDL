library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
use work.Config.all;

entity Comparator is
  port (
    CLK: in std_logic;
    wind: in WindType;
    dict: in DictType;
    start: in integer;
    limit: in integer;
    equals: inout boolean;
    finished: inout boolean
  );
end entity;

architecture Comparator of Comparator is
    signal indx: integer := 0;
    signal prevEq: boolean;
begin
    prevEq <= true when indx = 0 else equals;
    equals <= prevEq and wind(indx) = dict(start+ indx);
    finished <= not equals or indx = limit;

    Count: process(CLK)
    begin
        if(rising_edge(CLK))then
            if(finished)then
                indx <= 0;
            else
                indx <= indx + 1;
            end if;
        end if;
    end process;
end architecture;
