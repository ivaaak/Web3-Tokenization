const mockContractData = {
    someValue: 100,
    someString: "Hello, World!",
    someArray: [1, 2, 3, 4, 5]
};

const mockContract = {
    getData: async () => mockContractData,
    someFunction: async () => {
        console.log("Mock transaction executed");
        return { wait: async () => { } };
    }
};

export default mockContract;