[![Mentioned in Awesome Foundry](https://awesome.re/mentioned-badge-flat.svg)](https://github.com/crisgarner/awesome-foundry)
# Foundry + Hardhat Diamonds

This is a mimimal template for [Diamonds](https://github.com/ethereum/EIPs/issues/2535) which allows facet selectors to be generated on the go in solidity tests!

## Installation

- Clone this repo
- Install dependencies

```bash
$ yarn && forge update
```

### Compile

```bash
$ npx hardhat compile
```

## Deployment

### Hardhat

```bash
$ npx hardhat run scripts/deploy.js
```

### Foundry

```bash
$ forge t
```

`Note`: A lot of improvements are still needed so contributions are welcome!!

Bonus: The [DiamondLoupefacet](contracts/facets/DiamondLoupeFacet.sol) uses an updated [LibDiamond](contracts/libraries//LibDiamond.sol) which utilises solidity custom errors to make debugging easier especially when upgrading diamonds. Take it for a spin!!

Need some more clarity? message me [on twitter](https://twitter.com/Timidan_x), Or join the [EIP-2535 Diamonds Discord server](https://discord.gg/kQewPw2)


DiamondCutFacet deployed: 0xE57Be2Dd8c5Ed6330d2914646a8889Dbf8fc842A
Diamond deployed: 0xEF8a433415678d075e0A42FbD7A6fd07e79090c5
DiamondInit deployed: 0x0555c61C42e52B14eBa7F390B61292c3a230C466

Deploying facets
DiamondLoupeFacet deployed: 0xc7b7D49aE778086ABE12A4f9b3549bC09A4499de
OwnershipFacet deployed: 0x75cC31EE1c3377125Ff7215b4520BB74543f11D7
TestFacet deployed: 0xD1E7A4fD0c3e19705aE6D6C0D02322bC309A11BB