contract Simple {
	// Dynamic struct array type을 mapping에 적용하기

    struct currentTx { // Struct
        address txAddress;
        uint addressIndex;
    }
	
    mapping(address => currentTx[]) distributionChannelTable;
		
        
    function sendCurrentTx(address _senderAddress, uint _b) public returns (address _txAddress, uint _addressIndex) {
        distributionChannelTable[_senderAddress].push(currentTx(_senderAddress, _b));
        _txAddress = _senderAddress;
        _addressIndex = _b;
    }
    function getTx(address _a, uint _b) public returns(address r_txAddress, uint r_addressIndex){
        r_txAddress = distributionChannelTable[_a][_b].txAddress;
        r_addressIndex = distributionChannelTable[_a][_b].addressIndex;
    }
    
    // 저장된 array의 길이를 각각 체크한다.
    function getStackLength() public returns(uint stack1Length, uint stack2Length){
        // r_txAddress = distributionChannelTable[_a][_b].txAddress;
        // r_addressIndex = distributionChannelTable[_a][_b].addressIndex;
        stack1Length = distributionChannelTable[0xd5ff82c1ec6f6f834ec5b3ce9a039fa6fe86f40d].length;
        stack2Length = distributionChannelTable[0x960f751f23be02a2e5c31dbb4ff3ca47437e9611].length;
    }
}
