contract Simple {
	// solidity 파라미터 선언은 address type으로하고 실제 파라미터는 string으로 넣어도 동작한다.

    struct currentTx { // Struct
        address txAddress;
        uint addressIndex;
    }
		
    mapping(address => currentTx) public distributionChannelTable;
        
    function setTx(address _a, uint _b) payable returns (address _txAddress, uint _addressIndex) {
        distributionChannelTable[_a] = currentTx(_a, _b);
        _txAddress = _a;
        _addressIndex = _b;
    }
    function getTx(address _a) returns(address r_txAddress, uint r_addressIndex){
        r_txAddress = distributionChannelTable[_a].txAddress;
        r_addressIndex = distributionChannelTable[_a].addressIndex;
    }
}