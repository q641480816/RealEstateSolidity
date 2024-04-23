// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SellOrderBook is ReentrancyGuard, Ownable {
    struct Order {
        uint256 id;
        address seller;
        address token;
        uint256 amount;
        uint256 pricePerToken; // price in SSGD
        uint256 timestamp;
    }

    struct TradeHistory {
        uint256 id;
        address seller;
        address buyer;
        address token;
        uint256 amount;
        uint256 pricePerToken;
        uint256 timestamp;
    }

    Order[] public orders;
    TradeHistory[] public histories;
    uint256 public nextOrderId = 0;
    IERC20 public ssgdToken; // The SSGD token interface
    mapping(address => bool) public allowedTokens;

    event OrderPlaced(
        uint256 id,
        address seller,
        address token,
        uint256 amount,
        uint256 pricePerToken
    );
    event OrderCancelled(uint256 id);
    event OrderFulfilled(uint256 id, address buyer, uint256 amount);

    constructor(address _ssgdTokenAddress) {
        ssgdToken = IERC20(_ssgdTokenAddress); // Initialize the SSGD token contract
    }

    function allowToken(address token, bool isAllowed) external onlyOwner {
        allowedTokens[token] = isAllowed;
    }

    function placeOrder(
        address token,
        uint256 amount,
        uint256 pricePerToken
    ) external nonReentrant {
        require(token != address(ssgdToken), "Cannot sell SSGD directly"); // Prevent selling SSGD itself
        require(amount > 0, "Amount must be greater than 0");
        require(pricePerToken > 0, "Price must be greater than 0");

        IERC20(token).transferFrom(msg.sender, address(this), amount);

        orders.push(
            Order({
                id: nextOrderId,
                seller: msg.sender,
                token: token,
                amount: amount,
                pricePerToken: pricePerToken,
                timestamp: block.timestamp
            })
        );

        emit OrderPlaced(nextOrderId, msg.sender, token, amount, pricePerToken);
        nextOrderId++;
    }

    function cancelOrder(uint256 orderId) external nonReentrant {
        require(orderId < orders.length, "Invalid order ID");
        Order storage order = orders[orderId];
        require(msg.sender == order.seller, "Only seller can cancel");

        IERC20(order.token).transfer(order.seller, order.amount);
        emit OrderCancelled(orderId);

        delete orders[orderId];
    }

    function fulfillOrder(
        uint256 orderId,
        uint256 amount
    ) external nonReentrant {
        require(orderId < orders.length, "Invalid order ID");
        Order storage order = orders[orderId];
        require(amount <= order.amount, "Insufficient order amount available");

        uint256 totalCost = amount * order.pricePerToken;
        ssgdToken.transferFrom(msg.sender, order.seller, totalCost);
        IERC20(order.token).transfer(msg.sender, amount);

        emit OrderFulfilled(orderId, msg.sender, amount);

        histories.push(
            TradeHistory({
                id: orderId,
                seller: order.seller,
                buyer: msg.sender,
                token: order.token,
                amount: order.amount,
                pricePerToken: order.pricePerToken,
                timestamp: block.timestamp
            })
        );

        if (order.amount == 0) {
            delete orders[orderId];
        }
    }

    function getOrdersBySeller(
        address seller
    ) external view returns (Order[] memory) {
        uint256 totalOrders = orders.length;
        uint256 count = 0;

        for (uint256 i = 0; i < totalOrders; i++) {
            if (orders[i].seller == seller) {
                count++;
            }
        }

        Order[] memory sellerOrders = new Order[](count);
        uint256 j = 0;
        for (uint256 i = 0; i < totalOrders; i++) {
            if (orders[i].seller == seller) {
                sellerOrders[j] = orders[i];
                j++;
            }
        }

        return sellerOrders;
    }

    function getHistoryByAddress(
        address addr
    ) external view returns (TradeHistory[] memory) {
        uint256 totalHis = histories.length;
        uint256 count = 0;

        for (uint256 i = 0; i < totalHis; i++) {
            if (histories[i].seller == addr || histories[i].buyer == addr) {
                count++;
            }
        }

        TradeHistory[] memory addrHistories = new TradeHistory[](count);
        uint256 j = 0;
        for (uint256 i = 0; i < totalHis; i++) {
            if (histories[i].seller == addr || histories[i].buyer == addr) {
                addrHistories[j] = histories[i];
                j++;
            }
        }

        return addrHistories;
    }
}
