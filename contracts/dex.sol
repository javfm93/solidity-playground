// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.3;
pragma experimental ABIEncoderV2;
import "./Wallet.sol";

contract Dex is Wallet {
    enum OrderType {
        BUY,
        SELL
    }

    struct Order {
        uint id;
        address trader;
        bool isBuyOrder;
        bytes32 ticker;
        uint amount;
        uint price;
    }

    mapping(bytes32 => mapping(OrderType => Order[])) orderBook;

    function getOrderBook(bytes32 ticker, OrderType orderType) public view returns(Order[] memory){
        return orderBook[ticker][orderType];
    }

    // function createLimitOrder() public {

    // }

}