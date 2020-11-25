interface IPriceFeed {
    function getUnderlyingPrice(address cToken) external view returns (uint);
}
