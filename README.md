# HabitHacker

:It is a dapp that helps users create habits. Users can create their own habits by participating in a pool to create specific habits

## deployed Address

| network        | explorer url(implement)                                                                          | explorer url(proxy)                                                                              |
| -------------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| alfajores      | https://alfajores.celoscan.io/address/0xbe169307a570E799d098d9884F565bf7E6821c36                 | https://alfajores.celoscan.io/address/0x02Dd2Eb340Bb12164D066fd8a18fe88851B4e778                 |
| linea          | https://explorer.goerli.linea.build/address/0xbe169307a570E799d098d9884F565bf7E6821c36/contracts | https://explorer.goerli.linea.build/address/0x02Dd2Eb340Bb12164D066fd8a18fe88851B4e778/contracts |
| scroll         | https://blockscout.scroll.io/address/0xbe169307a570E799d098d9884F565bf7E6821c36                  | https://blockscout.scroll.io/address/0x02Dd2Eb340Bb12164D066fd8a18fe88851B4e778                  |
| polygon mumbai | https://mumbai.polygonscan.com/address/0xbe169307a570E799d098d9884F565bf7E6821c36                | https://mumbai.polygonscan.com/address/0x02Dd2Eb340Bb12164D066fd8a18fe88851B4e778                |
| polygon zkevm  | https://testnet-zkevm.polygonscan.com/address/0x6e0d44023cD8f50fb04500Ea5b98B932fE332F66         | https://testnet-zkevm.polygonscan.com/address/0xc4D040B5Dee8B034429A767A10059b7a529E9F74         |

---

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

---

## Roadmap

In the future, we will support various chains so that they can use the services in their favorite chains
