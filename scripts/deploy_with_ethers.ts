import { ethers } from "hardhat";

async function main() {

    console.log("Deploying ProductStorage...");

    const ProductStorage = await ethers.getContractFactory("ProductStorage");

    const productStorage = await ProductStorage.deploy();

    await productStorage.waitForDeployment();

    const address = await productStorage.getAddress();

    console.log("ProductStorage deployed to:", address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});