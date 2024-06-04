with Ada.Numerics.Discrete_Random, Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
package body Assgn is 
    procedure Init_Array(Arr : in out BINARY_ARRAY) is 
        subtype Random_Range is Integer range 0 .. 1;
        package R is new
            Ada.Numerics.Discrete_Random (Random_Range);
        use R;
        G : Generator;
        X : Random_Range;
    begin
        Arr(1) := 0;
        Arr(2) := 0;
        Reset (G);
        for i in 3 .. Arr'Length loop
            X := Random(G);
            Arr(i) := X;
        end loop;
    end Init_Array;

    procedure Reverse_Bin_Arr(Arr : in out BINARY_ARRAY) is
        A : Integer;
        N : Integer;
    begin
        -- Not sure if this is working correctly 
        N := Arr'Length / 2;
        for i in 1 .. N loop
            A := Arr(i);
            Arr(i) := Arr(Arr'Length - i + 1);
            Arr(Arr'Length - i + 1) := A;
        end loop;
        
        A := 0;
    end Reverse_Bin_Arr;

    procedure Print_Bin_Arr(Arr : in BINARY_ARRAY) is
    begin
        for i in 1 .. Arr'Length loop
            Put(Integer'Image(Arr(i)));
        end loop;
        New_Line;
    end Print_Bin_Arr;

    function Int_To_Bin(Num : in Integer) return BINARY_ARRAY is
        Arr : BINARY_ARRAY := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
        N : Integer := Num;
    begin
        -- Convert an integer to a binary array
        for i in reverse 1 .. Arr'Length loop
            Arr(i) := N rem 2;
            N := N / 2;
        end loop;
        return Arr;
    end Int_To_Bin;

    function Bin_To_Int(Arr : in BINARY_ARRAY) return Integer is
        N : Integer := 0;
        CURR : Integer := 1;
    begin
        -- Convert a binary array to an integer
        for i in reverse 1 .. Arr'Length loop
            N := N + (Arr(i) * CURR);
            CURR := CURR * 2;
        end loop;
        return N;
    end Bin_To_Int;

    function "+" (Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
        Result : BINARY_ARRAY := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
        l, r, c, res: BOOLEAN := False;
        c_res : BINARY_NUMBER;
    begin
        for i in reverse 1 .. Result'Length loop
            if Left(i) = 1 then
                l := True;
            else 
                l := False;
            end if;

            if Right(i) = 1 then
                r := True;
            else 
                r := False;
            end if;

            res := l xor r xor c;
            c := (c and (l xor r)) or (l and r);

            if res = True then
                c_res := 1;
            else
                c_res := 0;
            end if;

            Result(i) := c_res;
        end loop;
        return Result;
    end "+";
    function "+" (Left : in INTEGER; Right : in BINARY_ARRAY) return BINARY_ARRAY is
        L_BIN : BINARY_ARRAY := Int_To_Bin(Left);
        Result : BINARY_ARRAY;
    begin
        Result := L_BIN + Right;
        return Result;
    end "+";

    function "-" (Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
        S_RIGHT : BINARY_ARRAY := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
        RESULT : BINARY_ARRAY;
        CURR : INTEGER := 0 ;
    begin
        for i in 1 .. Right'Length loop
            S_RIGHT(i) := (1+Right(i)) rem 2;
        end loop;
        S_RIGHT := 1 + S_RIGHT;
        -- S_RIGHT is in 2cns without its leading 1 bit.

        RESULT := LEFT + S_RIGHT;

        return RESULT;
    end "-";
    function "-" (Left : in INTEGER; Right : in BINARY_ARRAY) return BINARY_ARRAY is
        L_BIN : BINARY_ARRAY := Int_To_Bin(Left);
    begin
        return L_BIN - Right;
    end "-";


end Assgn;
