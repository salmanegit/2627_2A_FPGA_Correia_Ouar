# 2627_2A_FPGA_Correia_Ouar
TP FPGA 2A

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

Voici le comportement de la LED lorsque l'on appuie sur le bouton
<img width="2250" height="1402" alt="image" src="https://github.com/user-attachments/assets/08c3a25a-412c-4fa9-8a3b-bca20184036b" />



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
Voici la vue représentant
<img width="2252" height="1402" alt="image" src="https://github.com/user-attachments/assets/9af9ec44-068b-4257-8054-4e75b4b61de3" />


Faire clignoter une LED
Q1 ) Sur la carte DE10-Nano, l'horloge FPGA_CLK1_50 est connectée sur la broche PIN_V11

<img width="2242" height="1350" alt="image" src="https://github.com/user-attachments/assets/8aa9e3d7-7455-451a-abaf-301fe811246c" />


<img width="2242" height="1350" alt="image" src="https://github.com/user-attachments/assets/a5e700de-aa63-40b3-b3f2-c5efbaf48698" />


