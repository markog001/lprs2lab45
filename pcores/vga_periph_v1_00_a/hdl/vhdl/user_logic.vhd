------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Thu Apr 07 11:22:56 2016 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Addr                  -- Bus to IP address bus
--   Bus2IP_CS                    -- Bus to IP chip select
--   Bus2IP_RNW                   -- Bus to IP read/not write
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_NUM_REG                      : integer              := 1;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Addr                    : in  std_logic_vector(0 to 31);
    Bus2IP_CS                      : in  std_logic_vector(0 to 0);
    Bus2IP_RNW                     : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

	component vga_top is
  generic (
    H_RES                : natural := 640;
    V_RES                : natural := 480;
    MEM_ADDR_WIDTH       : natural := 32;
    GRAPH_MEM_ADDR_WIDTH : natural := 32;
    TEXT_MEM_DATA_WIDTH  : natural := 32;
    GRAPH_MEM_DATA_WIDTH : natural := 32;
    RES_TYPE             : natural := 0;       
    MEM_SIZE             : natural := 4800
    );
  port (
    clk_i               : in  std_logic;
    reset_n_i           : in  std_logic;
    --
    direct_mode_i       : in  std_logic; -- 0 - text and graphics interface mode, 1 - direct mode (direct force RGB component)
    dir_red_i           : in  std_logic_vector(7 downto 0);
    dir_green_i         : in  std_logic_vector(7 downto 0);
    dir_blue_i          : in  std_logic_vector(7 downto 0);
    dir_pixel_column_o  : out std_logic_vector(10 downto 0);
    dir_pixel_row_o     : out std_logic_vector(10 downto 0);
    -- mode interface
    display_mode_i      : in  std_logic_vector(1 downto 0);  -- 01 - text mode, 10 - graphics mode, 11 - text and graphics
    -- text mode interface
    text_addr_i         : in  std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
    text_data_i         : in  std_logic_vector(TEXT_MEM_DATA_WIDTH-1 downto 0);
    text_we_i           : in  std_logic;
    -- graphics mode interface
    graph_addr_i        : in  std_logic_vector(GRAPH_MEM_ADDR_WIDTH-1 downto 0);
    graph_data_i        : in  std_logic_vector(GRAPH_MEM_DATA_WIDTH-1 downto 0);
    graph_we_i          : in  std_logic;
    -- cfg
    font_size_i         : in  std_logic_vector(3 downto 0);
    show_frame_i        : in  std_logic;
    foreground_color_i  : in  std_logic_vector(23 downto 0);
    background_color_i  : in  std_logic_vector(23 downto 0);
    frame_color_i       : in  std_logic_vector(23 downto 0);
    -- vga
    vga_hsync_o         : out std_logic;
    vga_vsync_o         : out std_logic;
    blank_o             : out std_logic;
    pix_clock_o         : out std_logic;
    vga_rst_n_o         : out std_logic;
    psave_o             : out std_logic;
    sync_o              : out std_logic;
    red_o               : out std_logic_vector(7 downto 0); 
    green_o             : out std_logic_vector(7 downto 0); 
    blue_o              : out std_logic_vector(7 downto 0)
  );
end component;

component decoder is
    Port ( iSELECT : in  STD_LOGIC_VECTOR (1 downto 0);
           oD0 : out  STD_LOGIC;
           oD1 : out  STD_LOGIC;
           oD2 : out  STD_LOGIC;
           oD3 : out  STD_LOGIC);
end component;

component reg is
	generic(
		WIDTH    : positive := 1;
		RST_INIT : integer := 0
	);
	port(
		i_clk  : in  std_logic;
		in_rst : in  std_logic;
		i_d    : in  std_logic_vector(WIDTH-1 downto 0);
		o_q    : out std_logic_vector(WIDTH-1 downto 0)
	);
end component;


  --USER signal declarations added here, as needed for user logic

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg0                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg_write_sel              : std_logic_vector(0 to 0);
  signal slv_reg_read_sel               : std_logic_vector(0 to 0);
  signal slv_ip2bus_data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;
  
  signal sTxtWe 								 : std_logic;
  signal sGraphWe								 : std_logic;
  signal sRegWe 								 : std_logic;
  signal sTbd 									 : std_logic;
  signal sUnitId 								 : std_logic_vector(1 downto 0);
