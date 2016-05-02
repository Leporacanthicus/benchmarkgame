{  The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/

   contributed by Marco van de Voort
}

program reverse_complement;

const
   MAX_ITEMS  = 11;
   MAX_BUFFER =  32768;

type
   buffer_arr =  array[0..MAX_BUFFER] of char;

var
  lookupComplement : array[char] of char;
  FASTAXLAT	   : array[0..MAX_ITEMS] of array[0..1] of char;


const
   BufferIncrement = 1024;

procedure flushbuffer(var buffer:buffer_arr; inbuf: integer);

var p,p2 : integer;
    c  : char;

begin
   if inbuf>0 then
   begin
      p:=0;
      p2:=inbuf-1;
      while p<p2 do
      begin
	 c:=lookupcomplement[buffer[p]];
	 buffer[p]:=lookupcomplement[buffer[p2]];
	 buffer[p2]:=c;
	 inc(p);
	 dec(p2);
      end;
      if p2=p then
	 buffer[p]:=lookupcomplement[buffer[p]];

      p := 0;
      buffer[inbuf]:=chr(0);

      p2 := 0;
      for p := 0 to inbuf-1 do
      begin
	 write(buffer[p]);
	 inc(p2);
	 if p2 = 60 then
	 begin
	    writeln;
	    p2 := 0;
	 end;
      end;
      if p2 <> 0 then
	 writeln;
   end;
end;

const initialincrement=1024;

procedure run;

var
   s : string;
   c : char;
   buffersize,
   bufferptr,
   len		: integer;
   line : integer;
   buffer: buffer_arr;


procedure initialize;

begin
   FASTAXLAT[0][0] := 'A';
   FASTAXLAT[0][1] := 'T';
   
   FASTAXLAT[1][0] := 'C';
   FASTAXLAT[1][1] := 'G';
   
   FASTAXLAT[2][0] := 'B';
   FASTAXLAT[2][1] := 'V';

   FASTAXLAT[3][0] := 'D';
   FASTAXLAT[3][1] := 'H';

   FASTAXLAT[4][0] := 'K';
   FASTAXLAT[4][1] := 'M';
   
   FASTAXLAT[5][0] := 'R';
   FASTAXLAT[5][1] := 'Y';

   FASTAXLAT[6][0] := 'a';
   FASTAXLAT[6][1] := 't';

   FASTAXLAT[7][0] := 'c';
   FASTAXLAT[7][1] := 'g';

   FASTAXLAT[8][0] := 'b';
   FASTAXLAT[8][1] := 'v';
   
   FASTAXLAT[9][0] := 'd';
   FASTAXLAT[9][1] := 'h';
   
   FASTAXLAT[10][0] := 'k';
   FASTAXLAT[10][1] := 'm';

   FASTAXLAT[11][0] := 'r';
   FASTAXLAT[11][1] := 'y';
end;

function upcase(c : char) : char;
begin
   if c in ['a'..'z'] then
      upcase := chr(ord(c) - 32)
   else
      upcase := c;
end; { upcase }

procedure move(var s : string; var buff: buffer_arr; pos: integer);
var
   i   : integer;
   len : integer;
begin
   len := length(s);
   for i := 0 to len-1 do
      buff[pos+i] := s[i+1];
end;

begin
   initialize;
   for c:= chr(0)  to chr(255)  do
      lookupcomplement[c]:=c;
   for len:=0 to MAX_ITEMS do
   begin
      lookupcomplement[FASTAXLAT[len][0]]:=upcase(FASTAXLAT[len][1]);
      lookupcomplement[FASTAXLAT[len][1]]:=upcase(FASTAXLAT[len][0]);
   end;

   buffersize:=initialincrement;
   bufferptr :=0;
   line:=0;
   while not eof do
    begin
      readln(s);
      inc(line);
      len:=length(s);
      if (len>0) and (s[1]='>') then
          begin
	    flushbuffer(buffer,bufferptr);
 	    writeln(s);
	    bufferptr:=0;
	  end
       else
       begin
	  move(s, buffer, bufferptr);
	  { move(s[1],p[bufferptr],len); }
	  bufferptr := bufferptr + len;
       end;
    end;
    flushbuffer(buffer,bufferptr);
end;

begin
  run;
end.
