----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:10:20 04/07/2016 
-- Design Name: 
-- Module Name:    decoder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder is
    Port ( iSELECT : in  STD_LOGIC_VECTOR (1 downto 0);
           oD0 : out  STD_LOGIC;
           oD1 : out  STD_LOGIC;
           oD2 : out  STD_LOGIC;
           oD3 : out  STD_LOGIC);
end decoder;

architecture Behavioral of decoder is

begin

	oD0 <= '1' when iSELECT = "00"
	else '0';
	
	oD1 <= '1' when iSELECT = "01"
	else '0';
	
	oD2 <= '1' when iSELECT = "10"
	else '0';
	
	oD3 <= '1' when iSELECT = "11"
	else '0';


end Behavioral;

