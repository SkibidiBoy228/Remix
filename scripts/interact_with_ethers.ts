import { ethers } from "hardhat";

async function main() {

    // ВСТАВЬ адрес своего контракта после deploy
    const contractAddress = "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4";

    const contract = await ethers.getContractAt(
        "ProductStorage",
        contractAddress
    );

    console.log("Connected to contract:", contractAddress);

    // Добавить продукт
    const tx = await contract.addProduct(
        "iPhone 15",
        "Apple smartphone",
        "https://example.com/iphone.jpg"
    );

    await tx.wait();

    console.log("Product added");

    // Получить количество продуктов
    const count = await contract.getProductsCount();

    console.log("Products count:", count.toString());

    // Получить первый продукт
    const product = await contract.getProduct(0);

    console.log("Product 0:");

    console.log("Name:", product[0]);
    console.log("Description:", product[1]);
    console.log("Owner:", product[2]);
    console.log("CreatedAt:", product[3].toString());
    console.log("ImageURL:", product[4]);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});