#  React + Express + Ethers.JS  -  Web3 Tokenization / Blockchain Demo
The project consists of:

### [Frontend: React ](https://github.com/ivaaak/Web3-Tokenization/tree/main/frontend)
  
### [Backend: Express + Ethers.js + Solidity + IPFS](https://github.com/ivaaak/Web3-Tokenization/tree/main/backend)

## Smart Contract Architecture / Diagram:
<img src="https://raw.githubusercontent.com/ivaaak/Web3-Tokenization/refs/heads/main/blockchain/contracts_diagram.png"></img>


```mermaid
graph TD
    subgraph "External Layer"
        F[<b>External Contracts/Users</b>]
    end

    subgraph "Diamond Core Layer"
        A[<b>Diamond Contract</b>: <br> fallback, receive, addFacet]
    end

    subgraph "Facet Layer"
        B[<b>DiamondCutFacet</b>: <br> diamondCut, addFunctions, replaceFunctions, removeFunctions]
        C[<b>DiamondLoupeFacet</b>: <br> facetAddress, facetFunctionSelectors, facetAddresses, facets]
        D[<b>TokenizationFacet</b>: <br> mintItem, getItem, tokenURI, totalSupply]
        E[<b>TradingFacet</b>: <br> createTrade, completeTrade, cancelTrade, getTrade]
    end

    F -->|Interacts| A
    A -->|Delegates calls| B & C & D & E
    B -->|Modifies| A
    C -->|Queries| A
    
    classDef external fill:#ffffff,stroke:#000000,stroke-width:2px;
    classDef core fill:#ffffff,stroke:#000000,stroke-width:4px;
    classDef facet fill:#ffffff,stroke:#000000,stroke-width:2px,stroke-dasharray: 5 5;
    
    class F external;
    class A core;
    class B,C,D,E facet;

    linkStyle default stroke:#000000,stroke-width:1px;
```

## Project Startup:
You can run the below commands from the main directory and start the project:

```cmd
npm i
npm start
```

This installs and starts both the FE and BE using the npm tool 'concurrently'. Or you can run the commands separately in the frontend / backend folders to have them running in separate instances/terminals.

### Built With:
-  [**✔**]  `React (Vite, Typescript)`
-  [**✔**]  `Express API`
- [**✔**]  `Ethers.js`
-  [**✔**]  `Auth0`
-  [**✔**]  `Axios`
-  [**✔**]  `MongoDB`
-  [**✔**]  `Stripe`
