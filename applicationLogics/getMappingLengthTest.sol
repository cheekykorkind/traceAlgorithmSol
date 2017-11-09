	/* 
		1. 테스트 명 : React Native에서 getMappingLength 값 가져오기
		2. debugger-ui : BigNumber {s: 1, e: 0, c: Array(1)}
			
		3. React Native : console.log(result.c[0]);
				
		4. 알게된 점 : sendCurrentTx가 채굴될때까지 기다려야 정상값이 나온다.
	*/
	
pragma solidity ^0.4.0;
contract DistributionChannelTrace {
    struct currentTx {  //  현 시점에서 일어난 도매업자간의 거래를 의미하는 자료구조이다.
        // string _txIndex;
        // address _sellerAddr;
        // address _buyerAddr;
        // string _itemName;
        // uint _volum;
        uint _totalPrice;
        string _date;
    }

    mapping(uint => currentTx[]) public distributionChannelTable;

    function sendCurrentTx(uint totalPrice, string date) public {
        distributionChannelTable[0].push(currentTx(totalPrice,date));
    }

    // tx 1개 get
	function getTx(uint arrayIndex, uint stackIndex) public constant returns(uint, string){
		currentTx a = distributionChannelTable[arrayIndex][stackIndex];
		return (
		  //  a._txIndex,
		  //  a._sellerAddr,
		  //  a._buyerAddr,
		  //  a._itemName,
		  //  a._volum,
		    a._totalPrice,
		    a._date
		);
	}
	
	// mapping의 최대 길이를 구한다.
	function getMappingLength() public constant returns (uint){
        uint mappingLength;
	    while(distributionChannelTable[mappingLength].length != 0 ){ //  스택의 길이가 0이기 전까지가 mapping의 최대 길이이다.
            mappingLength++;
        }
        return mappingLength;
	}
	
	// 유통 경로 테이블이 비었는가?
	function isTableEmpty() public constant returns (bool){
        if(distributionChannelTable[0].length == 0){
            return true;    //  비었다.
        }else{
            return false;   //  Tx가 있다.
        }
	}
}

