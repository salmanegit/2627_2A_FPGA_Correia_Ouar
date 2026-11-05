# 2627_2A_FPGA_Correia_Ouar
TP FPGA 2A

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity TP1_2627_OUAR_CORREIA is
    port (
        pushl : in std_logic;
        led0 : out std_logic
    );
end entity TP1_2627_OUAR_CORREIA;

architecture rtl of TP1_2627_OUAR_CORREIA is
begin
    led0 <= pushl;
end architecture rtl;
```


Avec RTL Viewer, on obtient le schéma suivant:

Voici le comportement de la LED lorsque l'on appuie sur le bouton
<img width="662" height="107" alt="image" src="https://github.com/user-attachments/assets/d03b3f1f-c38b-4a1f-b1d1-0b4c9d9b95b2" />




Ici, la LED reste allumée en continu et s'éteint lorsque l'on appuie sur l'encodeur.

### Inversion du comportement de la LED:
Nous avons ajouté l’opérateur logique “not” dans le code initial juste avant le push afin d'inverser l’allumage de la LED
```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity TP1_2627_OUAR_CORREIA is
    port (
        pushl : in std_logic;
        led0 : out std_logic
    );
end entity TP1_2627_OUAR_CORREIA;

architecture rtl of TP1_2627_OUAR_CORREIA is
begin
    led0 <= not pushl;
end architecture rtl;

```

On obtient ensuite le schéma suivant:
<img width="825" height="191" alt="image" src="https://github.com/user-attachments/assets/e5150f8b-067a-47ad-ba7d-09d4d7fe56cb" />

Ici, la LED est éteinte continuellement et s'allume lorsque l'on appuie sur l'encodeur.










## Faire clignoter une LED
Q1 ) Sur la carte DE10-Nano, l'horloge FPGA_CLK1_50 est connectée sur la broche PIN_V11
Configuration des pins avec pin assignements :  
<img width="1060" height="208" alt="image" src="https://github.com/user-attachments/assets/a68e81b4-07cc-43f5-8002-bbfa61ce56bc" />  

D'après le tableau suivant, la fréquence est de 50MHz:
<img width="1714" height="428" alt="image" src="https://github.com/user-attachments/assets/ebac7352-8f6a-4ef2-bae0-0600c2242cb8" />

Q3) Ci-dessous le code VHDL permettant de faire clignoter une LED:
```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity led_blink is
    port (
        i_clk : in std_logic;
        i_rst_n : in std_logic;
        o_led : out std_logic
    );
end entity led_blink;

architecture rtl of led_blink is
    signal r_led : std_logic := '0';
begin
    process(i_clk, i_rst_n)
    begin
        if (i_rst_n = '0') then
            r_led <= '0';
        elsif (rising_edge(i_clk)) then
            r_led <= not r_led;
        end if;
    end process;
    o_led <= r_led;
end architecture rtl;
```



Schéma correspondant à ce code VHDL:
<br>
<br>
<img width="721" height="495" alt="image" src="https://github.com/user-attachments/assets/7a5c8a01-7062-45bb-b089-7f77054ece83" />


<br>
<br>
<br>
<br>
<br>
<br>

Schéma proposé par quartus correspondant à ce code VHDL avec RTL Viewer:
<img width="821" height="168" alt="image" src="https://github.com/user-attachments/assets/cddf6268-401c-404b-b354-dc4a79e85140" />




Q6 ) Explication du code : 

Premier process: 
```vhdl
architecture rtl of TP1_2627_OUAR_CORREIA is
    signal r_led : std_logic := '0';
    signal r_led_enable : std_logic := '0';
begin
    process(i_clk, i_rst_n)
        variable counter : natural range 0 to 5000000 := 0;
    begin
        if (i_rst_n = '0') then
            counter := 0;
            r_led_enable <= '0';
        elsif (rising_edge(i_clk)) then
            if (counter = 5000000) then
                counter := 0;
                r_led_enable <= '1';
            else
                counter := counter + 1;
                r_led_enable <= '0';
            end if;
        end if;
    end process;
```



Le premier process sert à ralentir la fréquence de fonctionnement. On ajoute un
compteur qui augmente de 1 à chaque front montant de l’horloge.

Deuxième process : 
```vhdl
 process(i_clk, i_rst_n)
    begin
        if (i_rst_n = '0') then
            r_led <= '0';
        elsif (rising_edge(i_clk)) then
            if (r_led_enable = '1') then
                r_led <= not r_led;
            end if;
        end if;
    end process;
    
    o_led <= r_led;
