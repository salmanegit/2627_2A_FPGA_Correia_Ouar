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
<br>
<br>
<br>
<br>
<img width="787" height="432" alt="image" src="https://github.com/user-attachments/assets/928ba042-e130-49e2-aa36-2c08665210d1" />


Q8)
<img width="2238" height="570" alt="image" src="https://github.com/user-attachments/assets/34be2136-b762-466a-9a08-681ec0ae7449" />








