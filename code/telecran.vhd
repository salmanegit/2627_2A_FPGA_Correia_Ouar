library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library pll;
use pll.all;


entity telecran is
    port (
        i_clk_50: in std_logic;

        io_hdmi_i2c_scl       : inout std_logic;
        io_hdmi_i2c_sda       : inout std_logic;
        o_hdmi_tx_clk         : out std_logic;
        o_hdmi_tx_d           : out std_logic_vector(23 downto 0);
        o_hdmi_tx_de          : out std_logic;
        o_hdmi_tx_hs          : out std_logic;
        i_hdmi_tx_int         : in std_logic;
        o_hdmi_tx_vs          : out std_logic;

        i_rst_n : in std_logic;
          
        o_leds : out std_logic_vector(9 downto 0);
        o_de10_leds : out std_logic_vector(7 downto 0);

        i_left_ch_a : in std_logic;
        i_left_ch_b : in std_logic;
        i_left_pb : in std_logic;
        i_right_ch_a : in std_logic;
        i_right_ch_b : in std_logic;
        i_right_pb : in std_logic
    );
end entity telecran;

architecture rtl of telecran is
    component I2C_HDMI_Config 
        port (
            iCLK : in std_logic;
            iRST_N : in std_logic;
            I2C_SCLK : out std_logic;
            I2C_SDAT : inout std_logic;
            HDMI_TX_INT  : in std_logic
        );
    end component;
    
    component pll 
        port (
            refclk : in std_logic;
            rst : in std_logic;
            outclk_0 : out std_logic;
            locked : out std_logic
        );
    end component;

    constant h_res      : natural := 720;
    constant v_res      : natural := 480;
    constant c_mem_size : natural := h_res * v_res;
    constant c_max_addr : natural := c_mem_size - 1;

    signal s_clk_27 : std_logic;
    signal s_rst_n  : std_logic;

    signal r_L_A_prev, r_L_B_prev : std_logic := '0';
    signal r_R_A_prev, r_R_B_prev : std_logic := '0';
    signal r_x_pos : natural range 0 to h_res - 1 := h_res / 2; 
    signal r_y_pos : natural range 0 to v_res - 1 := v_res / 2;

    signal s_x_counter : natural;
    signal s_y_counter : natural;

    type t_state is (S_DRAW, S_CLEAR);
    signal r_state      : t_state := S_DRAW;
    signal r_clear_addr : natural range 0 to c_max_addr := 0;
    
    signal s_addr_enc   : natural range 0 to c_max_addr;
    signal s_ram_addr_a : natural range 0 to c_max_addr;
    signal s_ram_addr_b : natural range 0 to c_max_addr;
    signal s_ram_data_a : std_logic_vector(0 downto 0);
    signal s_pixel_read : std_logic_vector(0 downto 0);

begin
    
    o_hdmi_tx_clk <= s_clk_27;
    
    o_leds <= std_logic_vector(to_unsigned(r_x_pos, 10));
    o_de10_leds <= (others => '0');

    process(i_clk_50, i_rst_n)
    begin
        if i_rst_n = '0' then
            r_L_A_prev <= '0';
            r_L_B_prev <= '0';
            r_R_A_prev <= '0';
            r_R_B_prev <= '0';
            r_x_pos    <= h_res / 2;
            r_y_pos    <= v_res / 2;
            
        elsif rising_edge(i_clk_50) then
            r_L_A_prev <= i_left_ch_a;
            r_L_B_prev <= i_left_ch_b;
            r_R_A_prev <= i_right_ch_a;
            r_R_B_prev <= i_right_ch_b;

            if (i_left_ch_a = '1' and r_L_A_prev = '0' and i_left_ch_b = '0') then
                if r_x_pos < h_res - 1 then
                    r_x_pos <= r_x_pos + 1;
                end if;
            elsif (i_left_ch_b = '1' and r_L_B_prev = '0' and i_left_ch_a = '0') then
                if r_x_pos > 0 then
                    r_x_pos <= r_x_pos - 1;
                end if;
            end if;

            if (i_right_ch_a = '1' and r_R_A_prev = '0' and i_right_ch_b = '0') then
                if r_y_pos < v_res - 1 then
                    r_y_pos <= r_y_pos + 1;
                end if;
            elsif (i_right_ch_b = '1' and r_R_B_prev = '0' and i_right_ch_a = '0') then
                if r_y_pos > 0 then
                    r_y_pos <= r_y_pos - 1;
                end if;
            end if;
        end if;
    end process;

    process(i_clk_50, i_rst_n)
    begin
        if i_rst_n = '0' then
            r_state      <= S_DRAW;
            r_clear_addr <= 0;
        elsif rising_edge(i_clk_50) then
            case r_state is
                when S_DRAW =>
                    if i_left_pb = '0' then 
                        r_clear_addr <= 0;
                        r_state      <= S_CLEAR;
                    end if;

                when S_CLEAR =>
                    if r_clear_addr < c_max_addr then
                        r_clear_addr <= r_clear_addr + 1;
                    else
                        r_state <= S_DRAW;
                    end if;
            end case;
        end if;
    end process;

    s_addr_enc   <= (r_y_pos * h_res) + r_x_pos;
    s_ram_addr_a <= r_clear_addr when r_state = S_CLEAR else s_addr_enc;
    s_ram_data_a <= "0" when r_state = S_CLEAR else "1";

    s_ram_addr_b <= (s_y_counter * h_res) + s_x_counter when (s_x_counter < h_res and s_y_counter < v_res) else 0;

    u_ram : entity work.dpram
        generic map (
            mem_size   => c_mem_size,
            data_width => 1
        )
        port map (
            i_clk_a  => i_clk_50,
            i_clk_b  => s_clk_27,
            i_data_a => s_ram_data_a,
            i_data_b => "0",
            i_addr_a => s_ram_addr_a,
            i_addr_b => s_ram_addr_b,
            i_we_a   => '1',
            i_we_b   => '0',
            o_q_a    => open,
            o_q_b    => s_pixel_read
        );

    o_hdmi_tx_d <= x"FFFFFF" when s_pixel_read = "1" else x"000000";

    u_hdmi : entity work.hdmi_controler
        port map (
            i_clk           => s_clk_27,
            i_rst_n         => s_rst_n,
            o_hdmi_hs       => o_hdmi_tx_hs,
            o_hdmi_vs       => o_hdmi_tx_vs,
            o_hdmi_de       => o_hdmi_tx_de,
            o_pixel_en      => open,
            o_pixel_address => open,
            o_x_counter     => s_x_counter,
            o_y_counter     => s_y_counter
        );

    pll0 : component pll 
        port map (
            refclk   => i_clk_50,
            rst      => not(i_rst_n),
            outclk_0 => s_clk_27,
            locked   => s_rst_n
        );

    I2C_HDMI_Config0 : component I2C_HDMI_Config 
        port map (
            iCLK        => i_clk_50,
            iRST_N      => i_rst_n,
            I2C_SCLK    => io_hdmi_i2c_scl,
            I2C_SDAT    => io_hdmi_i2c_sda,
            HDMI_TX_INT => i_hdmi_tx_int
        );
end architecture rtl;
