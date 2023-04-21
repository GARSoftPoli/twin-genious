--------------------------------------------------------------------
-- Arquivo   : unidade_controle.vhd
-- Projeto   : Experiencia 6 - Projeto do Jogo do Desafio da Memória
--------------------------------------------------------------------
-- Descricao : unidade de controle 
--
--             1) codificação VHDL (maquina de Moore)
--
--             2) definicao de valores da saida de depuracao
--                db_estado
-- 
--------------------------------------------------------------------
-- Revisoes  :
--------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is 
    port ( 
        clock     : in  std_logic; 
        reset     : in  std_logic; 
        iniciar   : in  std_logic;
        enderecoIgualRodada: in std_logic;
        jogadaCorreta: in std_logic;
        fimR: in std_logic;
        fimM: in std_logic;
        fimE: in std_logic;	
	    fimT: in std_logic;
		fimSemExibicao: in std_logic;
        modo: in std_logic_vector(3 downto 0);
        temJogada: in std_logic;
        zeraR: out std_logic;
        zeraM: out std_logic;
        zeraT: out std_logic;
        zeraE: out std_logic;
		zeraSemExibicao: out std_logic;
        zeraRegJogada: out std_logic;
        zeraRegModo: out std_logic;
        zeraRegDificuldade: out std_logic;
        contaM: out std_logic;
        contaR: out std_logic;
        contaT: out std_logic;
        contaE: out std_logic;
		contaSemExibicao: out std_logic;
        reiniciaShiftRegister: out std_logic;
        registraRegJogada: out std_logic;
        registraRegModo: out std_logic; 
        registraRegDificuldade: out std_logic;  
        escreve   : out std_logic;     
        escreveAleatorio : out std_logic;
        acertou   : out std_logic;
        errou     : out std_logic;
        pronto    : out std_logic;
        timeout: out std_logic;
        selecionaSaida: out std_logic;
        db_estado : out std_logic_vector(3 downto 0)
    );
end entity;

architecture fsm of unidade_controle is

    type t_estado is (inicial, aguarda_modo, registra_modo, aguarda_dificuldade, registra_dificuldade, escrita_aleatoria_inicial, 
                    preparacao_exibicao, exibicao, sem_exibicao, proximo_exibicao, preparacao_rodada, espera, erro_por_timeout, registra_jogada, 
                    comparacao, proxima_jogada, acerto, erro, proxima_rodada_modo1, proxima_rodada_modo2, aguarda_escrita, 
                    registra_escrita, escrita, escrita_aleatoria);

    signal Eatual, Eprox: t_estado;