end architecture rtl;
```

Q7) 
Ci-dessous le code VHDL permettant de faire clignoter une LED:

<img width="787" height="432" alt="image" src="https://github.com/user-attachments/assets/928ba042-e130-49e2-aa36-2c08665210d1" />



<br>
<br>
<br>

Q8)
Schéma proposé par quartus correspondant à ce code VHDL avec RTL Viewer:
<img width="2238" height="570" alt="image" src="https://github.com/user-attachments/assets/34be2136-b762-466a-9a08-681ec0ae7449" />
<br>
<br>
### Comparaison des deux schémas
Les deux schémas représentent strictement le même circuit : une bascule D avec réinjection inversée. La seule différence est visuelle : le schéma manuel dessine une porte NON explicite sur la boucle de retour, tandis que Quartus la simplifie par une simple bulle d'inversion placée directement sur l'entrée D du registre

<br>
<br>
<br>

Q11)
_n indique que le signal de reset est actif lorsqu'il est à l'état bas. Ainsi, le circuit se réinitialise lorsque le bouton est enfoncé (mettant la ligne à 0V), et fonctionne normalement lorsque la ligne est maintenue à l'état haut.

<br>
<br>
<br>

Chenillard : 

-- 1. 
o_leds : out std_logic_vector(9 downto 0); -- Déclaration d'un vecteur de 10 bits pour adresser les 10 LEDs de la carte d'extension.

-- 2.
signal r_leds : std_logic_vector(9 downto 0) := "0000000001"; -- Création du registre interne sur 10 bits, initialisé avec le premier bit à '1' pour amorcer le chenillard.

-- 3.
r_leds <= "0000000001"; -- Réinitialisation du registre à son état de départ en cas d'appui sur le bouton KEY0.

-- 4. 
r_leds <= r_leds(8 downto 0) & r_leds(9); -- Décalage circulaire par concaténation (&) : les 9 bits de droite sont décalés à gauche, et le bit sortant (9) est réinjecté à l'index 0.

-- 5.
o_leds <= r_leds; -- Connexion des valeurs du registre interne aux sorties physiques.


Nous avons affecté pour chaque led une pin dans Pin Planner à l’aide de l’annexe
du TP :
<img width="1900" height="390" alt="image" src="https://github.com/user-attachments/assets/5ca6e469-9541-4e0d-9397-399dbcc06a01" />


<br>
<br>
<br>
<br>
<br>
<br>

# 2627_2A_FPGA_Correia_Ouar_TP2
## TP FPGA 2A - 2ème séance

<br>

2. Le signal de A est en avance d'une période d'horloge, ainsi au moment où A=1 et Aclk=0, alors il y a un front montant et inversement, au moment où A=0 et Aclk=1 alors il y à un front descendant. De même pour le signal B.


3.
```vhdl
 process(i_clk_50, i_rst_n)
    begin
        if i_rst_n = '0' then
            r_A_prev  <= '0';
            r_B_prev  <= '0';
            r_counter <= (others => '0');
            
        elsif rising_edge(i_clk_50) then
            r_A_prev <= i_left_ch_a; 
            r_B_prev <= i_left_ch_b;
            
            -- Detection signal A
            if (i_left_ch_a = '1' and r_A_prev = '0' and i_left_ch_b = '0') then
                r_counter <= r_counter + 1;
                
            -- Detection signal B
            elsif (i_left_ch_b = '1' and r_B_prev = '0' and i_left_ch_a = '0') then
                r_counter <= r_counter - 1;
            end if;
        end if;
    end process;
