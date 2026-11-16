-- -----------------------------------------------------------------------------
--
--  Title      :  Edge-Detection design project - task 2.
--             :
--  Developers : Christian Brandt Staunsbjerg - s244770@dtu.dk
--             : 
--             :
--  Purpose    :  This design contains an entity for the accelerator that must be build
--             :  in task two of the Edge Detection design project. It contains an
--             :  architecture skeleton for the entity as well.
--             :
--  Revision   :  1.0   ??-??-??     Final version
--             :
--
-- -----------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- The entity for task two. Notice the additional signals for the memory.
-- reset is active high.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity acc is
    port(
        Px0,Px1,Px2,Px3,Px4,Px5,Px6,Px7,Px8    : in  unsigned (7 downto 0);
        output  : out  unsigned ( 7 downto 0)
    );
end acc;


architecture behavioral of acc is
    signal Dx,Dy : signed( 10 downto 0);
    signal Dn_sum : unsigned (10 downto 0); 
    signal Dn : unsigned ( 7 downto 0 );
begin
    Dx <= signed("000" & Px2) - signed("000" & Px0) + signed("00" & Px5 & '0') - signed("00" & Px3 & '0') + signed("000" & Px8) - signed("000" & Px6);
    Dy <= signed("000" & Px0) - signed("000" & Px6) + signed("00" & Px1 & '0') - signed("00" & Px7 & '0') + signed("000" & Px2) - signed("000" & Px8);
    Dn_sum <= unsigned(abs(Dx)) + unsigned(abs(Dy));  
    Dn <= "11111111" when Dn_sum>255 else unsigned(Dn_sum(7 downto 0));
    output <= Dn;
end behavioral;
