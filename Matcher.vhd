library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
use work.Config.all;

entity Matcher is
  port (
    CLK: in std_logic;
    wind: in WindType;
    windhigh: in integer;
    dict: in DictType;
    dictSz: in integer;
    limit: inout integer;
    start: inout integer := 0;
    equals: inout boolean;
    finished: inout boolean
  );
end entity;

architecture Matcher of Matcher is
    signal cmp_start: integer := 0;
    signal cmp_finished: boolean;
    signal cmp_equals: boolean;
    signal cmp_indx: integer;
    signal max_start: integer;
    signal max_limit: integer;
begin
    comparator_inst: entity work.Comparator
    port map (
      CLK       => CLK,
      wind      => wind,
      windhigh  => windhigh,
      dict      => dict,
      dictSz    => dictSz,
      start     => cmp_start,
      equals    => cmp_equals,
      finished  => cmp_finished,
      max_start => max_start,
      max_limit => max_limit,
      indx      => cmp_indx
    );

    finished <= cmp_finished and (cmp_equals or cmp_start >= dictSz-1 or (max_start /= DS and dictSz-max_start-1 <= max_limit+1));
    start <= cmp_start when cmp_finished and cmp_equals else max_start;
    limit <= cmp_indx when cmp_finished and cmp_equals else max_limit;
    equals <= cmp_equals or max_start /= DS;

    Count: process(CLK)
    begin
        if(rising_edge(CLK))then
            if(finished)then
                cmp_start <= 0;
            else
                if(cmp_finished)then
                    cmp_start <= cmp_start + 1;
                end if;
            end if;
        end if;
    end process;
end architecture;
