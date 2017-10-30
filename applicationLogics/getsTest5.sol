	/* 어떤 형태의 function이 React Native에서 값을 받을수 있는지 테스트한다.
		1. 테스트 명 : function의 파라미터와 return을 다양한 type으로 테스트 한다.
		2. debugger-ui : 아래와 같은 형태로 리턴된다.
			(3) ["0x62624a3c27997cd612976b66b05b697bbc53d568", "rice", BigNumber]
			BigNumber {s: 1, e: 0, c: Array(1)}		
		3. React Native : 아래와 같은 형태로 접근한다.
			let aaa1 = result[0];
      let aaa2 = result[1];
      let aaa3 = result[2].c[0];
	*/
	
contract Simple {
    struct currentTx { // Struct
        address _txAddress;
				string _itemName;
        uint _addressIndex;
    }
	
    mapping(uint => currentTx) distributionChannelTable;

    function sendCurrentTx(address senderAddress, string itemName, uint addressIndex) public {
        distributionChannelTable[addressIndex] = currentTx(senderAddress, itemName, addressIndex);
    }
    function getTx(uint addressIndex) constant returns(address, string ,uint){	
				return (distributionChannelTable[addressIndex]._txAddress, distributionChannelTable[addressIndex]._itemName, distributionChannelTable[addressIndex]._addressIndex);
    }

}

