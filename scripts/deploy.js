const main = async () => {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Messaging = await ethers.getContractFactory("Messaging");
    const messaging = await Messaging.deploy();

    console.log("Contract address:", messaging.address);
}

main().then(() => process.exit(0)).catch((error) => {
    console.error(error);
    process.exit(1);
})