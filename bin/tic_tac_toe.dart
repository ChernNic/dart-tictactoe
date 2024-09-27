import 'dart:io'; // Подключение библиотеки для работы с вводом и выводом в консоли
import 'dart:math'; // Подключение библиотеки для генерации случайных чисел

// Класс, описывающий игру "Крестики-нолики"
class TicTacToe {
  // Двумерный список для игрового поля
  List<List<String>> board;
  // Размер поля
  int size;
  // Текущий игрок ('X' или 'O')
  late String currentPlayer;
  // Режим игры (игрок против игрока или игрок против компьютера)
  late String gameMode;
  // Флаг завершения игры
  bool isGameOver = false;
  // Генератор случайных чисел для выбора случайных значений (например, кто ходит первым)
  final Random random = Random();

  // Конструктор класса, который создает пустое поле указанного размера
  TicTacToe(this.size) : board = List.generate(size, (_) => List.filled(size, ' '));

  // Метод для очистки консоли (работает с ANSI-последовательностями)
  void clearConsole() {
    print('\x1B[2J\x1B[0;0H');
  }

  // Метод для вывода игрового поля на экран
  void printBoard() {
    // Печатаем номера столбцов
    print('  ${List.generate(size, (index) => index + 1).join(' ')}');

    // Печатаем строки с номерами строк
    for (int i = 0; i < size; i++) {
      String row = board[i].map((cell) => cell == ' ' ? '.' : cell).join(' ');
      print('${i + 1} $row');
    }
  }

  // Метод для размещения метки игрока на поле (если это возможно)
  bool placeMark(int x, int y) {
    // Проверка на допустимость координат и наличие свободной клетки
    if (x < 0 || x >= size || y < 0 || y >= size || board[x][y] != ' ') {
      print('Недопустимые координаты или клетка занята, попробуйте снова.');
      return false; // Если ход невозможен, возвращаем false
    }
    board[x][y] = currentPlayer; // Размещаем метку текущего игрока
    return true; // Возвращаем true, если ход успешен
  }

  // Метод для переключения текущего игрока (между 'X' и 'O')
  void switchPlayer() {
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
  }

  // Метод для проверки победы (по строкам, столбцам или диагоналям)
  bool checkWin() {
    // Проверяем строки и столбцы
    for (int i = 0; i < size; i++) {
      // Если все элементы в строке или в столбце принадлежат текущему игроку, он выигрывает
      if (board[i].every((cell) => cell == currentPlayer) || board.every((row) => row[i] == currentPlayer)) {
        return true;
      }
    }

    // Проверяем диагонали
    if (List.generate(size, (i) => board[i][i]).every((cell) => cell == currentPlayer) ||
        List.generate(size, (i) => board[i][size - i - 1]).every((cell) => cell == currentPlayer)) {
      return true;
    }

    return false; // Возвращаем false, если победы нет
  }

  // Метод для проверки ничьи (если все клетки заняты)
  bool checkDraw() {
    return board.every((row) => row.every((cell) => cell != ' '));
  }

  // Метод для игры "игрок против игрока"
  void playHumanVsHuman() {
    while (!isGameOver) { // Пока игра не завершена
      printBoard(); // Выводим игровое поле
      print('Игрок $currentPlayer, введите координаты (строка и столбец через пробел):');
      String? input = stdin.readLineSync(); // Считываем ввод от пользователя

      // Проверка на пустой ввод
      if (input == null || input.trim().isEmpty) {
        clearConsole(); // Очищаем консоль перед выводом ошибки
        print('Пустой ввод, попробуйте снова.');
        continue;
      }

      // Разделяем введенные координаты на два значения
      List<String> parts = input.split(' ');

      // Проверка на корректное количество аргументов
      if (parts.length != 2) {
        clearConsole(); // Очищаем консоль перед выводом ошибки
        print('Неправильный ввод, попробуйте снова. Введите два числа через пробел.');
        continue;
      }

      // Преобразуем строки в числа
      int x = int.tryParse(parts[0]) ?? -1;
      int y = int.tryParse(parts[1]) ?? -1;

      // Если ввод был корректным и ход возможен
      if (placeMark(x - 1, y - 1)) {
        clearConsole(); // Очищаем консоль после успешного хода

        if (checkWin()) { // Проверка на победу
          printBoard();
          print('Игрок $currentPlayer выиграл!');
          isGameOver = true;
        } else if (checkDraw()) { // Проверка на ничью
          printBoard();
          print('Ничья!');
          isGameOver = true;
        } else {
          switchPlayer(); // Переход хода
        }
      }
    }
  }

