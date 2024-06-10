library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
use work.Config.all;

entity Comparator is
  port (
    CLK: in std_logic;
    wind: in WindType;
    windhigh: in integer;
    dict: in DictType;
    dictSz: in integer;
    start: in integer;
    reset: in BOOLEAN;
    equals: inout boolean;
    finished: inout boolean;
    max_start: inout integer := DS;
    max_limit: inout integer := 0;
    indx: inout integer := 0
  );
end entity;

architecture Comparator of Comparator is
    signal prevEq: boolean;
begin
    prevEq <= true when indx = 0 else equals;
    equals <= prevEq and wind(indx) = dict(start+ indx);
    finished <= not equals or indx = windhigh or start+indx >= dictSz-1;

    Count: process(CLK)
    begin
        if(rising_edge(CLK))then
            if(finished)then
                indx <= 0;
                if(reset)then
                  max_start <= DS;
                  max_limit <= 0;
                end if;
            else
                indx <= indx + 1;
                if(equals and indx >= max_limit)then
                  max_start <= start;
                  max_limit <= indx;
                end if;
            end if;
        end if;
    end process;
end architecture;
