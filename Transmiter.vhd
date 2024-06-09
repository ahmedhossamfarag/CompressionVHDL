library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
use work.Config.all;

entity Transmiter is
  port (
    CLK: in std_logic;
    indata: in DataType;
    start: inout integer;
    limit: inout integer;
    inbyte: inout std_logic;
    valid: inout boolean;
    finished: out boolean := false
  );
end entity;

architecture Transmiter of Transmiter is
    signal data: TrDataType;
    signal dict: DictType;
    signal dictSz: integer;
    signal wind: WindType;
    signal windhigh: integer;
    signal equals: boolean;
    signal match_finished: boolean;
    signal indx: integer := 0;
begin

    data_generate: for i in 0 to indata'high generate
        data(i) <= indata(i);
    end generate;

    dictionary_inst: entity work.Dictionary
    port map (
      CLK    => CLK,
      inbyte => inbyte,
      write  => valid,
      dict   => dict,
      dictSz => dictSz
    );

    wind_generate:for i in 0 to wind'high generate
        wind(i) <= data(indx+i);
    end generate;

    windhigh <= indata'high-indx when indata'high-indx < wind'high else wind'high;

    matcher_inst: entity work.Matcher
    port map (
      CLK      => CLK,
      wind     => wind,
      windhigh => windhigh,
      dict     => dict,
      dictSz   => dictSz,
      limit    => limit,
      start    => start,
      equals   => equals,
      finished => match_finished
    );


    inbyte <= data(indx+limit+1) when equals else data(indx);
    valid <= match_finished;

    Count: process(CLK)
    begin
        if(rising_edge(CLK) and match_finished)then
                if(start < DS)then
                    if(indx + limit + 1 < indata'high)then
                        indx <= indx + limit + 2;
                    else
                        finished <= true;
                    end if;
                else
                    if(indx < indata'high)then
                        indx <= indx + 1;
                    else
                        finished <= true;
                    end if;
                end if;
            end if;
    end process;

end architecture;
