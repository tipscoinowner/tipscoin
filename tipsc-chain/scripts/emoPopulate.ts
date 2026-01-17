// scripts/demoPopulate.ts
// Basit bir “showcase” script’i:
// - TIPSC için başlangıç rezervini ayarlar
// - Bir miktar TIPSC mint eder
// - Reserve ratio ve health bilgisini log’lar

import { ethers } from "hardhat";

async function main() {
  const [deployer, council, riskCommittee, treasury] = await ethers.getSigners();

  console.log("Deployer:", await deployer.getAddress());
  console.log("Council:", await council.getAddress());
  console.log("RiskCommittee:", await riskCommittee.getAddress());
  console.log("Treasury:", await treasury.getAddress());

  // Deploy edilmiş adresleri buraya manuel veya .env üzerinden koyabilirsin
  const RESERVE_MANAGER_ADDRESS = "<DEPLOYED_RESERVE_MANAGER_ADDRESS>";
  const GOVERNANCE_ADDRESS = "<DEPLOYED_GOVERNANCE_ADDRESS>";
  const TIPSC_ADDRESS = "<DEPLOYED_TIPSC_ADDRESS>";

  const ReserveManager = await ethers.getContractFactory("ReserveManager");
  const Governance = await ethers.getContractFactory("Governance");
  const TIPSC = await ethers.getContractFactory("TIPSC");

  const reserveManager = ReserveManager.attach(RESERVE_MANAGER_ADDRESS);
  const governance = Governance.attach(GOVERNANCE_ADDRESS);
  const tipsc = TIPSC.attach(TIPSC_ADDRESS);

  // 1) Governance’a TIPSC adresini set et (eğer constructor’da set edilmediyse)
  const govCouncil = governance.connect(council);
  const txSetTIPSC = await govCouncil.setTIPSCAddress(TIPSC_ADDRESS);
  await txSetTIPSC.wait();
  console.log("TIPSC address set in Governance");

  // 2) Başlangıç rezervini ayarla (örnek: 1,000,000 birim backing)
  const initialReserves = ethers.parseUnits("1000000", 18);
  const txReserves = await govCouncil.updateReserves(initialReserves);
  await txReserves.wait();
  console.log("Initial reserves set:", initialReserves.toString());

  // 3) Treasury için bir miktar TIPSC mint et (örnek: 100,000 TIPSC)
  const tipscTreasury = tipsc.connect(treasury);
  const mintAmount = ethers.parseUnits("100000", 18);
  const txMint = await tipscTreasury.treasuryMint(mintAmount);
  await txMint.wait();
  console.log("Minted TIPSC to Treasury:", mintAmount.toString());

  // 4) Reserve ratio ve health bilgisini oku
  const reserveRatio = await reserveManager.getReserveRatio();
  const isHealthy = await reserveManager.isHealthy();

  console.log(
    "Reserve Ratio:",
    Number(ethers.formatUnits(reserveRatio, 18)) * 100,
    "%"
  );
  console.log("Is Healthy:", isHealthy);

  // 5) TIPSC balance’ını göster
  const treasuryBalance = await tipsc.balanceOf(await treasury.getAddress());
  console.log(
    "Treasury TIPSC Balance:",
    ethers.formatUnits(treasuryBalance, 18),
    "TIPSC"
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

