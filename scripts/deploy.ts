import { ethers, upgrades } from "hardhat";

async function main() {
  const token = await ethers.getContractFactory("HabitHacker");
  console.log(await token.signer.provider?.getNetwork());

  const HabitHacker = await upgrades.deployProxy(token, [
    ethers.utils.parseEther("500"),
    2,
  ]);
  await HabitHacker.deployed();
  console.log("HabitHacker deployed to:", HabitHacker.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
