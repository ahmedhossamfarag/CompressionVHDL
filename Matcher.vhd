library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
use work.Config.all;

entity Matcher is
  port (
    CLK: in std_logic;
    wind: in WindType;
    dict: in DictType;
    dictSz: in integer;
    limit: in integer;
    start: inout integer := 0;
    equals: inout boolean;
    finished: inout boolean
  );
end entity;

architecture Matcher of Matcher is
    signal cmp_finished: boolean;
begin
    comparator_inst: entity work.Comparator
    port map (
      CLK      => CLK,
      wind     => wind,
      dict     => dict,
      start    => start,
      limit    => limit,
      equals   => equals,
      finished => cmp_finished
    );

    finished <= cmp_finished and (equals or start >= dictSz-limit-1);

    Count: process(CLK)
    begin
        if(rising_edge(CLK))then
            if(finished)then
                start <= 0;
            else
                if(cmp_finished)then
                    start <= start + 1;
                end if;
            end if;
        end if;
    end process;
end architecture;
