const { expect } = require("chai");

describe("Messaging contract", () => {
    let Messaging, messaging, ac1, ac2, acs;

    beforeEach(async () => {
        Messaging = await ethers.getContractFactory("Messaging");
        messaging = await Messaging.deploy();
        [ac1, ac2, ...acs] = await ethers.getSigners();
    });

    describe("Deployment", () => {
        it("Deploys Successfully", async () => {
            const address = await messaging.address;
            expect(address).to.be.a("string");
        });
    });

    describe("Messages", () => {
        it("Send Message", async () => {
            await messaging.sendMessage("ipfs://", ac2.address);
            const messageCount = await messaging.messageCount();
            expect(messageCount).to.be.equal(1);
        });

        it("All Messages", async () => {
            await messaging.sendMessage("ipfs://", ac2.address);
            await messaging.sendMessage("ipfs://", ac2.address);
            await messaging.sendMessage("ipfs://", ac2.address);
            await messaging.sendMessage("ipfs://", ac2.address);

            const allMessages = await messaging.allMessages(ac2.address);
            expect(allMessages.length).to.be.equal(4);
        });

        it("Message URI", async () => {
            await messaging.sendMessage("ipfs://", ac2.address);

            const msgURI = await messaging.messageURI(1);
            expect(msgURI).to.be.a("string");
        });
    });
});