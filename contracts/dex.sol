// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.3;
pragma experimental ABIEncoderV2;
import "./Wallet.sol";

contract Dex is Wallet {
    using SafeMath for uint256;

    enum OrderType {
        BUY,
        SELL
    }

    struct Order {
        uint id;
        address trader;
        OrderType orderType;
        bytes32 ticker;
        uint amount;
        uint price;
    }

    uint public nextOrderId = 0;
    // what have bigger gas fees, mapping of a mapping or independant mappings?
    // is a public variable modifiable from outside?
    mapping(bytes32 => Order[]) public buyOrderBook;
    // mapping(bytes32 => Order[]) public sellOrderBook;
    function createBuyLimitOrder(bytes32 ticker, uint256 amount, uint256 price) public {
        require(balances[msg.sender]["ETH"] >= amount.mul(price), "Not enough ETH balance to buy");
        Order[] storage orders = buyOrderBook[ticker];
        orders.push(Order(nextOrderId++, msg.sender, OrderType.BUY, ticker, amount, price));

        uint i = orders.length > 0 ? orders.length - 1 : 0;
        while(i > 0){
            if(orders[i - 1].price > orders[i].price) {
                break;
            }
            Order memory orderToMove = orders[i - 1];
            orders[i - 1] = orders[i];
            orders[i] = orderToMove;
            i--;
        }
    }

    // function createSellLimitOrder(bytes32 ticker, uint256 amount, uint256 price) public {
    //     require(balances[msg.sender][ticker] >= amount, "Not enough tokens to sell");

    //     Order[] storage orders = orderBook[ticker][OrderType.SELL];
    //     orders.push(Order(nextOrderId++, msg.sender, OrderType.SELL, ticker, amount, price));

    //     uint i = orders.length > 0 ? orders.length - 1 : 0;
    //     while(i > 0){
    //         if(orders[i - 1].price < orders[i].price) {
    //             break;
    //         }
    //         Order memory orderToMove = orders[i - 1];
    //         orders[i - 1] = orders[i];
    //         orders[i] = orderToMove;
    //         i--;
    //     }
    // }
}