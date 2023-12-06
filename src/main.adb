with Ada.Text_IO;
with Ada.Characters.Latin_1;
with AoC2023.Day1;
with AoC2023.Day2;

procedure Main is
begin
   Ada.Text_IO.Put_Line (Item => "-- Day 1 ----------------------------------");
   AoC2023.Day1.Run;
   Ada.Text_IO.Put_Line (Item => "-------------------------------------------" & Ada.Characters.Latin_1.LF);

   Ada.Text_IO.Put_Line (Item => "-- Day 2 ----------------------------------");
   AoC2023.Day2.Run;
   Ada.Text_IO.Put_Line (Item => "-------------------------------------------" & Ada.Characters.Latin_1.LF);
end Main;
