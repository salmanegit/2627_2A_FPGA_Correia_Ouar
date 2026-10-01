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
<img width="2250" height="1402" alt="image" src="https://github.com/user-attachments/assets/08c3a25a-412c-4fa9-8a3b-bca20184036b" />



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
<img width="2252" height="1402" alt="image" src="https://github.com/user-attachments/assets/9af9ec44-068b-4257-8054-4e75b4b61de3" />
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
<img width="1200" height="1600" alt="WhatsApp Image 2026-10-01 at 10 26 11" src="https://github.com/user-attachments/assets/ec76c11c-64fd-407e-889d-54a23a2ef1cd" />  








Schéma proposé par quartus correspondant à ce code VHDL avec RTL Viewer:
<img width="2242" height="1350" alt="image" src="https://github.com/user-attachments/assets/8aa9e3d7-7455-451a-abaf-301fe811246c" />

Q6 ) Explication du code : 

Premier process: 

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

Le premier process sert à ralentir la fréquence de fonctionnement. On ajoute un
compteur qui augmente de 1 à chaque front montant de l’horloge.

Deuxième process : 

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

Q7) 
<img width="1200" height="1600" alt="WhatsApp Image 2026-10-01 at 11 03 09" src="https://github.com/user-attachments/assets/727ab4a8-8e5b-4a7e-a63b-52281ae68153" />

Q8)
<img width="2238" height="570" alt="image" src="https://github.com/user-attachments/assets/34be2136-b762-466a-9a08-681ec0ae7449" />








