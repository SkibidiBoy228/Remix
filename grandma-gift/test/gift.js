const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("GiftForGrandchildren", function () {

  let contract;
  let grandma, child1, child2, stranger;

  beforeEach(async function () {
    [grandma, child1, child2, stranger] = await ethers.getSigners();

    const Gift = await ethers.getContractFactory("GiftForGrandchildren");
    contract = await Gift.connect(grandma).deploy();
  });

  it("Grandma deploys, adds grandchildren and deposits", async function () {

    const now = (await ethers.provider.getBlock("latest")).timestamp;

    await contract.connect(grandma).addGrandchild(child1.address, now);
    await contract.connect(grandma).addGrandchild(child2.address, now);

    await contract.connect(grandma).deposit({
      value: ethers.parseEther("2")
    });

    expect(await contract.getGrandchildrenCount()).to.equal(2);
  });

  it("Deposit divides correctly", async function () {

    const now = (await ethers.provider.getBlock("latest")).timestamp;

    await contract.connect(grandma).addGrandchild(child1.address, now);
    await contract.connect(grandma).addGrandchild(child2.address, now);

    await contract.connect(grandma).deposit({
      value: ethers.parseEther("2")
    });

    expect(await contract.giftPerChild()).to.equal(
      ethers.parseEther("1")
    );
  });

  it("Withdraw on birthday works", async function () {

    const now = (await ethers.provider.getBlock("latest")).timestamp;

    await contract.connect(grandma).addGrandchild(child1.address, now);

    await contract.connect(grandma).deposit({
      value: ethers.parseEther("1")
    });

    await expect(contract.connect(child1).withdraw())
      .to.emit(contract, "Withdraw")
      .withArgs(child1.address, ethers.parseEther("1"));
  });

  it("Withdraw after birthday works", async function () {

    const now = (await ethers.provider.getBlock("latest")).timestamp;

    await contract.connect(grandma).addGrandchild(child1.address, now - 100);

    await contract.connect(grandma).deposit({
      value: ethers.parseEther("1")
    });

    await expect(contract.connect(child1).withdraw())
      .to.emit(contract, "Withdraw")
      .withArgs(child1.address, ethers.parseEther("1"));
  });

  it("Withdraw before birthday fails", async function () {

    const now = (await ethers.provider.getBlock("latest")).timestamp;

    await contract.connect(grandma).addGrandchild(child1.address, now + 1000);

    await contract.connect(grandma).deposit({
      value: ethers.parseEther("1")
    });

    await expect(
      contract.connect(child1).withdraw()
    ).to.be.revertedWith("Too early");
  });

  it("Double withdraw fails", async function () {

    const now = (await ethers.provider.getBlock("latest")).timestamp;

    await contract.connect(grandma).addGrandchild(child1.address, now);

    await contract.connect(grandma).deposit({
      value: ethers.parseEther("1")
    });

    await contract.connect(child1).withdraw();

    await expect(
      contract.connect(child1).withdraw()
    ).to.be.revertedWith("Already withdrawn");
  });

  it("Stranger cannot withdraw", async function () {

    await expect(
      contract.connect(stranger).withdraw()
    ).to.be.revertedWith("Not grandchild");
  });

});
