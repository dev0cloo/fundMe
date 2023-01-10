// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// creates a library
library PriceConverter {
     //uses Chainlink's interface to fetch the latest price of eth in usd
    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // typecasting to change int256 into uint256 because msg.value is in uint256
        // price is * 1e10 because price has 8 decimal places already but needs 10 more since 1 eth = 1e18 wei
        return uint256(price * 1e10);
    }

    // converts eth price to usd using data from getprice()
    function getConversionRate(uint256 ethAmount)
        internal
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
