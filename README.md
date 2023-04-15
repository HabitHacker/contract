# HabitHacker

:It is a dapp that helps users create habits. Users can create their own habits by participating in a pool to create specific habits

## deployed Address

0x91313139862D3FC25604d3e3a0C75e524733C958

- alfajores : 0x02Dd2Eb340Bb12164D066fd8a18fe88851B4e778(implement: 0xbe169307a570E799d098d9884F565bf7E6821c36)
  https://alfajores.celoscan.io/address/0xbe169307a570E799d098d9884F565bf7E6821c36#code
- linea : 0x02Dd2Eb340Bb12164D066fd8a18fe88851B4e778(implement: 0xbe169307a570E799d098d9884F565bf7E6821c36-verfied)
  https://explorer.goerli.linea.build/address/0xbe169307a570E799d098d9884F565bf7E6821c36/contracts#address-tabs
- scroll : 0x02Dd2Eb340Bb12164D066fd8a18fe88851B4e778(implement: 0xbe169307a570E799d098d9884F565bf7E6821c36-verfied)
  https://blockscout.scroll.io/address/0xbe169307a570E799d098d9884F565bf7E6821c36
- polygon mumbai : 0x02Dd2Eb340Bb12164D066fd8a18fe88851B4e778(implement: 0xbe169307a570E799d098d9884F565bf7E6821c36)
  https://mumbai.polygonscan.com/address/0xbe169307a570E799d098d9884F565bf7E6821c36#code
- polygon zkevm : 0xc4D040B5Dee8B034429A767A10059b7a529E9F74(implement: 0x6e0d44023cD8f50fb04500Ea5b98B932fE332F66)

---

## user flow

1. Manager creates a habit pool(meta transaction)
2. Users pay a certain amount to join a certain pool
3. The moderator validates the user's actions(meta transaction)
4. Manager runs the settlement function when the pool is finished (meta transaction)

## meaning

Structed data can move off-chain data to on-chain data more or less accurately through nodes such as Oracle and chainlink
It is not easy to validate unstructured data such as exercise and writing to the on-chain.
So we decided to solve this problem by using people's node, similar to nodes in a blockchain network, and we decided to call that person's node a modulator.

---

## Roadmap

In the future, we will support various chains so that they can use the services in their favorite chains
