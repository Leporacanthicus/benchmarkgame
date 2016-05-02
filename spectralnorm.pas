{ The Computer Language Benchmarks Game
  http://benchmarksgame.alioth.debian.org

  contributed by Ian Osgood
  modified by Vincent Snijders
}

program spectralNorm;

const
   MAXSIZE =  16384;


type
   values = array [1..MAXSIZE] of real;

var
   n,i	   : integer;
   u,v,tmp : values;
   vBv,vv  : real;

function A(i,j : integer): real; inline;
begin
  A := 1 / ((i+j)*(i+j+1) div 2 + i+1);
end;

procedure mulAv(var v, Av : values);
var i,j : integer;
begin
  for i := 1 to n do
  begin
    Av[i] := 0.0;
    for j := 1 to n do
      Av[i] := Av[i] + A(i,j) * v[j];
  end;
end;

procedure mulAtv(var v, Atv : values);
var i,j : integer;
begin
  for i := 1 to n do
  begin
    Atv[i] := 0.0;
    for j := 1 to n do
      Atv[i] := Atv[i] + A(j,i) * v[j];
  end;
end;

procedure mulAtAv(var v, AtAv : values);
begin
  mulAv(v, tmp);
  mulAtv(tmp, AtAv);
end;

begin
  Val(paramstr(1), n);

  for i := 1 to n do u[i] := 1.0;

  for i := 1 to 10 do begin mulAtAv(u,v); mulAtAv(v,u) end;

  for i := 1 to n do
  begin
    vBv := vBv + u[i]*v[i];
    vv  := vv  + v[i]*v[i];
  end;

  writeln(sqrt(vBv/vv):0:9);
end.