--  signal sTxtAddr 							 : std_logic_vector;
  
  signal direct_mode_s						 : std_logic_vector(0 downto 0);
  signal display_mode_s						 : std_logic_vector(1 downto 0);
  signal show_frame_s						 : std_logic_vector(0 downto 0);
  signal font_size_s							 : std_logic_vector(3 downto 0);
  signal foreground_color_s				 : std_logic_vector(23 downto 0);
  signal background_color_s				 : std_logic_vector(23 downto 0);
  signal frame_color_s						 : std_logic_vector(23 downto 0);
  
  signal direct_mode_we						 : std_logic;
  signal display_mode_we					 : std_logic;
  signal show_frame_we						 : std_logic;
  signal font_size_we						 : std_logic;
  signal foreground_color_we				 : std_logic;
  signal background_color_we				 : std_logic;
  signal frame_color_we						 : std_logic;
  
  signal direct_mode_clk					 : std_logic;
  signal display_mode_clk					 : std_logic;
  signal show_frame_clk						 : std_logic;
  signal font_size_clk						 : std_logic;
  signal foreground_color_clk				 : std_logic;
  signal background_color_clk				 : std_logic;
  signal frame_color_clk					 : std_logic;
  
  
  signal dir_pixel_column_s  				 : std_logic_vector(10 downto 0);
  signal dir_pixel_row_s     				 : std_logic_vector(10 downto 0);
	 
  signal	vga_hsync_s         				 : std_logic;
  signal	vga_vsync_s         				 : std_logic;
  signal	blank_s             				 : std_logic;
  signal	pix_clock_s         				 : std_logic;
  signal	vga_rst_n_s         				 : std_logic;
  signal	psave_s             				 : std_logic;
  signal	sync_s              				 : std_logic;
  signal	red_s               				 : std_logic_vector(7 downto 0); 
  signal	green_s             				 : std_logic_vector(7 downto 0); 
  signal	blue_s              				 : std_logic_vector(7 downto 0);
  

