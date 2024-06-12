// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract TicTacToe {
    enum Player { None, Player1, Player2 }
    
    Player[3][3] public board;
    Player public currentPlayer;
    address public player1;
    address public player2;
    address public winner;

    event GameStarted(address player1, address player2);
    event MoveMade(address player, uint8 row, uint8 col);
    event GameWon(address winner);
    event GameDraw();

    modifier onlyPlayers() {
        require(msg.sender == player1 || msg.sender == player2, "Not a player");
        _;
    }

    modifier validMove(uint8 row, uint8 col) {
        require(row < 3 && col < 3, "Invalid board position");
        require(board[row][col] == Player.None, "Position already taken");
        _;
    }

    constructor(address _player2) {
        player1 = msg.sender;
        player2 = _player2;
        currentPlayer = Player.Player1;
        emit GameStarted(player1, player2);
    }

    function makeMove(uint8 row, uint8 col) public onlyPlayers validMove(row, col) {
        require(winner == address(0), "Game has already been won");
        require(currentPlayer == (msg.sender == player1 ? Player.Player1 : Player.Player2), "Not your turn");

        board[row][col] = currentPlayer;
        emit MoveMade(msg.sender, row, col);

        if (checkWin()) {
            winner = msg.sender;
            emit GameWon(winner);
        } else if (checkDraw()) {
            emit GameDraw();
        } else {
            currentPlayer = (currentPlayer == Player.Player1) ? Player.Player2 : Player.Player1;
        }
    }

    function checkWin() internal view returns (bool) {
        for (uint8 i = 0; i < 3; i++) {
            if (board[i][0] == currentPlayer && board[i][1] == currentPlayer && board[i][2] == currentPlayer) {
                return true;
            }
            if (board[0][i] == currentPlayer && board[1][i] == currentPlayer && board[2][i] == currentPlayer) {
                return true;
            }
        }
        if (board[0][0] == currentPlayer && board[1][1] == currentPlayer && board[2][2] == currentPlayer) {
            return true;
        }
        if (board[0][2] == currentPlayer && board[1][1] == currentPlayer && board[2][0] == currentPlayer) {
            return true;
        }
        return false;
    }

    function checkDraw() internal view returns (bool) {
        for (uint8 i = 0; i < 3; i++) {
            for (uint8 j = 0; j < 3; j++) {
                if (board[i][j] == Player.None) {
                    return false;
                }
            }
        }
        return true;
    }
}
