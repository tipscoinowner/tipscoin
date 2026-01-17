const TIPSC = await ethers.getContractFactory("TIPSC");

const tipsc = await TIPSC.deploy(
  await reserveManager.getAddress(),
  await governance.getAddress(),
  await treasury.getAddress()
);

console.log("TIPSC:", await tipsc.getAddress());