```

<img width="2790" height="882" alt="image" src="https://github.com/user-attachments/assets/256cf05c-5246-4626-867d-1f661f7d6baa" />





4. Simulation sur Quartus:



5. Test sur la carte :

Ce programme récupère les mouvements physiques de l'encodeur rotatif pour incrémenter ou décrémenter un compteur. Il permet un affichage binaire sur les LEDs de la carte ainsi qu'un filtre anti-rebond.

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity telecran is
    port (
        -- FPGA
        i_clk_50: in std_logic;

        -- HDMI
        io_hdmi_i2c_scl       : inout std_logic;
        io_hdmi_i2c_sda       : inout std_logic;
        o_hdmi_tx_clk         : out std_logic;
        o_hdmi_tx_d           : out std_logic_vector(23 downto 0);
        o_hdmi_tx_de          : out std_logic;
        o_hdmi_tx_hs          : out std_logic;
        i_hdmi_tx_int         : in std_logic;
        o_hdmi_tx_vs          : out std_logic;

        -- KEYs
        i_rst_n : in std_logic;
          
        -- LEDs
        o_leds : out std_logic_vector(9 downto 0);
        o_de10_leds : out std_logic_vector(7 downto 0);

        -- Coder
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

    constant h_res : natural := 720;
    constant v_res : natural := 480;

    signal s_clk_27 : std_logic;
    signal s_rst_n : std_logic; 
    
    -- Signaux pour l'encodeur
    signal r_A_prev : std_logic := '0';
    signal r_B_prev : std_logic := '0';
    signal r_counter : unsigned(9 downto 0) := (others => '0');
    
    -- NOUVEAU : Compteur et signal pour l'anti-rebond (échantillonnage à 1 ms)
    signal r_debounce_cnt : natural range 0 to 50000 := 0;
    signal s_sample_en : std_logic;
    
begin
    o_leds <= std_logic_vector(r_counter);
    o_de10_leds <= (others => '0');
```

Affichage en binaire : La valeur décimale du compteur (r_counter) est directement reliée aux 10 LEDs physiques de la carte. La fonction std_logic_vector() convertit ce nombre en un vecteur de 10 bits (0 ou 1)

```vhdl    
    -- Génération d'une impulsion d'autorisation (enable) toutes les 1 ms
    process(i_clk_50, i_rst_n)
    begin
        if i_rst_n = '0' then
            r_debounce_cnt <= 0;
        elsif rising_edge(i_clk_50) then
            if r_debounce_cnt = 50000 then
                r_debounce_cnt <= 0;
            else
                r_debounce_cnt <= r_debounce_cnt + 1;
            end if;
        end if;
    end process;

    s_sample_en <= '1' when r_debounce_cnt = 50000 else '0';
```

Génération du délai (Timer) : L'horloge du FPGA tournant à 50 MHz, le compteur r_debounce_cnt est configuré pour s'incrémenter jusqu'à 50 000. Cela correspond exactement à un délai de 1 milliseconde. À la fin de ce cycle, une impulsion d'activation (s_sample_en) est envoyée.
```vhdl    
    -- Process de l'encodeur avec anti-rebond et conditions complètes
    process(i_clk_50, i_rst_n)
    begin
        if i_rst_n = '0' then
            r_A_prev  <= '0';
            r_B_prev  <= '0';
            r_counter <= (others => '0');
```

Filtre anti-rebond (Debounce) : Les contacts métalliques de la molette créent des parasites électriques lors de la rotation. Grâce à la condition if s_sample_en = '1', le FPGA ne lit les broches de l'encodeur qu'une seule fois par milliseconde. Ce ralentissement laisse le temps aux contacts de se stabiliser et évite que le compteur ne s'emballe.

```vhdl    
        elsif rising_edge(i_clk_50) then
            -- On lit l'encodeur UNIQUEMENT toutes les 1 ms
            if s_sample_en = '1' then
                
                -- Incrémentation : Front montant A (B=0) OU Front descendant A (B=1)
                if (i_left_ch_a = '1' and r_A_prev = '0' and i_left_ch_b = '0') or
                   (i_left_ch_a = '0' and r_A_prev = '1' and i_left_ch_b = '1') then
                    r_counter <= r_counter + 1;
                    
                -- Décrémentation : Front montant B (A=0) OU Front descendant B (A=1)
                elsif (i_left_ch_b = '1' and r_B_prev = '0' and i_left_ch_a = '0') or
                      (i_left_ch_b = '0' and r_B_prev = '1' and i_left_ch_a = '1') then
                    r_counter <= r_counter - 1;
                end if;

                -- Mémorisation de l'état pour le prochain cycle de 1 ms
                r_A_prev <= i_left_ch_a; 
                r_B_prev <= i_left_ch_b;
            end if;
        end if;
    end process;

    pll0 : component pll 
        port map (
            refclk => i_clk_50,
            rst => not(i_rst_n),
            outclk_0 => s_clk_27,
            locked => s_rst_n
        );

    I2C_HDMI_Config0 : component I2C_HDMI_Config 
        port map (
            iCLK => i_clk_50,
            iRST_N => i_rst_n,
            I2C_SCLK => io_hdmi_i2c_scl,
            I2C_SDAT => io_hdmi_i2c_sda,
            HDMI_TX_INT => i_hdmi_tx_int
     );
end architecture rtl;
```

## Contrôleur HDMI



