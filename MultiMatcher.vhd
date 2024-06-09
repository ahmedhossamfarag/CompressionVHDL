library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
use work.Config.all;

entity MultiMatcher is
  port (
    CLK: in std_logic;
    wind: in WindType;
    dict: in DictType;
    dictSz: in integer;
    start: inout integer := 0;
    limit: inout integer := WS-1;
    equals: inout boolean;
    finished: inout boolean
  );
end entity;

architecture MultiMatcher of MultiMatcher is
    signal match_finished: boolean;
begin
    matcher_inst: entity work.Matcher
    port map (
      CLK      => CLK,
      wind     => wind,
      dict     => dict,
      dictSz   => dictSz,
      limit    => limit,
      start    => start,
      equals   => equals,
      finished => match_finished
    );

    finished <= match_finished and (equals or limit = 0);

    Count: process(CLK)
    begin
        if(rising_edge(CLK))then
            if(finished)then
                limit <= WS-1;
            else
                if(match_finished)then
                    limit <= limit - 1;
                end if;
            end if;
        end if;
    end process;
end architecture;
