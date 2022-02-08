program Game;

uses GraphABC;
uses ABCSprites;
var
  i, j, x, y, NumOfRKeys, NumOfGKeys, NumOfBKeys, NumOfYKeys, NumOfActiveLevelers, outputX, outputY, NumOfLevelers, startX, startY, sizeX, sizeY: integer;
  IsKeyPckupedOrUsed: boolean;
  enter, S1, S2, S3, S4: char;
  Sprite: SpriteABC;
  mapfile: text;
  Mapname: string;
  MapArr: array [1..63, 1..36] of char;
  // ��������� ��������� ����c���������� ������
procedure UnexploredDraw(x, y: integer);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, 'UnexploredCellSprite.png');
end;
  // ��������� �������� ������� ������� ���������
procedure EraseCell(x, y: integer);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, 'FloorSprite.png');
end;

  // ��������� ��������� ���������
procedure DudeDraw(x, y: integer; S1, S2, S3, S4: char);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, 'DudeWith' + S1 + S2 + S3 + S4 + 'KeySprite.png');
end;

  // ��������� ��������� ����
procedure WallDraw(x, y: integer);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, 'WallSprite.png');
end;

  // ��������� ��������� �����
procedure KeyDraw(x, y: integer; tpe: string);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, tpe + 'KeySprite.png');
end;

  // ��������� ��������� ������ � ��������� ���.
procedure LevelerDrawON(x, y: integer);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, 'LevelerOnSprite.png');
end;

  // ��������� ��������� ������ � ��������� ����.
procedure LevelerDrawOFF(x, y: integer);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, 'LevelerOffSprite.png');
end;

  // ��������� ��������� �����
procedure DoorDraw(x, y: integer; _type: string);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, _type + 'DoorSprite.png');
end;

  // ��������� ��������� ���������
procedure EnvironmentDraw(x, y: integer);
begin
  case MapArr[x, y] of         
    'W': WallDraw(x, y);      
    'O': LevelerDrawOFF(x, y); 
    'R': DoorDraw(x, y, 'Red');
    'G': DoorDraw(x, y, 'Green');
    'B': DoorDraw(x, y, 'Blue');
    'Y': DoorDraw(x, y, 'Yellow');
    'r': KeyDraw(x, y, 'Red');
    'g': KeyDraw(x, y, 'Green');
    'b': KeyDraw(x, y, 'Blue');
    'y': KeyDraw(x, y, 'Yellow');
    'L': LevelerDrawON(x, y); 
    'S': EraseCell(x, y);      
    'U': EraseCell(x, y);     
  end;
end;
  // ��������� ������������ ������
procedure SwitchLeveler(x, y: integer);
begin// ��������� ��� ������ ������ ������
  if(MapArr[x, y - 1] = 'O') then begin LevelerDrawON(x, y - 1); NumOfLevelers := NumOfLevelers - 1; MapArr[x, y - 1] := 'L'; end;             // ���� ������� �����, �� ������������ �� ��� �����
  if(MapArr[x + 1, y - 1] = 'O') then begin LevelerDrawON(x + 1, y - 1); NumOfLevelers := NumOfLevelers - 1; MapArr[x + 1, y - 1] := 'L'; end; // ����� � ��������� ON � ����������� ���-�� �������� �������
  if(MapArr[x + 1, y] = 'O') then begin LevelerDrawON(x + 1, y); NumOfLevelers := NumOfLevelers - 1; MapArr[x + 1, y] := 'L'; end;
  if(MapArr[x + 1, y + 1] = 'O') then begin LevelerDrawON(x + 1, y + 1); NumOfLevelers := NumOfLevelers - 1; MapArr[x + 1, y + 1] := 'L'; end;
  if(MapArr[x, y + 1] = 'O') then begin LevelerDrawON(x, y + 1); NumOfLevelers := NumOfLevelers - 1; MapArr[x, y + 1] := 'L'; end;
  if(MapArr[x - 1, y + 1] = 'O') then begin LevelerDrawON(x - 1, y + 1); NumOfLevelers := NumOfLevelers - 1; MapArr[x - 1, y + 1] := 'L'; end;
  if(MapArr[x - 1, y - 1] = 'O') then begin LevelerDrawON(x - 1, y - 1); NumOfLevelers := NumOfLevelers - 1; MapArr[x - 1, y - 1] := 'L'; end;
  if(MapArr[x - 1, y] = 'O') then begin LevelerDrawON(x - 1, y); NumOfLevelers := NumOfLevelers - 1; MapArr[x - 1, y] := 'L'; end;
