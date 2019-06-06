library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
entity TOP is
Port ( CLK : in STD_LOGIC;
RST : in STD_LOGIC;
jump : in STD_LOGIC;
rstemp : in STD_LOGIC;
red_out : out std_logic;
green_out : out std_logic;
blue_out : out std_logic;
hs_out : out std_logic;
vs_out : out std_logic
);
end TOP;
architecture Behavioral of TOP is


-- CONTROLE DE CLOCK E TELA

signal clk50, clk25 : STD_LOGIC;
signal horizontal_counter : std_logic_vector (9 downto 0);
signal vertical_counter : std_logic_vector (9 downto 0);
signal controlcano3h, controlcano3hf, controlcano2h, controlcano2hf, controlcano1h, controlcano1hf, controlcano2vf, controlcano1vf, controlcano3vf : std_logic_vector (9 downto 0);
signal controlv : std_logic_vector (9 downto 0);
signal controlvf : std_logic_vector (9 downto 0);
signal count : integer range 0 to 200001;
signal countcano : std_logic_vector (9 downto 0);
signal countjmp : integer range 0 to 50000001;
signal countempo : integer range 0 to 150000001;
signal jumpt,jumphold,colisao : STD_LOGIC;



begin



process (clk, rst)

begin
	if RST = '1' then
		
	elsif CLK'EVENT and CLK = '1' then
		-- CLOCK PARA CONTROLE DA TELA
		if (clk50 = '0') then
			clk50 <= '1';
			
		else
			clk50 <= '0';
		end if;
						
	end if;
end process;

-- DIMINUI CLOCK PARA EXIBIÇÃO DA TELA
process (clk50)
begin
	if clk50'event and clk50='1' then
		if (clk25 = '0') then
			clk25 <= '1';
			count <= count+1;			
			countcano <= countcano+"0000000001";
		else
			clk25 <= '0';
		end if;
		if count > 200000 then
			count <= 0;
			countcano <= countcano+"0000001000";			
		end if;
		if countcano > 381 then
			countcano <=  "0000101000";								
		end if;
	end if;
end process;

