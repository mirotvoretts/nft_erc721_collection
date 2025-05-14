# Ursa Pixels :: NFT Collection

[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Solidity](https://img.shields.io/badge/Solidity-363636?style=for-the-badge&logo=solidity&logoColor=white)](https://soliditylang.org/)
[![Foundry](https://img.shields.io/badge/Foundry-F76802?style=for-the-badge&logo=ethereum&logoColor=white)](https://getfoundry.sh/)
[![Ethereum](https://img.shields.io/badge/Ethereum-3C3C3D?style=for-the-badge&logo=ethereum&logoColor=white)](https://ethereum.org/)
[![IPFS](https://img.shields.io/badge/IPFS-65C2CB?style=for-the-badge&logo=ipfs&logoColor=white)](https://ipfs.tech/)
[![OpenZeppelin](https://img.shields.io/badge/OpenZeppelin-4E5EE4?style=for-the-badge&logo=OpenZeppelin&logoColor=white)](https://openzeppelin.com/)

Коллекция пиксельных медведей, реализованная на стандарте **ERC721**

## Технические характеристики

- **Стандарт**: ERC721
- **Блокчейн**: Ethereum (Sepolia testnet)
- **Язык**: Solidity 0.8.28
- **Фреймворк**: Foundry
- **Библиотеки**: OpenZeppelin Contracts

## Функционал

### Основные функции
- `mint(uint256 amount, address recipient)` - создание NFT
  - Цена: 0.001 ETH за токен
  - Лимиты:
    - Макс. 3 токена за транзакцию
    - Макс. 6 токенов на кошелёк
    - Общий supply: 100 токенов

- `withdraw(uint256 amount, address payable recipient)` - вывод средств
  - Только для владельца контракта

### Атрибуты NFT (генерируются случайно)
| Категория   | Варианты (вероятность)                  |
|-------------|----------------------------------------|
| Clothes     | Jacket (45%), Suit (25%), Military (10%), Empty (20%) |
| Hair        | Fade (30%), Mohawk (25%), Box (35%), Empty (10%) |
| Boots       | Nike (40%), Adidas (20%), New Balance (10%), Empty (30%) |

## Установка и запуск

1. Клонируйте репозиторий:
```bash
git clone git@github.com:mirotvoretts/nft_erc721_collection.git
cd nft_erc721_collection
```

2. Установите зависимости

```bash
forge install
npm install @pinata/sdk
```

3. Сгенерируйте метаданные
   
```bash
ts-node script/GenerateMetadata.ts
```

> Далее загружаете метаданные на IPFS и делаете деплой

## Тестирование

```bash
forge test
```

#### Покрытие тестами:

- Минтинг токенов
- Проверка лимитов
- Тесты withdraw

