import { ethers, upgrades } from "hardhat";

async function main() {
  const hackerToken = await ethers.getContractFactory("HabitHacker");
  console.log(await hackerToken.signer.provider?.getNetwork());

  const HabitHacker = await upgrades.deployProxy(hackerToken, [
    ethers.utils.parseEther("500"),
    2,
  ]);
  await HabitHacker.deployed();

  const collectionToken = await ethers.getContractFactory("HabitCollection");
  const HabitCollection = await collectionToken.deploy(HabitHacker.address);
  await HabitCollection.deployed();

  console.log("HabitHacker deployed to:", HabitHacker.address);

  await HabitHacker.updateCollectionTemplate(HabitCollection.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
