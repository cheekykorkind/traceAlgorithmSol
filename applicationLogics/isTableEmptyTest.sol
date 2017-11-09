	/* 
		1. 테스트 명 : React Native에서 isTableEmpty 값 가져오기
		2. debugger-ui : false
			
		3. React Native : false
				
		4. 알게된 점 : 성공했다. 그러나 sendCurrentTx() 채굴되기 전까지 true로 나오는점은 주의하자
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
	
	// 유통 경로 테이블이 비었는가?
	function isTableEmpty() public constant returns (bool){
        if(distributionChannelTable[0].length == 0){
            return true;    //  비었다.
        }else{
            return false;   //  Tx가 있다.
        }
	}
}

