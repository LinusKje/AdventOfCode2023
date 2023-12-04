with Ada.Text_IO;
with Ada.Strings.Unbounded;

package body AoC2023.Day1 is

   -----------------------------------------------------------------------------
   -- Private Methods ----------------------------------------------------------
   -----------------------------------------------------------------------------

   function Text_Represents_Digit 
     (Text : in String;
      Out_Digit : out Natural) 
      return Boolean is
   begin
      if (Text'First + 2 <= Text'Last) then
         declare
            Three_Letter_Word : Three_Letters;
         begin
            Three_Letter_Word := Three_Letters'Value (Text (Text'First .. Text'First + 2));
            Out_Digit := Three_Letter_Word'Enum_Rep;
            return True;
         exception
            when Constraint_Error =>
               null; -- No enum value matching the string so do nothing
         end;
      end if;
      
      if (Text'First + 3 <= Text'Last) then
         declare
            Four_Letter_Word : Four_Letters;
         begin
            Four_Letter_Word := Four_Letters'Value (Text (Text'First .. Text'First + 3));
            Out_Digit := Four_Letter_Word'Enum_Rep;
            return True;
         exception
            when Constraint_Error =>
               null; -- No enum value matching the string so do nothing
         end;            
      end if;
      
      if (Text'First + 4 <= Text'Last) then
         declare
            Five_Letter_Word : Five_Letters;
         begin
            Five_Letter_Word := Five_Letters'Value (Text (Text'First .. Text'First + 4));
            Out_Digit := Five_Letter_Word'Enum_Rep;
            return True;
         exception
            when Constraint_Error =>
               null; -- No enum value matching the string so do nothing
         end;            
      end if;
      
      return False;
   end Text_Represents_Digit;
   
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

   function Find_First_Digit_In_Text
     (Text : in String;
      By_Reverse : in Boolean)
      return Natural
   is
      Digit : Natural := 0;
   begin
      if By_Reverse then
         for Index in reverse Text'Range loop
            if Is_Character_A_Digit (Char => Text (Index), Out_Digit => Digit) then
               return Digit;
            elsif Text_Represents_Digit (Text => Text (Index .. Text'Last), Out_Digit => Digit) then
               return Digit;
            end if;
         end loop;
      else
         for Index in Text'Range loop
            if Is_Character_A_Digit (Char => Text (Index), Out_Digit => Digit) then
               return Digit;
            elsif Text_Represents_Digit (Text => Text (Index .. Text'Last), Out_Digit => Digit) then
               return Digit;
            end if;
         end loop;
      end if;
      return 0;
   end Find_First_Digit_In_Text;

   -----------------------------------------------------------------------------

   function Find_Calibration_Value
     (Text : in String)
      return Natural
   is
      Calibration_Value : Natural := 0;
   begin
      Calibration_Value := Calibration_Value + Find_First_Digit_In_Text
        (Text       => Text,
         By_Reverse => False);

      Calibration_Value := Calibration_Value * 10;

      Calibration_Value := Calibration_Value + Find_First_Digit_In_Text
        (Text       => Text,
         By_Reverse => True);

      return Calibration_Value;
   end Find_Calibration_Value;

   -----------------------------------------------------------------------------
   -- Exported Methods ---------------------------------------------------------
   -----------------------------------------------------------------------------
   
   procedure Run 
   is
      package UString renames Ada.Strings.Unbounded;
      Input_File_Paths : array (1 .. 2) of UString.Unbounded_String := 
        (UString.To_Unbounded_String (Source => "Day1/Day1Part1.txt"), 
         UString.To_Unbounded_String (Source => "Day1/Day1Part2.txt"));
   begin
      for Input_File_Path of Input_File_Paths loop
         declare
            Input_File : Ada.Text_IO.File_Type;
            File_Path  : constant String := UString.To_String (Source => Input_File_Path);
            Sum_Of_Calibration_Values : Natural := 0;
         begin
            Ada.Text_IO.Open
              (File => Input_File,
               Mode => Ada.Text_IO.In_File,
               Name => Puzzle_Input_Folder & File_Path);
            
            if Ada.Text_IO.Is_Open (File => Input_File) then
               while not Ada.Text_IO.End_Of_File (File => Input_File) loop
                  declare
                     Read_Line : String := Ada.Text_IO.Get_Line (File => Input_File);
                  begin
                     Sum_Of_Calibration_Values := Sum_Of_Calibration_Values + Find_Calibration_Value (Text => Read_Line);
                  end;
               end loop;
               
               Ada.Text_IO.Put_Line (Item => "Result of " & File_Path & Sum_Of_Calibration_Values'Img);
               
               Ada.Text_IO.Close (File => Input_File);
            end if;
         end;
      end loop;
   end Run;
   
   -----------------------------------------------------------------------------

end AoC2023.Day1;
