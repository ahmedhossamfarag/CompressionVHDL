library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;
use work.Config.all;

entity CompressionVHDL is
    port(
        CLK : in     std_logic;
        indata: in DataType;
        outdata: out DataType
    );
end entity CompressionVHDL;

architecture rtl of CompressionVHDL is
    signal start: integer;
    signal limit: integer;
    signal inbyte: std_logic;
    signal valid: boolean;
    signal finished: boolean;
begin

    transmiter_inst: entity work.Transmiter
    port map (
      CLK      => CLK,
      indata   => indata,
      start    => start,
      limit    => limit,
      inbyte   => inbyte,
      valid    => valid,
      finished => finished
    );

    reciever_inst: entity work.Reciever
    port map (
      CLK      => CLK,
      start    => start,
      limit    => limit,
      inbyte   => inbyte,
      valid    => valid,
      finished => finished,
      outdata  => outdata
    );

end architecture rtl;
