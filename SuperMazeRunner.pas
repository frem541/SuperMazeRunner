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
  // процедура отрисовки неисcледованной клекти
procedure UnexploredDraw(x, y: integer);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, 'UnexploredCellSprite.png');
end;
  // процедура стирания прошлой позиции персонажа
procedure EraseCell(x, y: integer);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, 'FloorSprite.png');
end;

  // процедура отрисовки персонажа
procedure DudeDraw(x, y: integer; S1, S2, S3, S4: char);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, 'DudeWith' + S1 + S2 + S3 + S4 + 'KeySprite.png');
end;

  // процедура отрисовки стен
procedure WallDraw(x, y: integer);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, 'WallSprite.png');
end;

  // процедура отрисовки ключа
procedure KeyDraw(x, y: integer; tpe: string);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, tpe + 'KeySprite.png');
end;

  // процедура отрисовки рычага в состоянии вкл.
procedure LevelerDrawON(x, y: integer);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, 'LevelerOnSprite.png');
end;

  // процедура отрисовки рычага в состоянии выкл.
procedure LevelerDrawOFF(x, y: integer);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, 'LevelerOffSprite.png');
end;

  // процедура отрисовки двери
procedure DoorDraw(x, y: integer; _type: string);
begin
  Sprite := new SpriteABC(x * 30 - 30, y * 30 - 30, _type + 'DoorSprite.png');
end;

  // процедура отрисовки окружения
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
  // процедура переключения рычага
procedure SwitchLeveler(x, y: integer);
begin// проверяем все клетки вокруг игрока
  if(MapArr[x, y - 1] = 'O') then begin LevelerDrawON(x, y - 1); NumOfLevelers := NumOfLevelers - 1; MapArr[x, y - 1] := 'L'; end;             // если находим рычаг, то отрисовываем на его месте
  if(MapArr[x + 1, y - 1] = 'O') then begin LevelerDrawON(x + 1, y - 1); NumOfLevelers := NumOfLevelers - 1; MapArr[x + 1, y - 1] := 'L'; end; // рычаг в состоянии ON и увеличиваем кол-во активных рычагов
  if(MapArr[x + 1, y] = 'O') then begin LevelerDrawON(x + 1, y); NumOfLevelers := NumOfLevelers - 1; MapArr[x + 1, y] := 'L'; end;
  if(MapArr[x + 1, y + 1] = 'O') then begin LevelerDrawON(x + 1, y + 1); NumOfLevelers := NumOfLevelers - 1; MapArr[x + 1, y + 1] := 'L'; end;
  if(MapArr[x, y + 1] = 'O') then begin LevelerDrawON(x, y + 1); NumOfLevelers := NumOfLevelers - 1; MapArr[x, y + 1] := 'L'; end;
  if(MapArr[x - 1, y + 1] = 'O') then begin LevelerDrawON(x - 1, y + 1); NumOfLevelers := NumOfLevelers - 1; MapArr[x - 1, y + 1] := 'L'; end;
  if(MapArr[x - 1, y - 1] = 'O') then begin LevelerDrawON(x - 1, y - 1); NumOfLevelers := NumOfLevelers - 1; MapArr[x - 1, y - 1] := 'L'; end;
  if(MapArr[x - 1, y] = 'O') then begin LevelerDrawON(x - 1, y); NumOfLevelers := NumOfLevelers - 1; MapArr[x - 1, y] := 'L'; end;
end;

  // процедура поднятия ключа
