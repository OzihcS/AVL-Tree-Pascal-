//////////////////////////
//    theme: AVL Tree   //
// author: A.Piontkowski//
//////////////////////////

program AVLTree;

{$APPTYPE CONSOLE}

uses
  SysUtils,Windows;

type
  pnode =^node;
  node = record
    value:integer;
    left:pnode;
    right:pnode;
    depth:-1..1;
  end;

  queue = array of pnode;

var
q:queue;

procedure Menu;
begin
  writeln(#10#13' 1 - Add');
  writeln(' 2 - Print');
  writeln(' 3 - Edit');
  writeln(' 4 - Delete');
  writeln(' 5 - Display the number of levels');
  writeln(' 6 - Exit'#10#13);
  write(' Your choice: ');
end;

procedure CreateTree(var root:pnode);
begin
  root:=Nil;
end;

procedure RightTurn(var p:pnode);
var
tmp:pnode;
begin
  tmp:=p^.left;
  p^.left:=tmp.right;
  tmp^.right:=p;
  p^.depth:=0;
  p:=tmp;
end;

procedure LeftTurn(var p:pnode);
var
tmp:pnode;
begin
  tmp:=p^.right;
  p^.right:=tmp^.left;
  tmp^.left:=p;
  p^.depth:=0;
  p:=tmp;
end;

procedure RightLeftTurn(var p:pnode);
var
  tmp:pnode;
  t:pnode;
begin
  tmp:=p^.left;
  t:=tmp^.right;
  tmp^.right:=t^.left;
  t^.left:=tmp;
  p^.left:=t^.right;
  t^.right:=p;
  if (t^.depth =-1) then
    p^.depth:=1
  else
    p^.depth:=0;
  if (t^.depth = 1) then
    tmp^.depth:=-1
  else
    tmp^.depth:=0;
  p:=t;
end;

procedure LeftRightTurn(var p:pnode);
var
  tmp:pnode;
  t:pnode;
begin
  tmp:=p^.right;
  t:=tmp^.left;
  tmp^.left:=t^.right;
  t^.right:=tmp;
  p^.right:=t^.left;
  t^.left:=p;
  if (t^.depth = 1) then
    p^.depth:=-1
  else
    p^.depth:=0;
  if (t^.depth = -1) then
    tmp^.depth:=1
  else
    tmp^.depth:=0;
  p:=t;
end;

procedure Add(x:integer; var p:pnode; var h:boolean);
begin
  if (p = nil) then // empty tree
    begin
      New(p);
      h:=true;
      p^.value:=x;
      p^.left:= nil;
      p^.right := nil;
      p^.depth := 0;
    end
  else
    if (x < p^.value) then
      begin
        Add(x, p^.left, h);
        if h then //increased left branch
          case p^.depth of
            1:  begin
                  p^.depth:=0;
                  h:=false;
                end;
            0: p^.depth:=-1;
            -1: begin //balancing
                  if (p^.left^.depth = -1) then
                    RightTurn(p)
                  else
                    RightLeftTurn(p);
                  p^.depth:=0;
                  h:=false;
                end;
          end;
      end
    else
      if (x > p^.value) then
        begin
          Add(x, p^.right, h);
          if h then //increased right branch
            case p^.depth of
              -1: begin
                    p^.depth:=0;
                    h:=false;
                  end ;
              0: p^.depth:=1;
              1:  begin //balancing
                    if (p^.right^.depth = 1) then
                      LeftTurn(p)
                    else
                      LeftRightTurn(p);
                    p^.depth:=0;
                    h:= false;
                  end;
            end;
        end
      else
        h:=false;
end;

procedure push(n:pnode); //add to queue
begin
  SetLength(q,length(q)+1);
  q[high(q)]:= n;
end;
 
function pop:pnode;  //get from the queue
var
  tmp:pnode;
  i:integer;
begin
    pop:=q[0];
    for i:=0 to high(q) do
      begin
        tmp:=q[i];
        q[i]:=q[i+1];
        q[i+1]:=tmp;
      end;
    SetLength(q,length(q)-1);
end;

procedure Print (root:pnode); 
var c,n:integer;
    t:pnode;
begin
  c:=1;n:=0;
  Push(root);
  while length(q)<>0 do
  begin
    t:=pop;
    dec(c);
    if (t <> nil) then
      write(' ',t^.value,' ')
    else
      write(' * ');
    if (t <> nil) then
      begin
        push(t^.left);
        inc(n);
      end;
    if (t <> nil) then
      begin
        push(t^.right);
        inc(n);
      end;
    if (c = 0) then
      begin
        writeln;
        c:=n;
        n:=0;
      end;
  end;
end;

procedure balance1(var root:pnode; var h:boolean);
var
  tmp:pnode;
  b:-1..1;
begin
  case root^.depth of
    -1:root^.depth:=0;
    0:  begin
          root^.depth:=1;
          h:=false;
        end;
    1:  begin
          tmp:=root^.right;
          b:=tmp^.depth;
          if b >= 0 then
            begin     //Right turn
              root^.right:=tmp^.left;
              tmp^.left:=root;
              if b = 0 then
                begin
                  root^.depth:=1;
                  tmp^.depth:=-1;
                  h:=false;
                end
              else
                begin
                  root^.depth:=0;
                  tmp^.depth:=0;
                end;
              root:=tmp;
            end
          else
            RightLeftTurn(tmp);
        end;
  end;
end;

procedure balance2(var root:pnode; var h:boolean);
var
  tmp:pnode;
  b:-1..1;
begin
  case root^.depth of
    1: root^.depth:=0;
    0:  begin
          root^.depth:=-1;
          h:=false;
        end;
    -1: begin
          tmp:=root^.left;
          b:=tmp^.depth;
          if b <= 0 then
            begin//left turn
              root^.left:=tmp^.right;
              tmp^.right:=root;
              if b = 0 then
                begin
                  root^.depth:=-1;
                  tmp^.depth:=1;
                  h:=false;
                end
              else
                begin
                  root^.depth:=0;
                  tmp^.depth:=0;
                end;
              root:=tmp;
            end
          else
            LeftRightTurn(tmp);
        end;
    end;
end;

procedure del(var root:pnode; var h:boolean; var tmp:pnode);
begin
  if root^.right <> Nil then
    begin
      del(root^.right,h,tmp);
      if h then
        balance2(root,h)
    end
  else
    begin
      tmp^.value:=root^.value;
      root:=root^.left;
      h:=true;
    end;
end;

procedure delete(x:integer; var root:pnode; var h:boolean);
var
  tmp:pnode;
begin//delete
  if root = nil then
    begin
      writeln(' Value is not found!');
      h:=false;
    end
  else
    if x < root^.value then
      begin
        delete(x,root^.left,h);
        if h then
          balance1(root,h);
      end
    else
      if x > root^.value then
        begin
          delete(x,root^.right,h);
          if h then
            balance2(root,h);
        end
      else
        begin//del root
          tmp:=root;
          if root^.right = nil then
            begin
              root:=tmp^.left;
              h:=true;
            end
          else
            if root^.left = nil then
              begin
                root:=tmp^.right;
                h:=true;
              end
            else
              begin
                del(root^.left,h,tmp);
                if h then
                  balance1(root,h);
              end;
        end;
end;

procedure Edit(var root:pnode; x:integer; var h:boolean);
var
  new:integer;
begin
  Delete(x,root,h);
  write(' Enter the new value: ');
  readln(new);
  Add(new,root,h);
end;

function Depth(root:pnode; level:integer):integer;
var
  dr,dl:integer;
begin
	if (root = Nil) then
		Depth:=level-1
	else
		begin
			dr:=Depth(root^.left,level+1);
			dl:=Depth(root^.right,level+1);
			if (dr > dl) then
				Depth:=dr
			else
				Depth:=dl;
		end;
end;

procedure Try_Depth(root:pnode);
begin
  if (root <> Nil) then
    writeln(Depth(root,1))
  else
    writeln(0);
end;

VAR
  AVL:pnode;//TREE
  b:boolean;
  cs,d,x:integer;
BEGIN
  writeln(' AVL Tree');
  CreateTree(AVL);

  repeat
    Menu;
    readln(cs);
    case (cs) of
      1:  begin
            write(#10#13' Enter value: ');
            readln(x);
            Add(x,AVL,b);
          end;
      2:  begin
            if(AVL = Nil) then
              writeln(#10#13' Empty tree!')
            else
              begin
                writeln;
                Print(AVL);
                writeln;
              end;
          end;
      3:  begin
            write(#10#13' Enter value: ');
            readln(x);
            Edit(AVL,x,b);
          end;
      4:  begin
            if(AVL = Nil) then
              writeln(#10#13' Empty tree!')
            else
              begin
                write(#10#13' Enter value: ');
                readln(x);
                Delete(x, AVL, b);
              end;
          end;
      5:  begin
            if(AVL <> Nil) then
              begin
                write(' The number of levels of the left subtree: ');
                Try_Depth(AVL^.left);
                write(' The number of levels of the right subtree: ');
                Try_Depth(AVL^.right);
              end
            else
              writeln(' Empty tree!');
          end;
    end;
until (cs = 6);
END.