end;

  // ��������� �������� �����
procedure PickUpKey(x, y: integer);
begin// ��������� ��� ������ ������ ������
  if(MapArr[x, y - 1] = 'r') then begin EraseCell(x, y - 1); NumOfRKeys := NumOfRKeys + 1; MapArr[x, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x + 1, y - 1] = 'r') then begin EraseCell(x + 1, y - 1); NumOfRKeys := NumOfRKeys + 1; MapArr[x + 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x + 1, y] = 'r') then begin EraseCell(x + 1, y); NumOfRKeys := NumOfRKeys + 1; MapArr[x + 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x + 1, y + 1] = 'r') then begin EraseCell(x + 1, y + 1); NumOfRKeys := NumOfRKeys + 1; MapArr[x + 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x, y + 1] = 'r') then begin EraseCell(x, y + 1); NumOfRKeys := NumOfRKeys + 1; MapArr[x, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x - 1, y + 1] = 'r') then begin EraseCell(x - 1, y + 1); NumOfRKeys := NumOfRKeys + 1; MapArr[x - 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x - 1, y - 1] = 'r') then begin EraseCell(x - 1, y - 1); NumOfRKeys := NumOfRKeys + 1; MapArr[x - 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x - 1, y] = 'r') then begin EraseCell(x - 1, y); NumOfRKeys := NumOfRKeys + 1; MapArr[x - 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
  
  if(MapArr[x, y - 1] = 'g') then begin EraseCell(x, y - 1); NumOfGKeys := NumOfGKeys + 1; MapArr[x, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x + 1, y - 1] = 'g') then begin EraseCell(x + 1, y - 1); NumOfGKeys := NumOfGKeys + 1; MapArr[x + 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x + 1, y] = 'g') then begin EraseCell(x + 1, y); NumOfGKeys := NumOfGKeys + 1; MapArr[x + 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x + 1, y + 1] = 'g') then begin EraseCell(x + 1, y + 1); NumOfGKeys := NumOfGKeys + 1; MapArr[x + 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x, y + 1] = 'g') then begin EraseCell(x, y + 1); NumOfGKeys := NumOfGKeys + 1; MapArr[x, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x - 1, y + 1] = 'g') then begin EraseCell(x - 1, y + 1); NumOfGKeys := NumOfGKeys + 1; MapArr[x - 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x - 1, y - 1] = 'g') then begin EraseCell(x - 1, y - 1); NumOfGKeys := NumOfGKeys + 1; MapArr[x - 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x - 1, y] = 'g') then begin EraseCell(x - 1, y); NumOfGKeys := NumOfGKeys + 1; MapArr[x - 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
  
  if(MapArr[x, y - 1] = 'b') then begin EraseCell(x, y - 1); NumOfBKeys := NumOfBKeys + 1; MapArr[x, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x + 1, y - 1] = 'b') then begin EraseCell(x + 1, y - 1); NumOfBKeys := NumOfBKeys + 1; MapArr[x + 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x + 1, y] = 'b') then begin EraseCell(x + 1, y); NumOfBKeys := NumOfBKeys + 1; MapArr[x + 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x + 1, y + 1] = 'b') then begin EraseCell(x + 1, y + 1); NumOfBKeys := NumOfBKeys + 1; MapArr[x + 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x, y + 1] = 'b') then begin EraseCell(x, y + 1); NumOfBKeys := NumOfBKeys + 1; MapArr[x, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x - 1, y + 1] = 'b') then begin EraseCell(x - 1, y + 1); NumOfBKeys := NumOfBKeys + 1; MapArr[x - 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x - 1, y - 1] = 'b') then begin EraseCell(x - 1, y - 1); NumOfBKeys := NumOfBKeys + 1; MapArr[x - 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x - 1, y] = 'b') then begin EraseCell(x - 1, y); NumOfBKeys := NumOfBKeys + 1; MapArr[x - 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
  
  if(MapArr[x, y - 1] = 'y') then begin EraseCell(x, y - 1); NumOfYKeys := NumOfYKeys + 1; MapArr[x, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x + 1, y - 1] = 'y') then begin EraseCell(x + 1, y - 1); NumOfYKeys := NumOfYKeys + 1; MapArr[x + 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x + 1, y] = 'y') then begin EraseCell(x + 1, y); NumOfYKeys := NumOfYKeys + 1; MapArr[x + 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x + 1, y + 1] = 'y') then begin EraseCell(x + 1, y + 1); NumOfYKeys := NumOfYKeys + 1; MapArr[x + 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x, y + 1] = 'y') then begin EraseCell(x, y + 1); NumOfYKeys := NumOfYKeys + 1; MapArr[x, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x - 1, y + 1] = 'y') then begin EraseCell(x - 1, y + 1); NumOfYKeys := NumOfYKeys + 1; MapArr[x - 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x - 1, y - 1] = 'y') then begin EraseCell(x - 1, y - 1); NumOfYKeys := NumOfYKeys + 1; MapArr[x - 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
  if(MapArr[x - 1, y] = 'y') then begin EraseCell(x - 1, y); NumOfYKeys := NumOfYKeys + 1; MapArr[x - 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;   
end;

  // ��������� �������� �����
procedure OpenDoor(x, y: integer);
begin
  if (NumOfRKeys > 0) then
  begin
    if(MapArr[x, y - 1] = 'R') then begin EraseCell(x, y - 1); NumOfRKeys := NumOfRKeys - 1; MapArr[x, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x + 1, y - 1] = 'R') then begin EraseCell(x + 1, y - 1); NumOfRKeys := NumOfRKeys - 1; MapArr[x + 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x + 1, y] = 'R') then begin EraseCell(x + 1, y); NumOfRKeys := NumOfRKeys - 1; MapArr[x + 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x + 1, y + 1] = 'R') then begin EraseCell(x + 1, y + 1); NumOfRKeys := NumOfRKeys - 1; MapArr[x + 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x, y + 1] = 'R') then begin EraseCell(x, y + 1); NumOfRKeys := NumOfRKeys - 1; MapArr[x, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x - 1, y + 1] = 'R') then begin EraseCell(x - 1, y + 1); NumOfRKeys := NumOfRKeys - 1; MapArr[x - 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x - 1, y - 1] = 'R') then begin EraseCell(x - 1, y - 1); NumOfRKeys := NumOfRKeys - 1; MapArr[x - 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x - 1, y] = 'R') then begin EraseCell(x - 1, y); NumOfRKeys := NumOfRKeys - 1; MapArr[x - 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
  end;
  if (NumOfGKeys > 0) then
  begin
    if(MapArr[x, y - 1] = 'G') then begin EraseCell(x, y - 1); NumOfGKeys := NumOfGKeys - 1; MapArr[x, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x + 1, y - 1] = 'G') then begin EraseCell(x + 1, y - 1); NumOfGKeys := NumOfGKeys - 1; MapArr[x + 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x + 1, y] = 'G') then begin EraseCell(x + 1, y); NumOfGKeys := NumOfGKeys - 1; MapArr[x + 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x + 1, y + 1] = 'G') then begin EraseCell(x + 1, y + 1); NumOfGKeys := NumOfGKeys - 1; MapArr[x + 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x, y + 1] = 'G') then begin EraseCell(x, y + 1); NumOfGKeys := NumOfGKeys - 1; MapArr[x, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x - 1, y + 1] = 'G') then begin EraseCell(x - 1, y + 1); NumOfGKeys := NumOfGKeys - 1; MapArr[x - 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x - 1, y - 1] = 'G') then begin EraseCell(x - 1, y - 1); NumOfGKeys := NumOfRKeys - 1; MapArr[x - 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x - 1, y] = 'G') then begin EraseCell(x - 1, y); NumOfGKeys := NumOfGKeys - 1; MapArr[x - 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
  end;
  if (NumOfBKeys > 0) then
  begin
    if(MapArr[x, y - 1] = 'B') then begin EraseCell(x, y - 1); NumOfBKeys := NumOfBKeys - 1; MapArr[x, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x + 1, y - 1] = 'B') then begin EraseCell(x + 1, y - 1); NumOfBKeys := NumOfBKeys - 1; MapArr[x + 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x + 1, y] = 'B') then begin EraseCell(x + 1, y); NumOfBKeys := NumOfBKeys - 1; MapArr[x + 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x + 1, y + 1] = 'B') then begin EraseCell(x + 1, y + 1); NumOfBKeys := NumOfBKeys - 1; MapArr[x + 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x, y + 1] = 'B') then begin EraseCell(x, y + 1); NumOfBKeys := NumOfBKeys - 1; MapArr[x, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x - 1, y + 1] = 'B') then begin EraseCell(x - 1, y + 1); NumOfBKeys := NumOfBKeys - 1; MapArr[x - 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x - 1, y - 1] = 'B') then begin EraseCell(x - 1, y - 1); NumOfBKeys := NumOfBKeys - 1; MapArr[x - 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x - 1, y] = 'B') then begin EraseCell(x - 1, y); NumOfBKeys := NumOfBKeys - 1; MapArr[x - 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
  end;
  if (NumOfYKeys > 0) then
  begin
    if(MapArr[x, y - 1] = 'Y') then begin EraseCell(x, y - 1); NumOfYKeys := NumOfYKeys - 1; MapArr[x, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x + 1, y - 1] = 'Y') then begin EraseCell(x + 1, y - 1); NumOfYKeys := NumOfYKeys - 1; MapArr[x + 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x + 1, y] = 'Y') then begin EraseCell(x + 1, y); NumOfYKeys := NumOfYKeys - 1; MapArr[x + 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x + 1, y + 1] = 'Y') then begin EraseCell(x + 1, y + 1); NumOfYKeys := NumOfYKeys - 1; MapArr[x + 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x, y + 1] = 'Y') then begin EraseCell(x, y + 1); NumOfYKeys := NumOfYKeys - 1; MapArr[x, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x - 1, y + 1] = 'Y') then begin EraseCell(x - 1, y + 1); NumOfYKeys := NumOfYKeys - 1; MapArr[x - 1, y + 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x - 1, y - 1] = 'Y') then begin EraseCell(x - 1, y - 1); NumOfYKeys := NumOfYKeys - 1; MapArr[x - 1, y - 1] := 'S'; IsKeyPckupedOrUsed := true; end;
    if(MapArr[x - 1, y] = 'Y') then begin EraseCell(x - 1, y); NumOfYKeys := NumOfYKeys - 1; MapArr[x - 1, y] := 'S'; IsKeyPckupedOrUsed := true; end;
  end;
