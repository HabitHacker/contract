import { ethers, upgrades } from "hardhat";

async function main() {
  if (!process.env.HABIT_HACKER_ADDRESS) return;
  const token = await ethers.getContractFactory("HabitHacker");
  const HabitHacker = await upgrades.upgradeProxy(
    process.env.HABIT_HACKER_ADDRESS,
    token,
    {
      pollingInterval: 1000,
      timeout: 0,
    }
  );
  console.log("HabitHacker deployed to:", HabitHacker.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
