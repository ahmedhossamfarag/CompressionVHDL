library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
use work.Config.all;

entity Reciever is
  port (
    CLK: in std_logic;
    start: in integer;
    limit: in integer;
    inbyte: in std_logic;
    valid: in boolean;
    finished: in boolean;
    outdata: out DataType
  );
end entity;

architecture Reciever of Reciever is
    signal data: DataType;
    signal dict: DictType;
    signal indx: integer := 0;
begin
    outdata <= data;

    dictionary_inst: entity work.Dictionary
    port map (
      CLK    => CLK,
      inbyte => inbyte,
      write  => valid,
      dict   => dict
    );

    recieve: process(CLK)
    begin
        if(rising_edge(CLK) and valid and not finished)then
                if(start = DS)then
                    data(indx) <= inbyte;
                    indx <= indx + 1;
                else
                    for i in 0 to limit loop
                        data(indx + i) <= dict(start + i);
                    end loop;
                    if(indx + limit + 1 <= data'high)then
                        data(indx + limit + 1) <= inbyte;
                        indx <= indx + limit + 2;
                    end if;
                end if;
        end if;
    end process;
end architecture;