begin

    -- memoria de estado
    process (clock,reset)
    begin
        if reset='1' then
            Eatual <= inicial;
        elsif clock'event and clock = '1' then
            Eatual <= Eprox; 
        end if;
    end process;

    -- logica de proximo estado
    Eprox <=
        inicial               when  Eatual=inicial and iniciar='0' else
        aguarda_modo          when  Eatual=inicial and iniciar='1' else
        aguarda_modo          when  Eatual=aguarda_modo and temJogada='0' else
        registra_modo         when  Eatual=aguarda_modo and temJogada='1' else
        aguarda_dificuldade   when  Eatual=registra_modo else
        aguarda_dificuldade   when  Eatual=aguarda_dificuldade and temJogada='0' else
        registra_dificuldade  when  Eatual=aguarda_dificuldade and temJogada='1' else
		  escrita_aleatoria_inicial when Eatual=registra_dificuldade else
        preparacao_exibicao   when  Eatual=escrita_aleatoria_inicial else
		  preparacao_exibicao   when  Eatual=preparacao_exibicao and fimSemExibicao='0' else
        exibicao              when  Eatual=preparacao_exibicao and fimSemExibicao='1' else
        exibicao              when  Eatual=exibicao and fimE='0' else
        sem_exibicao          when  Eatual=exibicao and enderecoIgualRodada='0' and fimE='1' else
		  sem_exibicao          when  Eatual=sem_exibicao and fimSemExibicao='0' else
        proximo_exibicao      when  Eatual=sem_exibicao and fimSemExibicao='1' else
        preparacao_rodada     when  Eatual=exibicao and enderecoIgualRodada='1' and fimE='1' else
        exibicao              when  Eatual=proximo_exibicao else
		  espera                when  Eatual=preparacao_rodada else
        espera                when  Eatual=espera and temJogada='0' and fimT='0' else
        erro_por_timeout      when  Eatual=espera and fimT='1' else
        registra_jogada       when  Eatual=espera and temJogada='1' and fimT='0' else
        comparacao            when  Eatual=registra_jogada else
        erro                  when  Eatual=comparacao and jogadaCorreta='0' else
        acerto                when  Eatual=comparacao and jogadaCorreta='1' and enderecoIgualRodada='1' and fimR='1' else
        proxima_jogada        when  Eatual=comparacao and jogadaCorreta='1' and enderecoIgualRodada='0' and fimR='0' else
        proxima_jogada        when  Eatual=comparacao and jogadaCorreta='1' and enderecoIgualRodada='0' and fimR='1' else
        proxima_rodada_modo1  when  Eatual=comparacao and jogadaCorreta='1' and enderecoIgualRodada='1' and fimR='0' and modo="0001" else
        proxima_rodada_modo2  when  Eatual=comparacao and jogadaCorreta='1' and enderecoIgualRodada='1' and fimR='0' and modo="0010" else
		  espera                when  Eatual=proxima_jogada else
        escrita_aleatoria     when  Eatual=proxima_rodada_modo1 else
        preparacao_exibicao   when  Eatual=escrita_aleatoria else
        aguarda_escrita       when  Eatual=proxima_rodada_modo2 else
        aguarda_escrita       when  Eatual=aguarda_escrita and fimT='0' and temJogada='0' else
        erro_por_timeout      when  Eatual=aguarda_escrita and fimT='1' else
        registra_escrita      when  Eatual=aguarda_escrita and fimT='0' and temJogada='1' else
        escrita               when  Eatual=registra_escrita else
        preparacao_rodada     when  Eatual=escrita else
        inicial               when  Eatual=erro_por_timeout and iniciar='1' else
        erro_por_timeout      when  Eatual=erro_por_timeout and iniciar='0' else
        inicial               when  Eatual=erro and iniciar='1' else
        erro                  when  Eatual=erro and iniciar='0' else 
        inicial               when  Eatual=acerto and iniciar='1' else
        acerto                when  Eatual=acerto and iniciar='0' else
        inicial;

    -- logica de saída (maquina de Moore)
    with Eatual select
        zeraRegJogada <=    '1' when inicial,
                      '0' when others;
    
    with Eatual select
        zeraRegModo <=    '1' when inicial,
                       '0' when others; 

    with Eatual select
        zeraRegDificuldade <=    '1' when inicial,
                       '0' when others; 
    
    with Eatual select
        zeraM <=      '1' when inicial,
                      '1' when preparacao_exibicao,
                      '1' when preparacao_rodada,
                      '0' when others;

   with Eatual select
        zeraE <=      '1' when inicial,
                      '1' when proximo_exibicao,
                      '0' when others;
    
    with Eatual select
        zeraT <=       '1' when inicial,
                       '1' when preparacao_rodada,
                       '1' when proxima_rodada_modo2,
					   '1' when proxima_jogada,
                       '0' when others;
    
    with Eatual select
        zeraR <=      '1' when inicial,
                      '0' when others;
	
	 with Eatual select
        zeraSemExibicao  <=      '1' when inicial,
		                           '1' when escrita_aleatoria,
											'1' when exibicao,
                                 '0' when others;
    
    with Eatual select
        registraRegJogada <= '1' when registra_jogada,
                       '1' when registra_escrita,
                       '0' when others;

    with Eatual select
        registraRegModo <= '1' when registra_modo,
                        '0' when others;

    with Eatual select
        registraRegDificuldade <= '1' when registra_dificuldade,
                        '0' when others;

    with Eatual select
        contaE <=     '1' when exibicao,
                      '0' when others;

    with Eatual select
        contaM <=     '1' when proxima_jogada,
                      '1' when proxima_rodada_modo1,
                      '1' when proxima_rodada_modo2,
                      '1' when proximo_exibicao,
                      '0' when others;
    
    with Eatual select
        contaT <=     '1' when espera,
                      '1' when aguarda_escrita,
                      '0' when others;

    with Eatual select
        contaR <=     '1' when proxima_rodada_modo1,
                      '1' when proxima_rodada_modo2,
                      '0' when others;
							 
	with Eatual select
        contaSemExibicao  <=     '1' when preparacao_exibicao,
                                 '1' when sem_exibicao,
                                 '0' when others;
    
    with Eatual select
        acertou <=    '1' when acerto,
                      '0' when others;

    with Eatual select
        errou <=     '1' when erro,
                     '1' when erro_por_timeout,
                     '0' when others;
    
    with Eatual select
        pronto <=    '1' when erro,
                     '1' when erro_por_timeout,
                     '1' when acerto,
                     '0' when others;
                    
    with Eatual select
        timeout <=   '1' when erro_por_timeout,
                     '0' when others;

     with Eatual select
        selecionaSaida <=   '1' when exibicao,
                            '0' when others;
    
    with Eatual select
        escreve <= '1' when escrita,
                   '0' when others;
    
    with Eatual select
        escreveAleatorio <= '1' when escrita_aleatoria,
                            '0' when others;
    
    with Eatual select
        reiniciaShiftRegister <= '1' when inicial,
                                 '0' when others;

    -- saida de depuracao (db_estado)
    with Eatual select
        db_estado <= "0000" when inicial,     -- 0
                     "0001" when exibicao,    -- 1
                     "0010" when espera,  -- 2
							"0011" when aguarda_modo, -- 3
							"0100" when aguarda_dificuldade, -- 4
                     "0101" when aguarda_escrita,      -- 5
                     "1011" when erro_por_timeout,  -- B
                     "1111" when erro, -- F
                     "1010" when acerto, -- A
                     "1101" when others; -- D


end architecture fsm;