  // Метод для игры "игрок против компьютера"
  void playHumanVsAI() {
    while (!isGameOver) { // Пока игра не завершена
      printBoard(); // Выводим игровое поле

      if (currentPlayer == 'X') { // Если ход игрока
        print('Игрок $currentPlayer, введите координаты (строка и столбец через пробел):');
        String? input = stdin.readLineSync(); // Считываем ввод от пользователя

        // Проверка на пустой ввод
        if (input == null || input.trim().isEmpty) {
          clearConsole(); // Очищаем консоль перед выводом ошибки
          print('Пустой ввод, попробуйте снова.');
          continue;
        }

        // Разделяем введенные координаты на два значения
        List<String> parts = input.split(' ');

        // Проверка на корректное количество аргументов
        if (parts.length != 2) {
          clearConsole(); // Очищаем консоль перед выводом ошибки
          print('Неправильный ввод, попробуйте снова. Введите два числа через пробел.');
          continue;
        }

        // Преобразуем строки в числа
        int x = int.tryParse(parts[0]) ?? -1;
        int y = int.tryParse(parts[1]) ?? -1;

        // Если ввод был корректным и ход возможен
        if (placeMark(x - 1, y - 1)) {
          clearConsole(); // Очищаем консоль после успешного хода

          if (checkWin()) { // Проверка на победу
            printBoard();
            print('Игрок $currentPlayer выиграл!');
            isGameOver = true;
          } else if (checkDraw()) { // Проверка на ничью
            printBoard();
            print('Ничья!');
            isGameOver = true;
          } else {
            switchPlayer(); // Переход хода к компьютеру
          }
        }
      } else { // Если ход компьютера
        print('Ход робота...');
        makeAIMove(); // Ход компьютера
        clearConsole(); // Очищаем консоль после хода компьютера

        if (checkWin()) { // Проверка на победу компьютера
          printBoard();
          print('Робот выиграл!');
          isGameOver = true;
        } else if (checkDraw()) { // Проверка на ничью
          printBoard();
          print('Ничья!');
          isGameOver = true;
        } else {
          switchPlayer(); // Переход хода обратно к игроку
        }
      }
    }
  }

  // Метод для выполнения хода компьютера
  void makeAIMove() {
    int x, y;
    // Генерация случайных координат до тех пор, пока не будет найдена свободная клетка
    do {
      x = random.nextInt(size);
      y = random.nextInt(size);
    } while (board[x][y] != ' ');

    board[x][y] = currentPlayer; // Размещение метки компьютера
  }

  // Метод для начала новой игры
  void startNewGame() {
    print('Выберите режим игры:');
    print('1. Игра против человека');
    print('2. Игра против робота');
    String? choice = stdin.readLineSync(); // Считываем выбор пользователя

    // Проверка на корректный выбор режима
    if (choice == null || choice.trim().isEmpty || (choice != '1' && choice != '2')) {
      print('Неправильный выбор, попробуйте снова.');
      return;
    }

    // Установка режима игры
    gameMode = choice == '1' ? 'human_vs_human' : 'human_vs_ai';
    // Случайный выбор первого игрока
    currentPlayer = random.nextBool() ? 'X' : 'O';
    isGameOver = false; // Сбрасываем флаг завершения игры

    // Начало игры в зависимости от выбранного режима
    if (gameMode == 'human_vs_human') {
      playHumanVsHuman();
    } else {
      playHumanVsAI();
    }

    // Запрашиваем, хочет ли пользователь сыграть еще раз
    print('Хотите сыграть еще раз? (y/n)');
    String? answer = stdin.readLineSync();
    bool playAgain = answer != null && answer.toLowerCase() == 'y';

    // Если да, начинаем новую игру, иначе заканчиваем
    if (playAgain) {
      resetGame();
      startNewGame();
    } else {
      print('Спасибо за игру!');
    }
  }

  // Метод для сброса игрового поля и состояния игры
  void resetGame() {
    board = List.generate(size, (_) => List.filled(size, ' '));
    isGameOver = false;
  }
}

void main(List<String> arguments) {
  print('Добро пожаловать в игру Крестики-Нолики!');
  int size = 0;

  // Проверка на корректный ввод размера игрового поля (размер не менее 3)
  while (size < 3) {
    print('Введите размер игрового поля (минимум 3):');
    String? input = stdin.readLineSync();

    // Проверка на корректность введенных данных
    if (input == null || input.trim().isEmpty || int.tryParse(input) == null) {
      print('Неправильный ввод, попробуйте снова.');
      continue;
    }

    size = int.parse(input);

    if (size < 3) {
      print('Размер игрового поля должен быть не менее 3.');
    }
  }

  // Создаем объект игры и запускаем новую игру
  TicTacToe game = TicTacToe(size);
  game.startNewGame();
}
