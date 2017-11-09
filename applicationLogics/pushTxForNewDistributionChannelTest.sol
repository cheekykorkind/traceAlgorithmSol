	/* 
		1. 테스트 명 : React Native에서 pushTxForNewDistributionChannel 테스트
		2. debugger-ui : (2) [BigNumber, "jiho"]
			
		3. React Native : 
				console.log(result[0].c[0]);
        console.log(result[1]);
		4. 알게된 점 : 성공
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
        if(isTableEmpty()){ // 유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
            pushInitialTx(totalPrice, date);
        }else{
            pushTxForNewDistributionChannel(totalPrice, date);
        }
    }

    // 유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
    function pushInitialTx(uint totalPrice, string date) public {
        distributionChannelTable[0].push(currentTx(
            // txIndex,
            // sellerAddr,
            // buyerAddr,
            // itemName,
            // volum,
            totalPrice,
            date
        ));            
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

    //  이 코드위치는 유통 경로 테이블에 값이 있고 이전거래가 없는 상태이다.
    //  즉 테이블에 값이 있고 이전거래가 없어서 새로운 유통 경로를 생성하는 것이다.
    function pushTxForNewDistributionChannel(uint totalPrice, string date){
        distributionChannelTable[getMappingLength()].push(currentTx(
            // txIndex,
            // sellerAddr,
            // buyerAddr,
            // itemName,
            // volum,
            totalPrice,
            date
        )); 
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


