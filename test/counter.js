const { expect } = require("chai");

describe("Counter", function () {
  it("Should increment and decrement the count correctly", async function () {
    const Counter = await ethers.getContractFactory("Counter");
    const counter = await Counter.deploy();
    await counter.deployed();

    await counter.inc();
    let count = await counter.get();
    expect(count).to.equal(1);

    await counter.dec();
    count = await counter.get();
    expect(count).to.equal(0);
  });

  it("Should fail when trying to decrement below 0", async function () {
    const Counter = await ethers.getContractFactory("Counter");
    const counter = await Counter.deploy();
    await counter.deployed();

    await expect(counter.dec()).to.be.reverted;
  });
});
