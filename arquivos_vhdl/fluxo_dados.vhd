library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fluxo_dados is
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
end entity fluxo_dados;

architecture fluxo_dados_arch of fluxo_dados is
    component contador_163 is
        port (
            clock: in  std_logic;
            clr: in  std_logic;
            ld: in  std_logic;
            ent: in  std_logic;
            enp: in  std_logic;
            D: in  std_logic_vector (3 downto 0);
            Q: out std_logic_vector (3 downto 0);
            rco : out std_logic 
        );
    end component;

    component comparador_85 is
    port (
        i_A3   : in  std_logic;
        i_B3   : in  std_logic;
        i_A2   : in  std_logic;
        i_B2   : in  std_logic;
        i_A1   : in  std_logic;
        i_B1   : in  std_logic;
        i_A0   : in  std_logic;
        i_B0   : in  std_logic;
        i_AGTB : in  std_logic;
        i_ALTB : in  std_logic;
        i_AEQB : in  std_logic;
        o_AGTB : out std_logic;
        o_ALTB : out std_logic;
        o_AEQB : out std_logic
    );
  end component;

    component ram_16x4 is
        port (       
            clk: in std_logic;
            endereco: in std_logic_vector(3 downto 0);
            dado_entrada: in std_logic_vector(3 downto 0);
            we: in std_logic;
            ce: in std_logic;
            dado_saida: out std_logic_vector(3 downto 0)
         );
    end component ram_16x4;

    component registrador_n is
    generic (
        constant N: integer := 4
    );
    port (
        clock  : in  std_logic;
        clear  : in  std_logic;
        enable : in  std_logic;
        D      : in  std_logic_vector (N-1 downto 0);
        Q      : out std_logic_vector (N-1 downto 0) 
    );
    end component registrador_n;

    component edge_detector is
        port (
            clock  : in  std_logic;
            reset  : in  std_logic;
            sinal  : in  std_logic;
            pulso  : out std_logic
        );
    end component edge_detector;

    component contador_m is
        generic (
        constant M: integer := 3000 -- modulo do contador
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
    end component contador_m;

    component contador_163_modificado is
        port (
            clock : in  std_logic;
            clr   : in  std_logic;
            ld    : in  std_logic;
            ent   : in  std_logic;
            enp   : in  std_logic;
            D     : in  std_logic_vector (3 downto 0);
            Q     : out std_logic_vector (3 downto 0);
            rco_15   : out std_logic ;
            rco_10   : out std_logic ;
            rco_5   : out std_logic 
       );
    end component contador_163_modificado;

    component contador_m_modificado is
        generic (
            constant M: integer := 5000 -- modulo do contador
        );
        port (
            clock   : in  std_logic;
            zera_as : in  std_logic;
            zera_s  : in  std_logic;
            conta   : in  std_logic;
            Q       : out std_logic_vector(natural(ceil(log2(real(M))))-1 downto 0);
            fim_5000     : out std_logic;
            fim_4000     : out std_logic;
            fim_3000     : out std_logic
        );
    end component contador_m_modificado;

    component shift_register_4bits is
        port (
            clock  : in  std_logic;
            reset  : in  std_logic;
            stp    : in  std_logic;
            Q      : out std_logic_vector (3 downto 0) 
        );
    end component shift_register_4bits;
    
    signal s_not_zeraM: std_logic;
    signal s_not_zeraR: std_logic;
    signal s_not_escreveM: std_logic;
    signal s_not_escreveAleatorio: std_logic;
    signal contagem_M: std_logic_vector(3 downto 0);
    signal contagem_R: std_logic_vector(3 downto 0);
    signal enderecoIgualJogada: std_logic;
    signal s_dado: std_logic_vector(3 downto 0);
    signal s_chaves: std_logic_vector(3 downto 0);
    signal s_chaveacionada: std_logic;
    signal s_tem_jogada: std_logic;
    signal fimT_facil: std_logic;
    signal fimT_medio: std_logic;
    signal fimT_dificil: std_logic;
    signal fimR_facil: std_logic;
    signal fimR_medio: std_logic;
    signal fimR_dificil: std_logic;
    signal s_modo: std_logic_vector(3 downto 0);
    signal s_dificuldade: std_logic_vector(3 downto 0);
    signal s_dado_modo1: std_logic_vector(3 downto 0);
    signal s_dado_modo2: std_logic_vector(3 downto 0);
    signal s_dado_aleatorio: std_logic_vector(3 downto 0);

    begin
        -- clr ativo em baixo
        s_not_zeraM <= not zeraM;  
        s_not_zeraR <= not zeraR;  
        s_not_escreveM <= not escreve;
        s_not_escreveAleatorio <= not escreveAleatorio;

        s_chaveacionada <= chaves(3) or chaves(2) or chaves(1) or chaves(0);
        
        contador_memoria: contador_163
            port map(
                clock => clock,
                clr => s_not_zeraM,
                ld => '1',
                ent => '1',
                enp => contaM,
                D => "0000",
                Q => contagem_M,
                rco => fimM
            );

        memoria_modo1: entity work.ram_16x4 (ram_mif)
            port map(
                clk          => clock,
                endereco     => contagem_M,
                dado_entrada => s_dado_aleatorio,
                we           => s_not_escreveAleatorio,
                ce           => '0',
                dado_saida   => s_dado_modo1
            );
        
        memoria_modo2: entity work.ram_16x4 (ram_mif)
            port map(
                clk          => clock,
                endereco     => contagem_M,
                dado_entrada => s_chaves,
                we           => s_not_escreveM,
                ce           => '0',
                dado_saida   => s_dado_modo2
            );
        
        registrador_jogada: registrador_n
            generic map(N => 4)
                port map (
                    clock => clock,
                    clear => zeraRegJogada,
                    enable => registraRegJogada,
                    D => chaves,
                    Q => s_chaves
                );

        registrador_modo: registrador_n
            generic map(N => 4)
                port map (
                    clock => clock,
                    clear => zeraRegModo,
                    enable => registraRegModo,
                    D => chaves,
                    Q => s_modo
                );

        registrador_dificuldade: registrador_n
            generic map(N => 4)
                port map (
                    clock => clock,
                    clear => zeraRegDificuldade,
                    enable => registraRegDificuldade,
                    D => chaves,
                    Q => s_dificuldade
                );

        comparador_endereco: comparador_85
            port map(
                i_A3   => contagem_R(3),
                i_B3   => contagem_M(3),
                i_A2   => contagem_R(2),
                i_B2   => contagem_M(2),
                i_A1   => contagem_R(1),
                i_B1   => contagem_M(1),
                i_A0   => contagem_R(0),
                i_B0   => contagem_M(0),
                i_AGTB => '0',
                i_ALTB => '0',
                i_AEQB => '1',
                o_AGTB => open, -- saidas nao usadas
                o_ALTB => open,
                o_AEQB => enderecoIgualRodada
            );

        comparador_jogada: comparador_85
            port map(
                i_A3   => s_dado(3),
                i_B3   => s_chaves(3),
                i_A2   => s_dado(2),
                i_B2   => s_chaves(2),
                i_A1   => s_dado(1),
                i_B1   => s_chaves(1),
                i_A0   => s_dado(0),
                i_B0   => s_chaves(0),
                i_AGTB => '0',
                i_ALTB => '0',
                i_AEQB => '1',
                o_AGTB => open, -- saidas nao usadas
                o_ALTB => open,
                o_AEQB => jogadaCorreta
            );

        deteccao_jogada: edge_detector
            port map(
                clock => clock,
                reset => '0',
                sinal => s_chaveacionada,
                pulso => s_tem_jogada
            );

        contador_exibicao: contador_m
            generic map(M => 1000)
                port map(
                    clock => clock,
                    zera_as => '0',
                    zera_s => zeraE,
                    conta => contaE,
                    Q => open, -- saida nao utilizada
                    fim => fimE,
                    meio => open -- saida nao utilizada
                );
					 
			contador_sem_exibicao: contador_m
            generic map(M => 200)
                port map(
                    clock => clock,
                    zera_as => '0',
                    zera_s => zeraSemExibicao,
                    conta => contaSemExibicao,
                    Q => open, -- saida nao utilizada
                    fim => fimSemExibicao,
                    meio => open -- saida nao utilizada
                );
        
        contador_tempo: contador_m_modificado
            generic map(M => 5000)
                port map (
                    clock   => clock,
                    zera_as => '0',
                    zera_s => zeraT,
                    conta => contaT,
                    Q => open,
                    fim_5000 => fimT_facil,
                    fim_4000 => fimT_medio,
                    fim_3000 => fimT_dificil
                );
			
        contador_rodada: contador_163_modificado
            port map(
                clock => clock,
                clr => s_not_zeraR,
                ld => '1',
                ent => '1',
                enp => contaR,
                D => "0000",
                Q => contagem_R,
                rco_15 => fimR_dificil, 
                rco_10 => fimR_medio,
                rco_5 => fimR_facil 
            );
            
        -- shift register para escrita aleatoria do modo 1
        shift_register: shift_register_4bits
            port map (
                clock  => clock_shiftreg,
                reset  => reiniciaShiftRegister,
                stp    => escreveAleatorio,
                Q      => s_dado_aleatorio
            );

        -- mux seleciona o timeout por dificuldade
        with s_dificuldade select
            fimT <=
            fimT_facil when "0001",
            fimT_medio when "0010",
            fimT_dificil when "0100",
            '0' when others;

        -- mux seleciona o numero de rodada por dificuldade
        with s_dificuldade select
            fimR <=
            fimR_facil when "0001",
            fimR_medio when "0010",
            fimR_dificil when "0100",
            '0' when others;

	    -- mux seleciona o numero de rodada por dificuldade
        with s_modo select
            s_dado <=
            s_dado_modo1 when "0001",
            s_dado_modo2 when "0010",
            "0000" when others;
        
    modo <= s_modo;
    db_jogada <= contagem_M;
    db_rodada <= contagem_R;
    db_chaves <= s_chaves;
    db_dificuldade <= s_dificuldade;
	 db_memoria <= s_dado;
    tem_jogada <= s_tem_jogada;

end fluxo_dados_arch;