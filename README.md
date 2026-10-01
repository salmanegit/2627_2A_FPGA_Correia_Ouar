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

Inversion du comportement de la LED:
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










Faire clignoter une LED
Q1 ) Sur la carte DE10-Nano, l'horloge FPGA_CLK1_50 est connectée sur la broche PIN_V11

Q3) <img width="1200" height="1600" alt="WhatsApp Image 2026-10-01 at 10 26 11" src="https://github.com/user-attachments/assets/ec76c11c-64fd-407e-889d-54a23a2ef1cd" />


<img width="2242" height="1350" alt="image" src="https://github.com/user-attachments/assets/8aa9e3d7-7455-451a-abaf-301fe811246c" />





