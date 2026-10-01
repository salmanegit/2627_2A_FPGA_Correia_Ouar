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

Q11)


Chenillard : 
Chenillard
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









