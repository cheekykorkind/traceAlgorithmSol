	/* React Native에서 promise.all을 실행이 목표다.
		1. 테스트 명 : currentTx[]의 length return 받기
		2. debugger-ui : 값을 못받아 오지만, 아래와 같은 형태로 리턴된다.
			BigNumber {s: 1, e: 0, c: Array(1)}
		3. React Native : 값을 못받아 온다.
			
		4. 알게된 점 : struct 동적 배열은 length를 못받는다. primitive type만 동적 배열 길이가 반환 가능한걸로 추정된다.
	*/
	
contract Simple {
    struct currentTx { // Struct
        // address _txAddress;
		string _itemName;
        uint _addressIndex;
    }
    currentTx[] public distributionChannelTable;

    function sendCurrentTx() public {
        distributionChannelTable.push(currentTx("rice", 0));
        distributionChannelTable.push(currentTx("rice", 1));
        distributionChannelTable.push(currentTx("rice", 2));
        distributionChannelTable.push(currentTx("rice", 3));
        distributionChannelTable.push(currentTx("rice", 4));
    }

    function getMappingLength() constant returns(uint){
        return distributionChannelTable.length;
    }
}

