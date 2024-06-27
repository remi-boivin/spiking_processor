-- File: lif_calcium.vhd
-- Generated by MyHDL 0.11.45
-- Date: Thu Jun 13 14:27:42 2024


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

use work.pck_myhdl_011.all;

entity lif_calcium is
    port (
        param_ca_en: in std_logic;
        param_caleak: in unsigned(4 downto 0);
        state_calcium: in unsigned(2 downto 0);
        state_caleak_cnt: in unsigned(4 downto 0);
        spike_out: in std_logic;
        event_tref: in std_logic;
        state_calcium_next: out unsigned(2 downto 0);
        state_caleak_cnt_next: out unsigned(4 downto 0)
    );
end entity lif_calcium;


architecture MyHDL of lif_calcium is



signal ca_leak: std_logic;

begin




LIF_CALCIUM_UPDATE_CALCIUM: process (ca_leak, state_calcium, param_ca_en, spike_out) is
begin
    if bool(param_ca_en) then
        if (bool(spike_out) and (not bool(ca_leak)) and (state_calcium = 0)) then
            state_calcium_next <= (state_calcium + 1);
        elsif (bool(ca_leak) and (not bool(spike_out)) and (state_calcium > 0)) then
            state_calcium_next <= (state_calcium - 1);
        else
            state_calcium_next <= state_calcium;
        end if;
    else
        state_calcium_next <= state_calcium;
    end if;
end process LIF_CALCIUM_UPDATE_CALCIUM;

LIF_CALCIUM_UPDATE_CALEAK: process (state_caleak_cnt, param_caleak, event_tref, param_ca_en) is
begin
    if (bool(param_ca_en) and (param_caleak > 0) and bool(event_tref)) then
        if (signed(resize(state_caleak_cnt, 6)) = (signed(resize(param_caleak, 6)) - 1)) then
            state_caleak_cnt_next <= to_unsigned(0, 5);
            ca_leak <= '1';
        else
            state_caleak_cnt_next <= (state_caleak_cnt + 1);
            ca_leak <= '0';
        end if;
    else
        state_caleak_cnt_next <= state_caleak_cnt;
        ca_leak <= '0';
    end if;
end process LIF_CALCIUM_UPDATE_CALEAK;

end architecture MyHDL;