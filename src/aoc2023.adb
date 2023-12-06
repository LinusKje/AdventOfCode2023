package body AoC2023 is

   -----------------------------------------------------------------------------
   -- General Package Methods --------------------------------------------------
   -----------------------------------------------------------------------------

   function Is_Character_A_Digit
     (Char : in Character;
      Out_Digit : out Natural)
      return Boolean
   is
   begin
      Out_Digit := Character'Pos(Char) - Character'Pos('0');
      return Out_Digit >= 0 and then Out_Digit < 10;
   end Is_Character_A_Digit;

      -----------------------------------------------------------------------------

end AoC2023;
