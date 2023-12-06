with Ada.Text_IO;

package body AoC2023.Day2 is

   -----------------------------------------------------------------------------
   -- Private Methods ----------------------------------------------------------
   -----------------------------------------------------------------------------
   
   function Convert_Game_Text_To_Cube_Set 
     (Text : in String;
      Out_Characters_Read : out Natural) 
      return Set_Of_Cubes_T 
   is
      Set : Set_Of_Cubes_T := Empty_Set;
      Temp_Character : Character;
      Temp_Value : Natural := 0;
      Read_Digit : Natural;
   begin
      Out_Characters_Read := 0;
      
      while Text'First + Out_Characters_Read <= Text'Last loop
         Temp_Character := Text (Text'First + Out_Characters_Read);
         
         Out_Characters_Read := Out_Characters_Read + 1;
         exit when Temp_Character = ';';
         
         if not (Temp_Character = ' ' or else Temp_Character = ',') then
            if Is_Character_A_Digit (Char => Temp_Character, Out_Digit => Read_Digit) then
               Temp_Value := (Temp_Value * 10) + Read_Digit;
            else
               case Temp_Character is
                  when 'r' =>
                     Set (Red) := Temp_Value;
                     Temp_Value := 0;
                     Out_Characters_Read := Out_Characters_Read + 2;
                  when 'g' =>
                     Set (Green) := Temp_Value;
                     Temp_Value := 0;
                     Out_Characters_Read := Out_Characters_Read + 4;
                  when 'b' =>
                     Set (Blue) := Temp_Value;
                     Temp_Value := 0;
                     Out_Characters_Read := Out_Characters_Read + 3;
                  when others =>
                     Temp_Value := 0;
               end case;
            end if;
         end if;
      end loop;

      return Set;
   end Convert_Game_Text_To_Cube_Set;
   
   -----------------------------------------------------------------------------
   
   function Does_Set_Include_Cubes_Outside_Allowed_Range 
     (Set : in Set_Of_Cubes_T;
      Game_Configuration : in Set_Of_Cubes_T)
      return Boolean is
   begin
      return not
        (Set (Red)   in 0 .. Game_Configuration (Red) and then
         Set (Green) in 0 .. Game_Configuration (Green) and then
         Set (Blue)  in 0 .. Game_Configuration (Blue));
   end Does_Set_Include_Cubes_Outside_Allowed_Range;
   
   -----------------------------------------------------------------------------
   
   function Is_Game_Possible 
     (Text : in String; 
      Game_Configuration : in Set_Of_Cubes_T) 
      return Boolean 
   is
      Text_Index : Natural := Text'First;
   begin
      while Text_Index < Text'Last loop
         declare
            Set : Set_Of_Cubes_T := Empty_Set;
            Characters_Read : Natural;
         begin
            Set := Convert_Game_Text_To_Cube_Set 
              (Text => Text (Text_Index .. Text'Last),
               Out_Characters_Read => Characters_Read);
            
            if Does_Set_Include_Cubes_Outside_Allowed_Range (Set => Set, Game_Configuration => Max_Allowed_Cubes_Part_1) then
               return False;
            end if;
            
            Text_Index := Text_Index + Characters_Read;
         end;
      end loop;

      return True;
   end Is_Game_Possible;
   
   -----------------------------------------------------------------------------
   
   procedure Update_Set_With_Fewest_Cubes_Needed_For_Possible_Game
     (Stored_Set : in out Set_Of_Cubes_T; 
      Game_Set : in Set_Of_Cubes_T) is
   begin
      for Color in Set_Of_Cubes_T'Range loop
         if Game_Set (Color) > Stored_Set (Color) then
            Stored_Set (Color) := Game_Set (Color);
         end if;
      end loop;
   end Update_Set_With_Fewest_Cubes_Needed_For_Possible_Game;
   
   -----------------------------------------------------------------------------
   
   function Calculate_Fewest_Number_Of_Allowed_Cubes_In_Game 
     (Text : in String) 
      return Set_Of_Cubes_T 
   is
      Fewest_Number_Of_Cubes : Set_Of_Cubes_T := Empty_Set;
      Text_Index : Natural := Text'First;
   begin
      while Text_Index < Text'Last loop
         declare
            Set : Set_Of_Cubes_T := Empty_Set;
            Characters_Read : Natural;
         begin
            Set := Convert_Game_Text_To_Cube_Set 
              (Text => Text (Text_Index .. Text'Last),
               Out_Characters_Read => Characters_Read);
            
            Update_Set_With_Fewest_Cubes_Needed_For_Possible_Game 
              (Stored_Set => Fewest_Number_Of_Cubes,
               Game_Set   => Set);
            
            Text_Index := Text_Index + Characters_Read;
         end;
      end loop;
      
      return Fewest_Number_Of_Cubes;
   end Calculate_Fewest_Number_Of_Allowed_Cubes_In_Game;
   
   -----------------------------------------------------------------------------
   
   procedure Run_Part_1 
   is
      Input_File : Ada.Text_IO.File_Type;
      Input_File_Path : constant String := "Day2/Day2Part1.txt";
      Game_Id : Natural := 0;
      Sum_Of_Allowed_Game_Ids : Natural := 0;
   begin
      Ada.Text_IO.Open
        (File => Input_File,
         Mode => Ada.Text_IO.In_File,
         Name => Puzzle_Input_Folder & Input_File_Path);
      
      if Ada.Text_IO.Is_Open (File => Input_File) then
         while not Ada.Text_IO.End_Of_File (File => Input_File) loop
            declare
               Read_Line : String := Ada.Text_IO.Get_Line (File => Input_File);
            begin
               Game_Id := Game_Id + 1;
               if Is_Game_Possible (Text => Read_Line, Game_Configuration => Max_Allowed_Cubes_Part_1) then
                  Sum_Of_Allowed_Game_Ids := Sum_Of_Allowed_Game_Ids + Game_Id;
               end if;
            end;
         end loop;
               
         Ada.Text_IO.Put_Line (Item => "Result of " & Input_File_Path & Sum_Of_Allowed_Game_Ids'Img);
               
         Ada.Text_IO.Close (File => Input_File);
      end if;
   end Run_Part_1;
   
   -----------------------------------------------------------------------------
   
   procedure Run_Part_2
   is
      Input_File : Ada.Text_IO.File_Type;
      Input_File_Path : constant String := "Day2/Day2Part2.txt";
      Sum_Of_Powers : Natural := 0;
   begin
      Ada.Text_IO.Open
        (File => Input_File,
         Mode => Ada.Text_IO.In_File,
         Name => Puzzle_Input_Folder & Input_File_Path);
      
      if Ada.Text_IO.Is_Open (File => Input_File) then
         while not Ada.Text_IO.End_Of_File (File => Input_File) loop
            declare
               Read_Line : String := Ada.Text_IO.Get_Line (File => Input_File);
               Fewest_Number_Of_Cubes : Set_Of_Cubes_T := Empty_Set;
            begin
               Fewest_Number_Of_Cubes := Calculate_Fewest_Number_Of_Allowed_Cubes_In_Game 
                 (Text => Read_Line);
               
               Sum_Of_Powers := Sum_Of_Powers + (Fewest_Number_Of_Cubes (Red) * Fewest_Number_Of_Cubes (Green) * Fewest_Number_Of_Cubes (Blue));
            end;
         end loop;
               
         Ada.Text_IO.Put_Line (Item => "Result of " & Input_File_Path & Sum_Of_Powers'Img);
               
         Ada.Text_IO.Close (File => Input_File);
      end if;
   end Run_Part_2;
   
   -----------------------------------------------------------------------------
   -- Exported Methods ---------------------------------------------------------
   -----------------------------------------------------------------------------
   
   procedure Run is
   begin
      Run_Part_1;
      Run_Part_2;
   end Run;
   
   -----------------------------------------------------------------------------

end AoC2023.Day2;
