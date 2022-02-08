program SuperMapEditor;

uses GraphABC;
uses ABCSprites;
uses ABCObjects;

var
  Sprite: SpriteABC;
  mapX, mapY, i, j, startX, startY, exitX, exitY, Cell, num: integer;
  SpriteName, Mapname: string;
  T, mapfile: text;
  MapArr: array [1..63, 1..36] of char;

procedure ChsCellType(y: integer);  //процедура выбора клетки на панели слева
begin
  var i, j: integer;
  case y of
    0: SpriteName := 'FloorSprite.png';  // рисование клеток
    1: SpriteName := 'WallSprite.png';
    2: SpriteName := 'DudeWith    KeySprite.png';
    3: SpriteName := 'LevelerOffSprite.png';
    4: SpriteName := 'RedKeySprite.png';
    5: SpriteName := 'RedDoorSprite.png';
    6: SpriteName := 'GreenKeySprite.png';
    7: SpriteName := 'GreenDoorSprite.png';
    8: SpriteName := 'BlueKeySprite.png';
    9: SpriteName := 'BlueDoorSprite.png';
    10: SpriteName := 'YellowKeySprite.png';
    11: SpriteName := 'YellowDoorSprite.png';
    12: SpriteName := 'Exit.png';
    13: 
      begin// сохранение карты
        assign(T, Mapname + '.txt');      // запись карты
        rewrite(T);
        for i := 1 to 36 do
          for j := 1 to 63 do
            if (MapArr[j, i] <> 'U') then
            begin
              if (j > mapX) then mapX := j;
              if (i > mapY) then mapY := i;
            end;
        for i := 1 to mapY do
          for j := 1 to mapX do
            write(T, MapArr[j, i]);
        close(T);
        assign(T, Mapname + 'Parameters.txt'); // запись параметров карты
        rewrite(T);
        writeln(T, mapX);
        writeln(T, mapY);
        writeln(T, startX);
        writeln(T, startY);
        writeln(T, exitX);
        writeln(T, exitY);
        close(T);
      end;
  end;
end;

procedure MouseDown(x, y, mb: integer);//процедура обработки клика мышью(рисование клетки)
begin
  x := x div (30);                        // получаем координаты
  y := y div (30);
  if x * 30 >= 30 then
  begin
    Sprite := new SpriteABC(x * 30 + 1, y * 30, SpriteName);
    case SpriteName of
      'FloorSprite.png': MapArr[x, y + 1] := 'U';
      'WallSprite.png': MapArr[x, y + 1] := 'W';
      'RedDoorSprite.png': MapArr[x, y + 1] := 'R';
      'RedKeySprite.png': MapArr[x, y + 1] := 'r';
      'GreenDoorSprite.png': MapArr[x, y + 1] := 'G';
      'GreenKeySprite.png': MapArr[x, y + 1] := 'g';
      'BlueDoorSprite.png': MapArr[x, y + 1] := 'B';
      'BlueKeySprite.png': MapArr[x, y + 1] := 'b';
      'YellowDoorSprite.png': MapArr[x, y + 1] := 'Y';
      'YellowKeySprite.png': MapArr[x, y + 1] := 'y';
      'LevelerOffSprite.png': MapArr[x, y + 1] := 'O';
      'DudeWith    KeySprite.png': begin MapArr[x, y + 1] := 'S'; startX := x; startY := y + 1; end;  // сохраняем координаты стартовой позиции
      'Exit.png': begin MapArr[x, y + 1] := 'W'; exitX := x; exitY := y + 1; end;          // и выхода
    end;
  end;
  if x * 30 = 0 then ChsCellType(y);
end;

procedure OpenMap();
begin
  var i, j: integer;
  readln(Mapname);
  ClearWindow(clWhite);
  for i := 1 to 36 do  // делаем все клетки на карте неисследованными
    for j := 1 to 63 do
    begin
      MapArr[j, i] := 'U';
      Sprite := new SpriteABC(j * 30 + 1, i * 30 - 30, 'FloorSprite.png');
    end;
  assign(mapfile, Mapname + 'Parameters.txt');  // считываем настройки карты
  reset(mapfile);
  readln(mapfile, mapX);       // размеры (X;Y)
  readln(mapfile, mapY);
  Setwindowsize(mapX * 30 + 31, mapY * 30);
  readln(mapfile, startX);      // стартовая позиция (X;Y)
  readln(mapfile, startY);
  readln(mapfile, exitX);     // выход (X;Y)
  readln(mapfile, exitY);
  close(mapfile);
  assign(mapfile, Mapname + '.txt');   // считываем карту
  reset(mapfile);
  for j := 1 to mapY do              // заполняем массив картой (накладываем поверх)
  begin
    for i := 1 to mapX do
    begin
      read(mapfile, MapArr[i, j]);
      case MapArr[i, j] of
        'U': num := 0;
        'W': num := 1;
        'O': num := 3;
        'r': num := 4;
        'R': num := 5;
        'g': num := 6;
        'G': num := 7;
        'b': num := 8;
        'B': num := 9;
        'y': num := 10;
        'Y': num := 11;
      end;
      if (i = startX) and (j = startY) then num := 2;
      if (i = exitX) and (j = exitY) then num := 12;
      ChsCellType(num);
      Sprite := new SpriteABC(i * 30 + 1, j * 30 - 30, SpriteName);
    end;
  end;
  close(mapfile);
end;

begin
  Setwindowsize(14 * 30 + 31, 14 * 30);
  SetWindowTitle('SuperMapEditor');
  SpriteName := 'SpaceSprite.png';
  writeln('введите название карты...');
  readln(Mapname);
  ClearWindow(clWhite);
  if (Mapname = 'open') then OpenMap()
  else
    for i := 1 to 36 do  // делаем все клетки на карте неисследованными
      for j := 1 to 63 do
      begin
        MapArr[j, i] := 'U';
        Sprite := new SpriteABC(j * 30 + 1, i * 30 - 30, 'FloorSprite.png');
      end;
  Sprite := new SpriteABC(0, 0, 'FloorSprite.png');   Sprite := new SpriteABC(0, 30, 'WallSprite.png');
  Sprite := new SpriteABC(0, 60, 'DudeWith    KeySprite.png');  Sprite := new SpriteABC(0, 90, 'LevelerOffSprite.png');
  Sprite := new SpriteABC(0, 120, 'RedKeySprite.png');  Sprite := new SpriteABC(0, 150, 'RedDoorSprite.png');
  Sprite := new SpriteABC(0, 180, 'GreenKeySprite.png');  Sprite := new SpriteABC(0, 210, 'GreenDoorSprite.png');
  Sprite := new SpriteABC(0, 240, 'BlueKeySprite.png'); Sprite := new SpriteABC(0, 270, 'BlueDoorSprite.png');
  Sprite := new SpriteABC(0, 300, 'YellowKeySprite.png'); Sprite := new SpriteABC(0, 330, 'YellowDoorSprite.png');
  Sprite := new SpriteABC(0, 390, 'Save.png'); Sprite := new SpriteABC(0, 360, 'Exit.png');
  line(30, 0, 30, 36 * 30);
  while(true) do  // цикл рисования
  begin
    OnMouseDown := MouseDown;
  end
end.