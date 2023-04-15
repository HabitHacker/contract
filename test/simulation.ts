import { loadFixture, time } from "@nomicfoundation/hardhat-network-helpers";
import { ethers, upgrades } from "hardhat";

describe("simulation", function () {
  async function deploySetting() {
    const [
      owner,
      account1,
      account2,
      account3,
      relayer,
      manager,
      moderator1,
      moderator2,
    ] = await ethers.getSigners();
    const hackerToken = await ethers.getContractFactory("HabitHacker");
    const HabitHacker = await upgrades.deployProxy(hackerToken, [
      ethers.utils.parseEther("500"),
      2,
    ]);
    await HabitHacker.deployed();

    const collectionToken = await ethers.getContractFactory("HabitCollection");
    const HabitCollection = await collectionToken.deploy(HabitHacker.address);
    await HabitCollection.deployed();

    await HabitHacker.updateCollectionTemplate(HabitCollection.address);

    return {
      owner,
      account1,
      account2,
      account3,
      moderator1,
      moderator2,
      manager,
      HabitHacker,
      relayer,
    };
  }
  it("goal should work", async function () {
    const {
      owner,
      account1,
      account2,
      account3,
      HabitHacker,
      relayer,
      moderator1,
      moderator2,
      manager,
    } = await loadFixture(deploySetting);
    const habitId = 1;
    //role setting
    await HabitHacker.addManager(manager.address);
    await HabitHacker.addRelayer(relayer.address);

    const registerHash1 = ethers.utils.solidityKeccak256(
      ["uint256"],
      [BigInt(moderator1.address)]
    );

    const registerSignature1 = await relayer.signMessage(
      ethers.utils.arrayify(registerHash1)
    );
    await HabitHacker.connect(moderator1).registerModerator(
      registerSignature1,
      { value: ethers.utils.parseEther("500") }
    );

    const resisterHash2 = ethers.utils.solidityKeccak256(
      ["uint256"],
      [BigInt(moderator2.address)]
    );
    const registerSignature2 = await relayer.signMessage(
      ethers.utils.arrayify(resisterHash2)
    );
    await HabitHacker.connect(moderator2).registerModerator(
      registerSignature2,
      { value: ethers.utils.parseEther("500") }
    );

    console.log("owner balance:", await owner.getBalance());
    console.log("account1 balance:", await account1.getBalance());
    const account1Before = await account1.getBalance();
    console.log("account2 balance:", await account2.getBalance());
    const account2Before = await account2.getBalance();
    console.log("account3 balance:", await account3.getBalance());
    const account3Before = await account3.getBalance();
    console.log("moderator1 balance:", await moderator1.getBalance());
    console.log("moderator2 balance:", await moderator2.getBalance());
    console.log("relayer balance:", await relayer.getBalance());
    console.log(
      "contract balance:",
      await ethers.provider.getBalance(HabitHacker.address)
    );
    const contractBefore = await ethers.provider.getBalance(
      HabitHacker.address
    );
    console.log("====================================");

    //habit setting
    const currentBlocktimestamp = (
      await ethers.provider.getBlock(await ethers.provider.getBlockNumber())
    ).timestamp;

    await HabitHacker.connect(owner).habitSetting(
      habitId,
      ethers.utils.parseEther("100"),
      ethers.utils.parseEther("10"),
      100,
      50,
      7,
      5,
      currentBlocktimestamp,
      currentBlocktimestamp + 1000,
      "habitCollection1",
      "http://localhost:3000/img/habitCollection1"
    );

    //participate
    await HabitHacker.connect(account1).participate(habitId, {
      value: ethers.utils.parseEther("100"),
    });

    await HabitHacker.connect(account2).participate(habitId, {
      value: ethers.utils.parseEther("50"),
    });
    await HabitHacker.connect(account3).participate(habitId, {
      value: ethers.utils.parseEther("10"),
    });

    console.log("owner balance:", await owner.getBalance());
    console.log("account1 balance:", await account1.getBalance());
    console.log("account2 balance:", await account2.getBalance());
    console.log("account3 balance:", await account3.getBalance());
    console.log("moderator1 balance:", await moderator1.getBalance());
    const moderator1Before = await moderator1.getBalance();
    console.log("moderator2 balance:", await moderator2.getBalance());
    const moderator2Before = await moderator2.getBalance();
    console.log("relayer balance:", await relayer.getBalance());
    const relayerBefore = await relayer.getBalance();
    console.log(
      "contract balance:",
      await ethers.provider.getBalance(HabitHacker.address)
    );
    console.log("====================================");

    //verify
    await HabitHacker.connect(relayer).verify(moderator1.address, [
      [habitId, account1.address, 1],
      [habitId, account1.address, 2],
      [habitId, account1.address, 3],
      [habitId, account1.address, 4],
      [habitId, account1.address, 5],
      [habitId, account1.address, 6],
      [habitId, account1.address, 7],
    ]);
    await HabitHacker.connect(relayer).verify(moderator2.address, [
      [habitId, account2.address, 1],
      [habitId, account2.address, 2],
      [habitId, account2.address, 3],
      [habitId, account2.address, 4],
      [habitId, account2.address, 5],
      [habitId, account3.address, 1],
      [habitId, account3.address, 2],
      [habitId, account3.address, 3],
    ]);

    //settle winner
    await time.increase(currentBlocktimestamp + 1001);

    await HabitHacker.settleWinner(1);

    console.log("owner balance:", await owner.getBalance());
    console.log("account1 balance:", await account1.getBalance());
    const account1After = await account1.getBalance();
    console.log("account2 balance:", await account2.getBalance());
    const account2After = await account2.getBalance();
    console.log("account3 balance:", await account3.getBalance());
    const account3After = await account3.getBalance();
    console.log("moderator1 balance:", await moderator1.getBalance());
    const moderator1After = await moderator1.getBalance();
    console.log("moderator2 balance:", await moderator2.getBalance());
    const moderator2After = await moderator2.getBalance();
    console.log("relayer balance:", await relayer.getBalance());
    const relayerAfter = await relayer.getBalance();
    console.log(
      "contract balance:",
      await ethers.provider.getBalance(HabitHacker.address)
    );
    const contractAfter = await ethers.provider.getBalance(HabitHacker.address);
    console.log("====================================");

    //calculate reward
    console.log(
      "relayer used gas fee:",
      ethers.utils.formatEther(relayerBefore.sub(relayerAfter))
    );
    console.log(
      "contract balance change:",
      ethers.utils.formatEther(contractAfter.sub(contractBefore))
    );
    console.log(
      "our benefit:",
      ethers.utils.formatEther(
        contractAfter.sub(contractBefore).sub(relayerBefore.sub(relayerAfter))
      )
    );
    console.log(
      "moderator1 benefit:",
      ethers.utils.formatEther(moderator1After.sub(moderator1Before))
    );
    console.log(
      "moderator2 benefit:",
      ethers.utils.formatEther(moderator2After.sub(moderator2Before))
    );
    console.log(
      "account1 benefit:",
      ethers.utils.formatEther(account1After.sub(account1Before))
    );
    console.log(
      "account2 benefit:",
      ethers.utils.formatEther(account2After.sub(account2Before))
    );
    console.log(
      "account3 benefit:",
      ethers.utils.formatEther(account3After.sub(account3Before))
    );
  });
});
