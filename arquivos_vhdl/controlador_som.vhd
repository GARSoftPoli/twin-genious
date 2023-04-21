library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity controlador_som is
    port (
        clock   : in  std_logic;
        acerto : in  std_logic;
        erro  : in  std_logic;
        leds   : in  std_logic_vector(3 downto 0);
        som    : out std_logic
    );
end entity controlador_som;

architecture controla_som of controlador_som is

    component gerador_onda is
        generic (
            constant M: integer := 100 -- modulo do contador
        );
        port (
            clock   : in  std_logic;
            zera_as : in  std_logic;
            zera_s  : in  std_logic;
            conta   : in  std_logic;
            Q       : out std_logic_vector(natural(ceil(log2(real(M))))-1 downto 0);
            fim     : out std_logic;
            meio    : out std_logic
        );
    end component gerador_onda;

    signal som_acerto: std_logic;
    signal som_erro: std_logic;
    signal som_um: std_logic;
    signal som_dois: std_logic;
    signal som_quatro: std_logic;
    signal som_oito: std_logic;

    begin
        -- Considerando clock de 50 MHz da FPGA
        gerador_som_acerto: gerador_onda
            generic map(
                M => 100000
            )
            port map(
                clock => clock,
                zera_as => '0',
                zera_s => '0',
                conta => '1',
                Q => open,
                fim => open, 
                meio => som_acerto
            );

        gerador_som_erro: gerador_onda
            generic map(
                M => 500000
            )
            port map(
                clock => clock,
                zera_as => '0',
                zera_s => '0',
                conta => '1',
                Q => open,
                fim => open, 
                meio => som_erro
            );

        gerador_som_um: gerador_onda
            generic map(
                M => 239234
            )
            port map(
                clock => clock,
                zera_as => '0',
                zera_s => '0',
                conta => '1',
                Q => open,
                fim => open, 
                meio => som_um
            );

        gerador_som_dois: gerador_onda
            generic map(
                M => 198412
            )
            port map(
                clock => clock,
                zera_as => '0',
                zera_s => '0',
                conta => '1',
                Q => open,
                fim => open, 
                meio => som_dois
            );

        gerador_som_quatro: gerador_onda
            generic map(
                M => 161290
            )
            port map(
                clock => clock,
                zera_as => '0',
                zera_s => '0',
                conta => '1',
                Q => open,
                fim => open, 
                meio => som_quatro
            );

        gerador_som_oito: gerador_onda
            generic map(
                M => 120481
            )
            port map(
                clock => clock,
                zera_as => '0',
                zera_s => '0',
                conta => '1',
                Q => open,
                fim => open, 
                meio => som_oito
            );

    som <=
        som_acerto when acerto='1' else
        som_erro when erro='1' else
        som_um when leds="0001" and erro='0' and acerto='0' else
        som_dois when leds="0010" and erro='0' and acerto='0' else
        som_quatro when leds="0100" and erro='0' and acerto='0' else
        som_oito when leds="1000" and erro='0' and acerto='0' else
        '0';


end controla_som; 