-- CONTROLE DA EXIBIÇÃO NA TELA
process (clk25)
variable printa: integer range 0 to 10;
begin
	if clk25'event and clk25 = '1' then
	-- TAMANHO DO JOGO: 520x780 
		if (horizontal_counter >= "0010001100" ) -- 140
		and (horizontal_counter < "1100001100" ) -- 780
		and (vertical_counter >=  "0000101000" ) -- 40
		and (vertical_counter <   "1000001000" ) -- 520
		then
		if colisao = '0' then
			printa := 3;
		elsif colisao = '1' then
			printa := 2;
		end if;
		
		
		if rstemp = '1' then --incialização temporária do jogo
			controlcano1h <=  "1100001100";
			controlcano1hf <= "1101110000";
			controlcano2h <=  "1100001100";
			controlcano2hf <= "1101110000";
			controlcano3h <=  "1100001100";
			controlcano3hf <= "1101110000";
			controlv <=  "0011111010";
			controlvf <= "0100100010";
			controlcano1vf <=  "0000000000";
			controlcano2vf <=  "0000000000";
			controlcano3vf <=  "0000000000";
			colisao <= '0';
			countempo <= 0;		else 
			countempo <= countempo+1;
			if countempo > 85000000 then
				countempo <= 0;
			end if;
		
		
		
	if controlvf >= 520 then -- algoritmo de colisão com canos // baseado nos vetores dos obstaculos
			colisao <= '1';
		elsif controlv <= controlcano1vf and ((controlcano1h <= 240 and controlcano1h >= 140 ) or (controlcano1hf <= 240 and controlcano1hf >= 200)) then
			colisao <= '1';
		elsif controlvf >= (controlcano1vf +140) and ((controlcano1h <= 240 and controlcano1h >= 140) or (controlcano1hf <= 240 and controlcano1hf >= 200)) then
			colisao <= '1';
		elsif controlv <= controlcano2vf and ((controlcano2h <= 240 and controlcano2h >= 140) or (controlcano2hf <= 240 and controlcano2hf >= 200)) then
			colisao <= '1';
		elsif controlvf >= (controlcano2vf +140) and (( controlcano2h <= 240 and controlcano2h >= 140) or (controlcano2hf <= 240 and controlcano2hf >= 200)) then
			colisao <= '1';
		elsif controlv <= controlcano3vf and ((controlcano3h <= 240 and controlcano3h >= 140 ) or (controlcano3hf <= 240 and controlcano3hf >= 200)) then
			colisao <= '1';
		elsif controlvf >= (controlcano3vf +140) and ((controlcano3h <= 240 and controlcano3h >= 140) or (controlcano3hf <= 240 and controlcano3hf >= 200)) then
			colisao <= '1';
		end if;
		end if;
		if colisao = '0' then --inicia o jogo se não colidir em nada
	
			if countempo = 25000000 and controlcano1vf = "0000000000" then -- instancia de obstaculo 1 baseado em tempo
				controlcano1vf <= countcano;
				controlcano1h <=  "1100001100";
				controlcano1hf <= "1101110000";
			end if;
			
			if countempo = 50000000 and controlcano2vf = "0000000000" then  -- instancia de obstaculo 2 baseado em tempo
				controlcano2vf <= countcano;
				controlcano2h <=  "1100001100";
				controlcano2hf <= "1101110000";
			end if;
			
			if countempo = 85000000 and controlcano3vf = "0000000000" then  -- instancia de obstaculo 3 baseado em tempo
				controlcano3vf <= countcano;
				controlcano3h <=  "1100001100";
				controlcano3hf <= "1101110000";
			end if;
			
			if vertical_counter >= 40 AND vertical_counter < controlcano1vf then --parte de cima do obstaculo 1
				if horizontal_counter >= controlcano1h AND horizontal_counter < controlcano1hf then
					printa := 1;
				end if;	
			end if;
				
			if vertical_counter >= (controlcano1vf + 140 ) AND vertical_counter < 520 then--parte de baixo do obstaculo 1
				if horizontal_counter >= controlcano1h AND horizontal_counter < controlcano1hf then
					printa := 1;
				end if;	
			end if;
			
			if vertical_counter >= 40 AND vertical_counter < controlcano2vf then--parte de cima do obstaculo 2
				if horizontal_counter >= controlcano2h AND horizontal_counter < controlcano2hf then
					printa := 1;
				end if;	
			end if;
				
			if vertical_counter >= (controlcano2vf + 140 ) AND vertical_counter < 520 then --parte de baixo do obstaculo 2
				if horizontal_counter >= controlcano2h AND horizontal_counter < controlcano2hf then
					printa := 1;
				end if;	
			end if;
			if vertical_counter >= 40 AND vertical_counter < controlcano3vf then --parte de cima do obstaculo 3
				if horizontal_counter >= controlcano3h AND horizontal_counter < controlcano3hf then
					printa := 1;
				end if;	
			end if;
				
			if vertical_counter >= (controlcano3vf + 140 ) AND vertical_counter < 520 then --parte de baixo do obstaculo 3
				if horizontal_counter >= controlcano3h AND horizontal_counter < controlcano3hf then
					printa := 1;
				end if;	
			end if;
			
			if vertical_counter >= controlv AND vertical_counter < controlvf then -- quadrado player
				if horizontal_counter >= 200 AND horizontal_counter < 240 then
					printa := 0;
				end if;	
			end if;
			

		if count = 200000 then --taxa de atualização da movimentação dos objetos
			if controlvf < 520 then --limite inferior da tela
				controlv <= controlv +   "0000000100";-- movimentação de descida do player
				controlvf <= controlvf + "0000000100";-- movimentação de descida do player
			end if;
			
			if controlcano1hf > 139 and controlcano1vf > 0 then
				controlcano1h <= controlcano1h -   "0000000010";--obstaculo 1 movendo-se da esquerda pra direita
				controlcano1hf <= controlcano1hf -  "0000000010";--obstaculo 1 movendo-se da esquerda pra direita
			elsif controlcano1hf < 140 then-- reinicialização do obstaculo quando chega ao final da tela
				controlcano1vf <=  "0000000000"; --reinicialização da altura semi randomica do obstaculo
				countempo <= 15000000; -- reinicialização do tempo que define a distancia dos obstaculos
			else 
				controlcano1vf <=  "0000000000"; --controle de inicialização
			end if;
			
			if controlcano2hf > 139 and controlcano2vf > 0 then
				controlcano2h <= controlcano2h -   "0000000010";--obstaculo 2 movendo-se da esquerda pra direita
				controlcano2hf <= controlcano2hf -  "0000000010";--obstaculo 2 movendo-se da esquerda pra direita			
			elsif controlcano2hf < 140 then-- reinicialização do obstaculo quando chega ao final da tela
				controlcano2vf <=  "0000000000";--reinicialização da altura semi randomica do obstaculo
				countempo <= 50000000;-- reinicialização do tempo que define a distancia dos obstaculos
			else 
				controlcano2vf <=  "0000000000";--controle de inicialização
			end if;	
			
			if controlcano3hf > 139 and controlcano3vf > 0 then
				controlcano3h <= controlcano3h -   "0000000010";--obstaculo 3 movendo-se da esquerda pra direita
				controlcano3hf <= controlcano3hf -  "0000000010";--obstaculo 3 movendo-se da esquerda pra direita
			elsif controlcano3hf < 140 then-- reinicialização do obstaculo quando chega ao final da tela
				controlcano3vf <=  "0000000000";--reinicialização da altura semi randomica do obstaculo
				countempo <= 85000000;-- reinicialização do tempo que define a distancia dos obstaculos
			else 
				controlcano3vf <=  "0000000000";--controle de inicialização
			end if;
			
			if jumpt = '1' then-- função de pulo
				countjmp <= countjmp+1; --contador do tempo que o player permanece subindo na tela
				if countjmp < 12 and controlv > 40 then--subindo//limite superior da tela
					controlv <=  controlv -   "0000000101";--função que faz o player subir
					controlvf <= controlvf -  "0000000101";--função que faz o player subir
				else 
					if jumphold = '0' then--controle de botão para que não o mantenha subindo com o botão segurado
						jumpt <= '0';
						countjmp <= 0;
						end if;
				end if;
		
		end if;
		end if;
		if jump = '1' then --função de controle de tempo de subida do player ao apertar botão
			jumpt <= '1'; --variavel de controle de tempo
			jumphold <= '1';--variavel de controle de sessão de click
		else 
			jumphold <= '0';
		end if;
		
		end if; -- termina colisor
			
		
		
		
