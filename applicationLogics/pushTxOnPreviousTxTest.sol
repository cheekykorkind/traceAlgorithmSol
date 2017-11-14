	/* 
		1. 테스트 명 : React Native에서 pushTxOnPreviousTx 테스트
			sendCurrentTx()를 3번 보냄.
			getTx()로 0,1을 가져와봄
		2. debugger-ui : 
			(4) ["0xf4d8e706cfb25c0decbbdd4d2e2cc10c66376a3f", "0x7d42e5038444fbfa0b9d9d8c15eff1e27dc5bec6", BigNumber, "20170904"]
		3. React Native : 
				console.log(result[0]);
				console.log(result[1]);
				console.log(result[2].c[0]);
        console.log(result[3]);
		4. 알게된 점 : smart contract function의 파라미터에 맞춘 gas추가는 중요하다.
	*/

pragma solidity ^0.4.0;
contract DistributionChannelTrace {
    struct currentTx {  //  현 시점에서 일어난 도매업자간의 거래를 의미하는 자료구조이다.
        // string _txIndex;
        address _sellerAddr;
        address _buyerAddr;
        // string _itemName;
        // uint _volum;
        uint _totalPrice;
        string _date;
    }

    mapping(uint => currentTx[]) public distributionChannelTable;

    function sendCurrentTx(address sellerAddr, address buyerAddr, uint totalPrice, string date) public {
        if(isTableEmpty()){ // 유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
            pushInitialTx(sellerAddr, buyerAddr, totalPrice, date);
        }else if(!pushTxOnPreviousTx(sellerAddr, buyerAddr, totalPrice, date)){  //  true는 이전거래 삽입이 끝난 상태이다.
            pushTxForNewDistributionChannel(sellerAddr, buyerAddr, totalPrice, date);
        }
    }

    // 유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
    // function pushInitialTx(address sellerAddr, address buyerAddr, uint totalPrice, string date) public {
    function pushInitialTx(address sellerAddr, address buyerAddr, uint totalPrice, string date) public {
        distributionChannelTable[0].push(currentTx(
            sellerAddr,
            buyerAddr,
            totalPrice,
            date
        ));
    }

    // tx 1개 get
	function getTx(uint arrayIndex, uint stackIndex) public constant returns(address, address, uint, string){
		currentTx storage a = distributionChannelTable[arrayIndex][stackIndex];
		return (
		  //  a._txIndex,
		    a._sellerAddr,
		    a._buyerAddr,
		  //  a._itemName,
		  //  a._volum,
		    a._totalPrice,
		    a._date
		);
	}

    //  이전거래인지 검증한다.
    function pushTxOnPreviousTx(address sellerAddr, address buyerAddr, uint totalPrice, string date) returns (bool) {
        uint arrayCounter;
        uint stackCounter;
        bool result = false;

        while(arrayCounter < getMappingLength() ){
            while(stackCounter < distributionChannelTable[arrayCounter].length){
                if(sellerAddr == distributionChannelTable[arrayCounter][stackCounter]._buyerAddr){
                    distributionChannelTable[arrayCounter].push(currentTx(
                        // txIndex,
                        sellerAddr,
                        buyerAddr,
                        // itemName,
                        // volum,
                        totalPrice,
                        date
                    ));
                    result = true;
                }
                stackCounter++;
            }
            stackCounter = 0;
            arrayCounter++;
        }
        return result;
    }   

    //  이 코드위치는 유통 경로 테이블에 값이 있고 이전거래가 없는 상태이다.
    //  즉 테이블에 값이 있고 이전거래가 없어서 새로운 유통 경로를 생성하는 것이다.
    function pushTxForNewDistributionChannel(address sellerAddr, address buyerAddr, uint totalPrice, string date){
        distributionChannelTable[getMappingLength()].push(currentTx(
            // txIndex,
            sellerAddr,
            buyerAddr,
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