end;

begin
  
  // 1 - ��������
  readln(Mapname);
  assign(mapfile, Mapname + 'Parameters.txt');  // ��������� ��������� �����
  reset(mapfile);
  readln(mapfile, sizeX);       // ������� (X;Y)
  readln(mapfile, sizeY);
  readln(mapfile, startX);      // ��������� ������� (X;Y)
  readln(mapfile, startY);
  readln(mapfile, outputX);     // ����� (X;Y)
  readln(mapfile, outputY);
  close(mapfile);
  assign(mapfile, Mapname + '.txt');   // ��������� �����
  reset(mapfile);
  NumOfLevelers := 0;
  for j := 1 to 36 do
  begin
    for i := 1 to 63 do       // ������������� �� ����� ����� ������
    begin
      UnexploredDraw(i, j);
    end;
  end;
  for j := 1 to sizeY do              // ��������� ������ ������
  begin
    for i := 1 to sizeX do
    begin
      read(mapfile, MapArr[i, j]);
      if MapArr[i, j] = 'O' then NumOfLevelers := NumOfLevelers + 1;
    end;
  end;
  close(mapfile);
  // 1
  // 2 - ���������
    for j := 1 to 36 do
  begin
    for i := 1 to 63 do       // ������������� �� ����� ����� ������
    begin
      UnexploredDraw(i, j);
    end;
  end;
  S1 := ' ';
  S2 := ' ';
  S3 := ' ';
  S4 := ' ';
  NumOfRKeys := 0; // ���� �������� �������� ���������� ������
  NumOfGKeys := 0; 
  NumOfBKeys := 0; 
  NumOfYKeys := 0;
  IsKeyPckupedOrUsed := false;
  SetWindowTitle('SuperMazeRunner');
  SetWindowSize(sizeX * 30, sizeY * 30); // ���������� ������� ���� (������ = 30 ��������)
  x := startX;   // ������ ������ � ��� ��������� �������
  y := startY;
  EnvironmentDraw(x + 1, y); // ������������ ������ ������ ������
  EnvironmentDraw(x - 1, y);
  EnvironmentDraw(x, y + 1);
  EnvironmentDraw(x, y - 1);
  EnvironmentDraw(x + 1, y + 1);
  EnvironmentDraw(x + 1, y - 1);
  EnvironmentDraw(x - 1, y + 1);
  EnvironmentDraw(x - 1, y - 1);
  DudeDraw(x, y, S1, S2, S3, S4);
  // 2
  // 3 - ����
  while (x <> outputX) or (y <> outputY) do  // ���� �� ����� �����
  begin
    if NumOfLevelers <= 0 then
    begin
      MapArr[outputX, outputY] := 'S';  // ��������� �����, ���� ��� ������ �����������
      EraseCell(outputX, outputY);
    end;
    read(enter);                           // ��������� �������
    case enter of
      's': 
        if (MapArr[x, y + 1] = 'S') or (MapArr[x, y + 1] = 'U') then  // �������� ����
        begin
          EraseCell(x, y);     // ������� ������ ������� ������
          MapArr[x, y] := 'S'; // ��������� ������ � ������� ��� �������������
          y := y + 1;             // �������� ���������� ����� ������� ������
        end;
      'w': 
        if (MapArr[x, y - 1] = 'S') or (MapArr[x, y - 1] = 'U') then // �������� �����
        begin
          EraseCell(x, y);
          MapArr[x, y] := 'S';
          y := y - 1;
        end;
      'd': 
        if (MapArr[x + 1, y] = 'S') or (MapArr[x + 1, y] = 'U') then // �������� ������
        begin
          EraseCell(x, y);
          MapArr[x, y] := 'S';
          x := x + 1;
        end;
      'a': 
        if (MapArr[x - 1, y] = 'S') or (MapArr[x - 1, y] = 'U') then // �������� �����
        begin
          EraseCell(x, y);
          MapArr[x, y] := 'S';
          x := x - 1;   
        end;
      'f': 
        if (enter = 'f') then // ��������������
        begin
          SwitchLeveler(x, y); // ����������� �����
          PickUpKey(x, y);     // ��������� ����
          OpenDoor(x, y);      // ��������� �����
        end;
    end;
    EnvironmentDraw(x + 1, y); // ������������ ������ ������ ������
    EnvironmentDraw(x - 1, y);
    EnvironmentDraw(x, y + 1);
    EnvironmentDraw(x, y - 1);
    EnvironmentDraw(x + 1, y + 1);
    EnvironmentDraw(x + 1, y - 1);
    EnvironmentDraw(x - 1, y + 1);
    EnvironmentDraw(x - 1, y - 1);
    if IsKeyPckupedOrUsed = true then   // ���� ��� �������� ����/������� �����
    begin
      IsKeyPckupedOrUsed := false;
      if NumOfRKeys > 0 then S1 := 'R' else S1 := ' ';
      if NumOfGKeys > 0 then S2 := 'G' else S2 := ' ';
      if NumOfBKeys > 0 then S3 := 'B' else S3 := ' ';
      if NumOfYKeys > 0 then S4 := 'Y' else S4 := ' ';
    end;
    DudeDraw(x, y, S1, S2, S3, S4);
  end;
  // 3
end.