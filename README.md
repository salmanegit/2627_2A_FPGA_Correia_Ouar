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





4. Simulation sur Modelsim:
<img width="2298" height="1058" alt="image" src="https://github.com/user-attachments/assets/55febbce-63e0-4066-8a58-093e942c1879" />

Interprétation :  
On observe bien les deux sens de rotation simulés par le testbench.   Sens 1 (Incrémentation) : Le signal i_ch_a passe à '1' en premier (en avance sur i_ch_b). Le compteur o_leds s'incrémente bien et passe de 0000000000 à 0000000001 (valeur 1).   
Sens 2 (Décrémentation) : Plus loin dans la simulation (autour de 700 000 ps), c'est le signal i_ch_b qui passe à '1' en premier (en avance sur i_ch_a). Le compteur détecte le changement de sens et se décrémente pour revenir à 0000000000 (valeur 0).   
La logique de détection de sens et le compteur fonctionnent bien. 


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
    
    -- Compteur et signal pour l'anti-rebond (échantillonnage à 1 ms)
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
    -- Process de l'encodeur avec anti-rebond
    process(i_clk_50, i_rst_n)
    begin
        if i_rst_n = '0' then
            r_A_prev  <= '0';
            r_B_prev  <= '0';
            r_counter <= (others => '0');
    
        elsif rising_edge(i_clk_50) then
            -- Lecture de l'encodeur toutes les 1 ms
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

```

Filtre anti-rebond : Quand on tourne la molette, les contacts mécaniques créent des rebonds qui peuvent fausser la lecture. Avec la condition if s_sample_en = '1', le FPGA ne lit l'état de l'encodeur qu'une fois toutes les 1 ms. Ainsi, le signal a le temps de se stabiliser et le compteur ne compte pas de faux mouvements.

```vhdl

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

```VHDL
-- Horloge pixel envoyée à la puce HDMI ADV7513
o_hdmi_tx_clk <= s_clk_27;

-- 4. Instanciation du Contrôleur HDMI
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
```

5) Le signal o_hdmi_tx_d est codé sur 24 bits : de 0 à 7 c'est le bleu, de 8 à 15 c'est vert, et de 23 à 16 c'est rouge.

code dpram.vhd

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity dpram is
    generic
    (
        mem_size    : natural := 720 * 480;
        data_width  : natural := 8
    );
   port 
   (   
        i_clk_a     : in std_logic;
        i_clk_b     : in std_logic;

        i_data_a    : in std_logic_vector(data_width-1 downto 0);
        i_data_b    : in std_logic_vector(data_width-1 downto 0);
        i_addr_a    : in natural range 0 to mem_size-1;
        i_addr_b    : in natural range 0 to mem_size-1;
        i_we_a      : in std_logic := '1';
        i_we_b      : in std_logic := '1';
        o_q_a       : out std_logic_vector(data_width-1 downto 0);
        o_q_b       : out std_logic_vector(data_width-1 downto 0)
   );
   
end dpram;

architecture rtl of dpram is
    -- Build a 2-D array type for the RAM
    subtype word_t is std_logic_vector(data_width-1 downto 0);
    type memory_t is array(0 to mem_size-1) of word_t;
    
    -- Declare the RAM
    shared variable ram : memory_t;
begin
    -- Port A
    process(i_clk_a)
    begin
        if(rising_edge(i_clk_a)) then 
            if(i_we_a = '1') then
                ram(i_addr_a) := i_data_a;
            end if;
            o_q_a <= ram(i_addr_a);
        end if;
    end process;
    
    -- Port B
    process(i_clk_b)
    begin
        if(rising_edge(i_clk_b)) then
            if(i_we_b = '1') then
                ram(i_addr_b) := i_data_b;
            end if;
            o_q_b <= ram(i_addr_b);
        end if;
    end process;
end rtl;
```




<img width="2880" height="1614" alt="image" src="https://github.com/user-attachments/assets/45276914-5489-4324-b0f4-f8d54b315ccf" />

## Déplacement d'un pixel

```VHDL
-- Signaux Encodeur Gauche (Axe X) et Droit (Axe Y)
signal r_x_pos : natural range 0 to h_res - 1 := h_res / 2; -- Départ au centre
signal r_y_pos : natural range 0 to v_res - 1 := v_res / 2;
```

1. Modification du fichier telecran.vhd
Calcul de la position (r_x_pos, r_y_pos) avec les encodeurs :
On lit les signaux des deux boutons rotatifs pour déplacer notre point à l'écran. Le bouton de gauche (i_left_ch_a, i_left_ch_b) fait bouger le point à l'horizontale sur r_x_pos (entre 0 et 719), et le bouton de droite (i_right_ch_a, i_right_ch_b) le fait bouger à la verticale sur r_y_pos (entre 0 et 479) — on a corrigé l'erreur du sujet qui parlait deux fois du bouton de gauche.
Quand on appuie sur le bouton de remise à zéro (i_rst_n = '0'), on replace le point directement au milieu de l'écran (r_x_pos <= h_res / 2; et r_y_pos <= v_res / 2;).

Affichage du point blanc (x"FFFFFF") sur o_hdmi_tx_d :
Pour cette étape (avant d'ajouter la mémoire), on compare simplement la position de nos boutons avec la position en cours d'affichage de l'écran (s_x_counter, s_y_counter) code : 
o_hdmi_tx_d <= x"FFFFFF" when (s_x_counter = r_x_pos and s_y_counter = r_y_pos) else x"000000";

Dès que l'écran affiche l'endroit où se trouve notre point (r_x_pos, r_y_pos), on envoie la couleur blanche x"FFFFFF". Pour tout le reste de l'écran, on envoie du noir (x"000000").

2. Test sur la carte
Vérification sur la carte et à l'écran :Sur la carte DE10-Nano : Pour vérifier que le bouton de gauche comptait bien les crans avant même de regarder l'écran, on a relié la position horizontale r_x_pos aux 10 LEDs de la carte (o_leds <= std_logic_vector(to_unsigned(r_x_pos, 10));), ce qui nous a permis de voir les LEDs changer en direct.
via VLC : Après avoir envoyé le programme dans la carte, on a bien obtenu un seul point blanc au milieu de l'écran qui bouge à l'horizontale et à la verticale quand on tourne les deux boutons, sans jamais sortir des bords de l'image ($720 \times 480$).



## Mémorisation
1. Mémoire dual-port
Une mémoire dual-port (DPRAM) est une mémoire qui possède deux accès totalement indépendants port A et port B, chacun ayant sa propre horloge, son adresse et ses propres fils de données.
Dans notre projet, cela nous permet de faire deux choses en même temps sans qu'elles se gênent :Le port A sert à enregistrer le dessin dès qu'on tourne les boutons (à $50\text{ MHz}$).
Le port B sert à lire l'image en continu pour l'envoyer à l'écran HDMI (à $27\text{ MHz}$).   


## Effacement
