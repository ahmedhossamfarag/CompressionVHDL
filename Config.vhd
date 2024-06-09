library IEEE;
    use IEEE.std_logic_1164.all;

package Config is
    constant WS: integer := 4;
    constant DS: integer := 10;
    constant DataLn: integer := 20;
    type WindType is array(0 to WS-1) of std_logic;
    type DictType is array(0 to DS-1) of std_logic;
    type DataType is array(0 to DataLn-1) of std_logic;
    type TrDataType is array(0 to DataLn+WS+1) of std_logic;
end package;
