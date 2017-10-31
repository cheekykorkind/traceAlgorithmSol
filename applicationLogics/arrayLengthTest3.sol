	/* React Native에서 promise.all을 실행이 목표다.
		1. 테스트 명 : primitive type dynamic array의 length return 받기 테스트
		2. debugger-ui : uint만 length return 가능하다. address, string 안된다.
			
		3. React Native : uint만 length return 가능하다. address, string 안된다.
			
		4. 알게된 점 : uint만 length return 가능하다. address, string, sturct 안된다.
	*/
	
contract Simple {

    address[] public _txAddress;
		string[] public _itemName;
    uint[] public _addressIndex;

    function sendCurrentTx() public {
        _txAddress.push(0x4795a5fdce6ee8dc10bb3177186dfad351ba3507);
        _itemName.push("rice");
        _addressIndex.push(22);
    }

    function getMappingLength() constant returns(uint, uint, uint){
        return (_txAddress.length, _itemName.length, _addressIndex.length);
    }
}

