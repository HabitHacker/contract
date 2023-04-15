# HabitHacker

:It is a dapp that helps users create habits. Users can create their own habits by participating in a pool to create specific habits

## deployed Address

| network        | explorer url(implement)                                                                          | explorer url(proxy)                                                                              |
| -------------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| alfajores      | https://alfajores.celoscan.io/address/0x555639b2B3aB17dB0eF71c41CF4B98607df17Ff4#code            | https://alfajores.celoscan.io/address/0x94229E54d15150e024C7bBa731b86d25f8A18345                 |
| linea          | https://explorer.goerli.linea.build/address/0x555639b2B3aB17dB0eF71c41CF4B98607df17Ff4/contracts | https://explorer.goerli.linea.build/address/0x94229E54d15150e024C7bBa731b86d25f8A18345/contracts |
| scroll         | https://blockscout.scroll.io/address/0x555639b2B3aB17dB0eF71c41CF4B98607df17Ff4                  | https://blockscout.scroll.io/address/0x94229E54d15150e024C7bBa731b86d25f8A18345                  |
| polygon mumbai | https://mumbai.polygonscan.com/address/0x555639b2B3aB17dB0eF71c41CF4B98607df17Ff4                | https://mumbai.polygonscan.com/address/0x94229E54d15150e024C7bBa731b86d25f8A18345                |
| polygon zkevm  | https://testnet-zkevm.polygonscan.com/address/0x6aA8Ffd2a312DF1B0b65b3d1d4b614BF1553b9eB         | https://testnet-zkevm.polygonscan.com/address/0x4Bfdfa58a3fF7B09460e4Df49B14ce494Ac0De58         |

- polygon twitter : https://twitter.com/joe_altava/status/1647128633142833152?s=20

## contract

<img width="497" alt="스크린샷 2023-04-15 19 20 34" src="https://user-images.githubusercontent.com/97350083/232208107-9b245f7c-d2d2-4925-a1cc-e989e8eeef68.png">

- HabitHacker
  : Final deployed contract that contain important actions such as participation, verification, and settlement and multiple get functions
- HabitCore
  : A contact that contains most of the data and contains logic that changes the settings
- HabitCollectionFactory
  :A contract that contains logic that deploys nft collections that can be received when successful
- RoleController
  :Contract to manage roles such as admin, manager, moderator and relayer

## user flow

1. Manager creates a habit pool(meta transaction)
2. Users pay a certain amount to join a certain pool
3. The moderator validates the user's actions(meta transaction)
4. Manager runs the settlement function when the pool is finished (meta transaction)

## meaning

Structed data can move off-chain data to on-chain data more or less accurately through nodes such as Oracle and chainlink
It is not easy to validate unstructured data such as exercise and writing to the on-chain.
So we decided to solve this problem by using people's node, similar to nodes in a blockchain network, and we decided to call that person's node a modulator.

## Roadmap

In the future, we will support various chains so that they can use the services in their favorite chains
