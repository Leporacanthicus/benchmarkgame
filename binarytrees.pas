(*
  The Computer Language Benchmarks Game
  http://benchmarksgame.alioth.debian.org/

  contributed by Vitaly Trifonof based on a contribution of Ales Katona
*)

program BinaryTrees;

type
  PNode = ^TNode;
  TNode = record
    l, r: PNode;
    i: Longint;
  end;

function CreateNode(l2, r2: PNode; i2: Longint): PNode; inline;
var
  tmp : PNode;
begin
  new(tmp);
  tmp^.l:=l2;
  tmp^.r:=r2;
  tmp^.i:=i2;
  CreateNode := tmp;
end;


(* Destroy node and it subnodes in one procedure *)

procedure DestroyNode(ANode: PNode); inline;
var
  LNode, RNode: PNode;
begin
  LNode := ANode^.l;
  if LNode <> nil then
  begin
    RNode := ANode^.r;
    if LNode^.l <> nil then
    begin
      DestroyNode(LNode^.l);
      DestroyNode(LNode^.r);
      dispose(LNode);

      DestroyNode(RNode^.l);
      DestroyNode(RNode^.r);
      dispose(RNode);
    end
    else
    begin
      DestroyNode(LNode);
      DestroyNode(RNode);
    end
  end;

  dispose(ANode);
end;


(* Left subnodes check in cycle, right recursive *)

function CheckNode(ANode: PNode): Longint; inline;

var
  t : LongInt;

begin
  t := 0;
  while ANode^.l <> nil do
  begin
    t := t + ANode^.i - CheckNode(ANode^.r);
    ANode := ANode^.l
  end;
  CheckNode := t + ANode^.i;
end;


(*
   Create node and it subnodes in one function

   make(1,a)=(2I-1)=Ia make(2,Ia-1)=(2(2I-1)-1)=(4I-3)
                       make(2,Ia)  =(2(2I-1))  =(4I-2)

   make(1,b)=(2I)=Ib   make(2,Ib-1)=(2(2I)-1)  =(4I-1)
                       make(2,Ib)  =(2(2I))    =(4I)
*)

function Make(d, i: Longint): PNode;
var
  fi: Longint;
begin
  case d of
   0: Make:=CreateNode(nil, nil, i);
   1: Make:=CreateNode(CreateNode(nil, nil, 2*i-1), CreateNode(nil, nil, 2*i),i);
  else
     begin
	d := d - 2; fi := 4*i;
	Make:=CreateNode(
			 CreateNode( Make(d, fi-3),Make(d, fi-2), 2*i-1 ),
			 CreateNode( Make(d, fi-1),Make(d, fi), 2*i ),
			 i
			 );
     end;
  end
end;

const
  mind = 4;

var
  maxd : Longint;
  strd,
  iter,
  c, d, i : Longint;
  tree, llt : PNode;

begin
  if ParamCount = 1 then
    Val(ParamStr(1), maxd)
  else
    maxd := 10;

  if maxd < mind+2 then
     maxd := mind + 2;

  strd:=maxd + 1;
  tree:=Make(strd, 0);
  Writeln('stretch tree of depth ', strd, chr(9), ' check: ', CheckNode(tree));
  DestroyNode(tree);

  llt:=Make(maxd, 0);

  d:=mind;
  while d <= maxd do begin
    iter:=1 shl (maxd - d + mind);
    c:=0;
    for i:=1 to Iter do begin
      tree:=Make(d, i);
      c:=c + CheckNode(tree);
      DestroyNode(tree);
      tree:=Make(d, -i);
      c:=c + CheckNode(tree);
      DestroyNode(tree);
    end;
    Writeln(2 * Iter, chr(9),' trees of depth ', d, chr(9), ' check: ', c);
    d := d + 2;
  end;

  Writeln('long lived tree of depth ', maxd, chr(9),' check: ', CheckNode(llt));
  DestroyNode(llt);
end.
