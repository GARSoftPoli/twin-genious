library ieee;
use ieee.std_logic_1164.all;

entity jogo_desafio_memoria is
    port(
        clock: in std_logic;
        clock_fpga: in std_logic;
        botoes: in std_logic_vector(3 downto 0);
        leds: out std_logic_vector(2 downto 0);
        pronto: out std_logic;
        ganhou: out std_logic;
        perdeu: out std_logic;
        -- Saidas de depuracao
        db_modo: out std_logic_vector(6 downto 0);
		db_jogada: out std_logic_vector(6 downto 0);
        db_timeout: out std_logic;
        db_rodada: out std_logic_vector(6 downto 0); -- qual o numero da rodada atual
        db_chaves: out std_logic_vector(6 downto 0); -- jogada do usuario 
        db_tem_jogada: out std_logic;      
        db_dificuldade: out std_logic_vector(6 downto 0); -- dado atual da posição de memória
        db_estado : out std_logic_vector(6 downto 0);
		saida_som: out std_logic
    );
end jogo_desafio_memoria;

architecture jogo of jogo_desafio_memoria is

    component fluxo_dados is
        port(
        clock: in std_logic;
        clock_shiftreg : in std_logic;
        zeraR: in std_logic;
        zeraM: in std_logic;
        zeraT: in std_logic;
        zeraE: in std_logic;
		zeraSemExibicao: in std_logic;
        contaM: in std_logic;
        contaR: in std_logic;
        contaT: in std_logic;
        contaE: in std_logic;
		contaSemExibicao: in std_logic;
        reiniciaShiftRegister: in std_logic;
        zeraRegJogada: in std_logic;
        zeraRegModo: in std_logic;
        zeraRegDificuldade: in std_logic;
        registraRegJogada: in std_logic;
        registraRegModo: in std_logic;
        registraRegDificuldade: in std_logic;
        escreve: in std_logic;
        escreveAleatorio: in std_logic;
        chaves: in std_logic_vector(3 downto 0);
        enderecoIgualRodada: out std_logic;
        jogadaCorreta: out std_logic;
        fimR: out std_logic;
        fimM: out std_logic;
        fimT: out std_logic;
        fimE: out std_logic;
		  fimSemExibicao: out std_logic;
        tem_jogada: out std_logic;
		  modo: out std_logic_vector(3 downto 0);
        -- Sinais de depuração
		  db_memoria: out std_logic_vector(3 downto 0);
        db_rodada: out std_logic_vector(3 downto 0); -- qual o numero da rodada atual
        db_chaves: out std_logic_vector(3 downto 0); -- jogada do usuario    
        db_dificuldade: out std_logic_vector(3 downto 0); -- dado atual da posição de memória
		  db_jogada: out std_logic_vector(3 downto 0)
    );
    end component fluxo_dados;

    component unidade_controle is 
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
    end component unidade_controle;
    

    component mux_2to1 is
        port (
          selector : in std_logic;
          a: in std_logic_vector(3 downto 0); 
          b: in std_logic_vector(3 downto 0);
          y: out std_logic_vector(3 downto 0)
          );
    end component mux_2to1;

    component hexa7seg is
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component hexa7seg;

    component controlador_som is
        port (
            clock   : in  std_logic;
            acerto : in  std_logic;
            erro  : in  std_logic;
            leds   : in  std_logic_vector(3 downto 0);
            som    : out std_logic
        );
    end component controlador_som;

    signal zeraR: std_logic;
    signal zeraM: std_logic;
    signal zeraT: std_logic;
    signal zeraE: std_logic;
	 signal zeraSemExibicao: std_logic;
    
    signal fimR: std_logic;
    signal fimM: std_logic;
    signal fimT: std_logic;
    signal fimE: std_logic;
	 signal fimSemExibicao: std_logic;

    signal contaR: std_logic;
    signal contaM: std_logic;
    signal contaT: std_logic;
    signal contaE: std_logic;
	 signal contaSemExibicao: std_logic;

    signal zeraRegJogada: std_logic;
    signal zeraRegModo: std_logic;
    signal zeraRegDificuldade: std_logic;

    signal registraRegJogada: std_logic;
    signal registraRegModo: std_logic;
    signal registraRegDificuldade: std_logic;
	
		
	 signal reset: std_logic;
	 signal iniciar: std_logic;
    signal s_dificuldade: std_logic_vector(3 downto 0);
    signal s_chaves: std_logic_vector(3 downto 0);
    signal s_rodada: std_logic_vector(3 downto 0);
    signal s_estado: std_logic_vector(3 downto 0);
	 signal s_jogada: std_logic_vector(3 downto 0);
	 signal s_memoria: std_logic_vector(3 downto 0);
    signal s_leds: std_logic_vector(3 downto 0);
    signal s_enderecoIgualRodada: std_logic;
    signal s_jogadaCorreta: std_logic;
    signal s_ganhou: std_logic;
    signal s_perdeu: std_logic;
    signal s_selecionaSaida: std_logic;
    signal escreve: std_logic;
    signal s_modo: std_logic_vector(3 downto 0);
    signal s_escreveAleatorio: std_logic;
    signal s_reiniciaShiftRegister: std_logic;
	 signal s_temJogada_input_UC : std_logic;
	 signal s_tem_jogada_output_FD: std_logic;

    begin

        fd: fluxo_dados
        port map(
            clock => clock,
            clock_shiftreg => clock_fpga,
            zeraR => zeraR,
            zeraM => zeraM,
            zeraT => zeraT,
            zeraE => zeraE,
				zeraSemExibicao => zeraSemExibicao,
            contaM => contaM,
            contaR => contaR,
            contaT => contaT,
            contaE => contaE,
				contaSemExibicao => contaSemExibicao,
            reiniciaShiftRegister => s_reiniciaShiftRegister,
            zeraRegJogada => zeraRegJogada,
            zeraRegModo => zeraRegModo,
            zeraRegDificuldade => zeraRegDificuldade,
            registraRegJogada => registraRegJogada,
            registraRegModo => registraRegModo,
            registraRegDificuldade => registraRegDificuldade,
            escreve => escreve,
            escreveAleatorio => s_escreveAleatorio,
            chaves => botoes,
            enderecoIgualRodada => s_enderecoIgualRodada,
            jogadaCorreta => s_jogadaCorreta,
            fimR => fimR,
            fimM => fimM,
            fimT => fimT,
            fimE => fimE,
				fimSemExibicao => fimSemExibicao,
            tem_jogada => s_tem_jogada_output_FD,
            modo => s_modo,
            db_rodada => s_rodada,
            db_chaves => s_chaves,
            db_dificuldade => s_dificuldade,
			db_memoria => s_memoria,
			db_jogada => s_jogada
        );

        uc: unidade_controle
        port map(
            clock => clock,
            reset => reset,
            iniciar => iniciar,
            enderecoIgualRodada => s_enderecoIgualRodada,
            jogadaCorreta => s_jogadaCorreta,
            fimR => fimR,
            fimM => fimM,
            fimT => fimT,
            fimE => fimE,
				fimSemExibicao => fimSemExibicao,
            modo => s_modo,
            temJogada => s_temJogada_input_UC,
            zeraR => zeraR,
            zeraM => zeraM,
            zeraT => zeraT,
            zeraE => zeraE,
				zeraSemExibicao => zeraSemExibicao,
            zeraRegJogada => zeraRegJogada,
            zeraRegModo => zeraRegModo,
            zeraRegDificuldade => zeraRegDificuldade,
            contaM => contaM,
            contaR => contaR,
            contaT => contaT,
            contaE => contaE,
				contaSemExibicao => contaSemExibicao,
            reiniciaShiftRegister => s_reiniciaShiftRegister,
            registraRegJogada => registraRegJogada,
            registraRegModo => registraRegModo,
            registraRegDificuldade => registraRegDificuldade,
            escreve => escreve,
            escreveAleatorio => s_escreveAleatorio,
            acertou => s_ganhou,
            errou => s_perdeu,
            pronto => pronto,
            timeout => db_timeout,
            selecionaSaida => s_selecionaSaida,
            db_estado => s_estado
        );

    controle_som: controlador_som
        port map(
            clock => clock_fpga,
            acerto => s_ganhou,
            erro => s_perdeu,
            leds => s_leds,
            som => saida_som
        );

        saida_estado: hexa7seg
        port map(
            hexa => s_estado,
            sseg => db_estado
        );

    saida_rodada: hexa7seg
        port map(
            hexa => s_rodada,
            sseg => db_rodada
        );
    
    saida_chaves: hexa7seg
        port map(
            hexa => s_chaves,
            sseg => db_chaves
        );
    
    saida_dificuldade: hexa7seg
        port map(
            hexa => s_dificuldade,
            sseg => db_dificuldade
        );   
        
    saida_modo: hexa7seg
        port map(
            hexa => s_modo,
            sseg => db_modo
        );
		 
	saida_jogada: hexa7seg
        port map(
            hexa => s_jogada,
            sseg => db_jogada
        ); 

    mux: mux_2to1
    port map(
        selector => s_selecionaSaida,
        a => botoes,
        b => s_memoria,
        y => s_leds
    );

    with s_leds select
         leds <= "001" when "0001",
                "010" when "0010",
                "100" when "0100",
                "111" when "1000",
                "000" when others;
					 
	 with botoes select
			iniciar <= '1' when "1010",
						  '0' when others;
						  
	 with botoes select
			reset <=   '1' when "1011",
						  '0' when others;
	 
	 s_temJogada_input_UC <= s_tem_jogada_output_FD and not iniciar and not reset;
    db_tem_jogada <= s_temJogada_input_UC;
    ganhou <= s_ganhou;
    perdeu <= s_perdeu;

end jogo;