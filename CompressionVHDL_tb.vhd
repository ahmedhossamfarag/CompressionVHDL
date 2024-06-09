library IEEE;
use IEEE.std_logic_1164.all;
use work.Config.all;

entity CompressionVHDL_tb is
end entity CompressionVHDL_tb;

architecture rtl of CompressionVHDL_tb is

    constant period_time : time      := 83333 ps;
    signal   finished    : std_logic := '0';

    signal CLK : std_logic;

    signal indata: DataType := "10010101010011001010";
    signal outdata: DataType;
begin

    sim_time_proc: process
    begin
        wait for 20 ms;
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            CLK <= '0';
            wait for period_time/2;
            CLK <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    compressionvhdl_inst: entity work.CompressionVHDL
    port map (
      CLK    => CLK,
      indata => indata,
      outdata => outdata
    );
end architecture rtl;