-- ESCOLHE COR QUE APARECERÁ NA TELA -> 0 PARA amarelo (player)
--- 1 PARA verde (OBSTÁCULOS), 2 PARA preto (FIM DE JOVO) e 3 para azuç (tela de fundo do jogo)
			if printa= 0 then --cor do player
				red_out <= '1';
				green_out <= '1';
				blue_out <= '0';
			elsif printa= 1 then -- cor do tubo
				red_out <= '0';
				green_out <= '1';
				blue_out <= '0';
			elsif printa= 2 then -- cor do tubo
				red_out <= '0';
				green_out <= '0';
				blue_out <= '0';
			else
				red_out <= '0'; --cor do fundo
				green_out <= '0';
				blue_out <= '1';
			end if;
		else
-- ESCOLHE COR PRETA PARA RESTO DA TELA
			red_out <= '0';
			green_out <= '0';
			blue_out <= '0';
		end if;
		
	if (horizontal_counter > "0000000000" )
	and (horizontal_counter < "0001100001" ) -- 96+1
	then
		hs_out <= '0';
	else
		hs_out <= '1';
	end if;
	if (vertical_counter > "0000000000" )
	and (vertical_counter < "0000000011" ) -- 2+1
	then
		vs_out <= '0';
	else
		vs_out <= '1';
	end if;
	horizontal_counter <= horizontal_counter+"0000000001";
	if (horizontal_counter="1100100000") then
		vertical_counter <= vertical_counter+"0000000001";
		horizontal_counter <= "0000000000";
	end if;
	if (vertical_counter="1000001001") then
		vertical_counter <= "0000000000";
	end if;
end if;
end process;
end Behavioral;
