contract DistributionChannelTrace {

    struct currentTx {  //  현 시점에서 일어난 도매업자간의 거래를 의미하는 자료구조이다.
        address txIndex;
        address sellerAddr;
        address buyerAddr;
        string itemName;
        uint volum;
        uint totalPrice;
        string date;
    }
	
	//  유통 경로 1개당 stack 1개를 만들면서 유통 경로 추적을 가능하게 하는 자료구조이다.
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
    
    // 저장된 array의 길이를 각각 체크한다. 디버깅용
    function getStackLength() public returns(uint stack1Length, uint stack2Length){
        // r_txAddress = distributionChannelTable[_a][_b].txAddress;
        // r_addressIndex = distributionChannelTable[_a][_b].addressIndex;
        stack1Length = distributionChannelTable[0xd5ff82c1ec6f6f834ec5b3ce9a039fa6fe86f40d].length;
        stack2Length = distributionChannelTable[0x960f751f23be02a2e5c31dbb4ff3ca47437e9611].length;
    }
		
		// return이 0이면 존재하지 않는다고 간주한다.
		function isTableEmpty(address _a) public returns (uint _length){
			_length = distributionChannelTable[_a].length;
		}
}
