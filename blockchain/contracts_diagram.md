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