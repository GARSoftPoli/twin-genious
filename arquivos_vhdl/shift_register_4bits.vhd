-----------------Laboratorio Digital-------------------------------------
-- Arquivo   : registrador_n.vhd
-- Projeto   : Experiencia 3 - Projeto de uma unidade de controle
-------------------------------------------------------------------------
-- Descricao : registrador com numero de bits N como generic
--             com clear assincrono e carga sincrona
--
--             baseado no codigo vreg16.vhd do livro
--             J. Wakerly, Digital design: principles and practices 4e
--
-- Exemplo de instanciacao:
--      REG1 : registrador_n
--             generic map ( N => 12 )
--             port map (
--                 clock  => clock, 
--                 clear  => zera_reg1, 
--                 enable => registra1, 
--                 D      => s_medida, 
--                 Q      => distancia
--             );
-------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     09/09/2019  1.0     Edson Midorikawa  criacao
--     08/06/2020  1.1     Edson Midorikawa  revisao e melhoria de codigo 
--     09/09/2020  1.2     Edson Midorikawa  revisao 
--     09/09/2021  1.3     Edson Midorikawa  revisao 
--     03/09/2022  1.4     Edson Midorikawa  revisao do codigo
--     20/01/2023  1.4.1   Edson Midorikawa  revisao do codigo
-------------------------------------------------------------------------
--

library ieee;
use ieee.std_logic_1164.all;

entity shift_register_4bits is
    port (
        clock  : in  std_logic;
        reset  : in  std_logic;
        stp   : in  std_logic;
        Q      : out std_logic_vector (3 downto 0) 
    );
end entity shift_register_4bits;

architecture arch of shift_register_4bits is
    signal dado_registrado: std_logic_vector(3 downto 0);
begin
    process(clock, stp)
    begin
        if (reset = '1') then  
            dado_registrado <= "0001";
        elsif (rising_edge(clock) and stp='0') then   
            dado_registrado(1) <= dado_registrado(0);  
            dado_registrado(2) <= dado_registrado(1);  
            dado_registrado(3) <= dado_registrado(2);  
            dado_registrado(0) <= dado_registrado(3);
				dado_registrado <= dado_registrado(2 downto 0) & dado_registrado(3);
        end if; 
    end process;
    Q <= dado_registrado;
  
end architecture arch;