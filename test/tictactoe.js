const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TicTacToe", function () {
  let TicTacToe;
  let ticTacToe;
  let player1;
  let player2;

  beforeEach(async function () {
    [player1, player2] = await ethers.getSigners();
    TicTacToe = await ethers.getContractFactory("TicTacToe", );
    ticTacToe = await TicTacToe.deploy(player2.address);
    await ticTacToe.deployed();
  });

  it("should allow players to make moves and determine the winner", async function () {
    await ticTacToe.connect(player1).makeMove(0, 0);
    await ticTacToe.connect(player2).makeMove(0, 1);
    await ticTacToe.connect(player1).makeMove(1, 1);
    await ticTacToe.connect(player2).makeMove(0, 2);
    await ticTacToe.connect(player1).makeMove(2, 2);

    expect(await ticTacToe.winner()).to.equal(player1.address);
  });

  it("should detect a draw", async function () {
    await ticTacToe.connect(player1).makeMove(0, 0);
    await ticTacToe.connect(player2).makeMove(0, 1);
    await ticTacToe.connect(player1).makeMove(0, 2);
    await ticTacToe.connect(player2).makeMove(1, 1);
    await ticTacToe.connect(player1).makeMove(1, 0);
    await ticTacToe.connect(player2).makeMove(1, 2);
    await ticTacToe.connect(player1).makeMove(2, 1);
    await ticTacToe.connect(player2).makeMove(2, 0);
    await ticTacToe.connect(player1).makeMove(2, 2);

    expect(await ticTacToe.winner()).to.equal(ethers.constants.AddressZero);
  });
});