procedure PickUpKey(x, y: integer);
begin// проверяем все клетки вокруг игрока
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

  // процедура открытия двери
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
  
  // 1 - загрузка
  readln(Mapname);
  assign(mapfile, Mapname + 'Parameters.txt');  // загружаем настройки карты
  reset(mapfile);
  readln(mapfile, sizeX);       // размеры (X;Y)
  readln(mapfile, sizeY);
  readln(mapfile, startX);      // стартовая позиция (X;Y)
  readln(mapfile, startY);
  readln(mapfile, outputX);     // выход (X;Y)
  readln(mapfile, outputY);
  close(mapfile);
  assign(mapfile, Mapname + '.txt');   // загружаем карту
  reset(mapfile);
  NumOfLevelers := 0;
  for j := 1 to 36 do
  begin
    for i := 1 to 63 do       // отрисовыеваем на карте серые клетки
    begin
      UnexploredDraw(i, j);
    end;
  end;
  for j := 1 to sizeY do              // заполняем массив картой
  begin
    for i := 1 to sizeX do
    begin
      read(mapfile, MapArr[i, j]);
      if MapArr[i, j] = 'O' then NumOfLevelers := NumOfLevelers + 1;
    end;
  end;
  close(mapfile);
  // 1
  // 2 - настройка
    for j := 1 to 36 do
  begin
    for i := 1 to 63 do       // отрисовыеваем на карте серые клетки
    begin
      UnexploredDraw(i, j);
    end;
  end;
  S1 := ' ';
  S2 := ' ';
  S3 := ' ';
  S4 := ' ';
  NumOfRKeys := 0; // явно обнуляем значения количества ключей
  NumOfGKeys := 0; 
  NumOfBKeys := 0; 
  NumOfYKeys := 0;
  IsKeyPckupedOrUsed := false;
  SetWindowTitle('SuperMazeRunner');
  SetWindowSize(sizeX * 30, sizeY * 30); // выставляем размеры окна (клетка = 30 пикселей)
  x := startX;   // ставим игрока в его стартовую позицию
  y := startY;
  EnvironmentDraw(x + 1, y); // отрисовываем клетки вокруг игрока
  EnvironmentDraw(x - 1, y);
  EnvironmentDraw(x, y + 1);
  EnvironmentDraw(x, y - 1);
  EnvironmentDraw(x + 1, y + 1);
  EnvironmentDraw(x + 1, y - 1);
  EnvironmentDraw(x - 1, y + 1);
  EnvironmentDraw(x - 1, y - 1);
  DudeDraw(x, y, S1, S2, S3, S4);
  // 2
  // 3 - игра
  while (x <> outputX) or (y <> outputY) do  // пока не нашли выход
  begin
    if NumOfLevelers <= 0 then
    begin
      MapArr[outputX, outputY] := 'S';  // открываем выход, если все рычаги переключены
      EraseCell(outputX, outputY);
    end;
    read(enter);                           // считываем клавишу
    case enter of
      's': 
        if (MapArr[x, y + 1] = 'S') or (MapArr[x, y + 1] = 'U') then  // движение вниз
        begin
          EraseCell(x, y);     // стираем старую позицию игрока
          MapArr[x, y] := 'S'; // сохраняем клетку в массиве как исследованную
          y := y + 1;             // получаем координаты новой позиции игрока
        end;
      'w': 
        if (MapArr[x, y - 1] = 'S') or (MapArr[x, y - 1] = 'U') then // движение вверх
        begin
          EraseCell(x, y);
          MapArr[x, y] := 'S';
          y := y - 1;
        end;
      'd': 
        if (MapArr[x + 1, y] = 'S') or (MapArr[x + 1, y] = 'U') then // движение вправо
        begin
          EraseCell(x, y);
          MapArr[x, y] := 'S';
          x := x + 1;
        end;
      'a': 
        if (MapArr[x - 1, y] = 'S') or (MapArr[x - 1, y] = 'U') then // движение влево
        begin
          EraseCell(x, y);
          MapArr[x, y] := 'S';
          x := x - 1;   
        end;
      'f': 
        if (enter = 'f') then // взаимодействие
        begin
          SwitchLeveler(x, y); // переключаем рычаг
          PickUpKey(x, y);     // поднимаем ключ
          OpenDoor(x, y);      // открываем дверь
        end;
    end;
    EnvironmentDraw(x + 1, y); // отрисовываем клетки вокруг игрока
    EnvironmentDraw(x - 1, y);
    EnvironmentDraw(x, y + 1);
    EnvironmentDraw(x, y - 1);
    EnvironmentDraw(x + 1, y + 1);
    EnvironmentDraw(x + 1, y - 1);
    EnvironmentDraw(x - 1, y + 1);
    EnvironmentDraw(x - 1, y - 1);
    if IsKeyPckupedOrUsed = true then   // если был подобран ключ/открыта дверь
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