begin

  --USER logic implementation added here

  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_sel <= Bus2IP_WrCE(0 downto 0);
  slv_reg_read_sel  <= Bus2IP_RdCE(0 downto 0);
  slv_write_ack     <= Bus2IP_WrCE(0);
  slv_read_ack      <= Bus2IP_RdCE(0);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Resetn = '0' then
        slv_reg0 <= (others => '0');
      else
        case slv_reg_write_sel is
          when "1" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg0(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, slv_reg0 ) is
  begin

    case slv_reg_read_sel is
      when "1" => slv_ip2bus_data <= slv_reg0;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  (others => '0');

  IP2Bus_WrAck <= slv_write_ack;
  IP2Bus_RdAck <= slv_read_ack;
  IP2Bus_Error <= '0';
  
  
  vga_top_modul : vga_top
  generic map(
	 --GRAPH_MEM_ADDR_WIDTH : natural := 32;
	 GRAPH_MEM_ADDR_WIDTH => 22,
	 MEM_ADDR_WIDTH      => 14,
    TEXT_MEM_DATA_WIDTH => 6
  )
  port map(
    clk_i               =>	Bus2IP_Clk,
    reset_n_i           => Bus2IP_Resetn,
    --
    direct_mode_i       => direct_mode_s(0), -- 0 - text and graphics interface mode, 1 - direct mode (direct force RGB component)
    dir_red_i           => foreground_color_s(23 downto 16),
    dir_green_i         => foreground_color_s(15 downto 8),
    dir_blue_i          => foreground_color_s(7 downto 0),
    dir_pixel_column_o  => dir_pixel_column_s,
    dir_pixel_row_o     => dir_pixel_row_s,
    -- mode interface
    display_mode_i      => display_mode_s,  -- 01 - text mode, 10 - graphics mode, 11 - text and graphics
    -- text mode interface
    text_addr_i         => Bus2IP_Addr(2 to 15),
    text_data_i         => Bus2IP_Data(5 downto 0),
    text_we_i           => sTxtWe,
    -- graphics mode interface
    graph_addr_i			=> Bus2IP_Addr(2 to 23),
    graph_data_i        => Bus2IP_Data,
    graph_we_i          => sGraphWe,
    -- cfg
    font_size_i         => font_size_s,
    show_frame_i        => show_frame_s(0),
    foreground_color_i  => foreground_color_s,
    background_color_i  => background_color_s,
    frame_color_i       => frame_color_s,
    -- vga
    vga_hsync_o         => vga_hsync_s,
    vga_vsync_o         => vga_vsync_s,
    blank_o             => blank_s,
    pix_clock_o         => pix_clock_s,
    vga_rst_n_o         => vga_rst_n_s, 
    psave_o             => psave_s,
    sync_o              => sync_s,
    red_o               => red_s,
    green_o             => green_s, 
    blue_o              => blue_s
  );
  
  decod : decoder port map(
	iSELECT => Bus2IP_Addr(25) & Bus2IP_Addr(24),--Bus2IP_Addr(30 to 31),
	oD0 => sTxtWe,
	oD1 => sGraphWe,
	oD2 => sRegWe,
	oD3 => sTbd
  );
  
  --direct mode WE
  direct_mode_we <= '1' when Bus2IP_Addr(2 to 23) = x"00000" & "00" 
  else '0';
  direct_mode_clk <= Bus2IP_Clk and sRegWe and direct_mode_we;
  
  direct_mode_reg: reg
	generic map(
		WIDTH    =>  1,
		RST_INIT => 0
	)
	port map(
		i_clk  => direct_mode_clk,
		in_rst => Bus2IP_Resetn,
		i_d    => Bus2IP_Data(0 downto 0),
		o_q    => direct_mode_s(0 downto 0)
	);
	
	--display mode WE
  display_mode_we <= '1' when Bus2IP_Addr(2 to 23) = x"80000" & "00" 
  else '0';
  display_mode_clk <= Bus2IP_Clk and sRegWe and display_mode_we;
	
	display_mode_reg: reg
	generic map(
		WIDTH    =>  2,
		RST_INIT => 0
	)
	port map(
		i_clk  => display_mode_clk,
		in_rst => Bus2IP_Resetn,
		i_d    => Bus2IP_Data(1 downto 0),
		o_q    => display_mode_s
	);
	
	--show frame WE
  show_frame_we <= '1' when Bus2IP_Addr(2 to 23) = x"40000" & "00" 
  else '0';
  show_frame_clk <= Bus2IP_Clk and sRegWe and show_frame_we;
	
	show_frame_reg: reg
	generic map(
		WIDTH    =>  1,
		RST_INIT => 0
	)
	port map(
		i_clk  => show_frame_clk,
		in_rst => Bus2IP_Resetn,
		i_d    => Bus2IP_Data(0 downto 0),
		o_q    => show_frame_s(0 downto 0)
	);
	
	--font size WE
  font_size_we <= '1' when Bus2IP_Addr(2 to 23) = x"C0000" & "00" 
  else '0';
  font_size_clk <= Bus2IP_Clk and sRegWe and font_size_we;
	
	font_size_reg: reg
	generic map(
		WIDTH    =>  4,
		RST_INIT => 0
	)
	port map(
		i_clk  => font_size_clk,
		in_rst => Bus2IP_Resetn,
		i_d    => Bus2IP_Data(3 downto 0),
		o_q    => font_size_s
	);
	
	--foreground color WE
  foreground_color_we <= '1' when Bus2IP_Addr(2 to 23) = x"20000" & "00"
  else '0';
  foreground_color_clk <= Bus2IP_Clk and sRegWe and foreground_color_we;
	
	foreground_color_reg: reg
	generic map(
		WIDTH    =>  24,
		RST_INIT => 0
	)
	port map(
		i_clk  => foreground_color_clk,
		in_rst => Bus2IP_Resetn,
		i_d    => Bus2IP_Data(23 downto 0),
		o_q    => foreground_color_s
	);
	
	--background color WE
  background_color_we <= '1' when Bus2IP_Addr(2 to 23) = x"A0000" & "00" 
  else '0';
  background_color_clk <= Bus2IP_Clk and sRegWe and background_color_we;
	
	background_color_reg: reg
	generic map(
		WIDTH    =>  24,
		RST_INIT => 0
	)
	port map(
		i_clk  => background_color_clk,
		in_rst => Bus2IP_Resetn,
		i_d    => Bus2IP_Data(23 downto 0),
		o_q    => background_color_s
	);
	
	--frame color WE
  frame_color_we <= '1' when Bus2IP_Addr(2 to 23) = x"60000" & "00" 
  else '0';
  frame_color_clk <= Bus2IP_Clk and sRegWe and frame_color_we;
	
	frame_color_reg: reg
	generic map(
		WIDTH    =>  24,
		RST_INIT => 0
	)
	port map(
		i_clk  => frame_color_clk,
		in_rst => Bus2IP_Resetn,
		i_d    => Bus2IP_Data(23 downto 0),
		o_q    => frame_color_s
	);
	
	--data out
	IP2Bus_Data <= x"0000000" & "000" & direct_mode_s(0) 			when Bus2IP_Addr(2 to 23) = x"00000" & "00"
				else	x"0000000" & "00" & display_mode_s 			when Bus2IP_Addr(2 to 23) = x"80000" & "00"
				else	x"0000000" & "000" & show_frame_s(0)			when Bus2IP_Addr(2 to 23) = x"40000" & "00"
				else	x"0000000" & font_size_s 						when Bus2IP_Addr(2 to 23) = x"C0000" & "00"
				else	x"00" 	  & foreground_color_s 				when Bus2IP_Addr(2 to 23) = x"20000" & "00"
				else	x"00" 	  & background_color_s 	when Bus2IP_Addr(2 to 23) = x"A0000" & "00"
				else	x"00"		  & frame_color_s 			when Bus2IP_Addr(2 to 23) = x"60000" & "00"
				else  "000000" & vga_hsync_s & vga_vsync_s & blank_s &
						vga_rst_n_s & psave_s & sync_s &
						dir_pixel_column_s & dir_pixel_row_s;-- when IP2Bus_Data = x"0000001C"
	

end IMP;
