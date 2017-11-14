	/* 
		1. 테스트 명 : React Native에서 sendCurrentTx(address sellerAddr, address buyerAddr, uint totalPrice, string date) 테스트.
									즉, 함수의 파라미터가 큰 경우를 테스트 한다.
		2. debugger-ui : 
			(4) ["0xb1cd96427c550b2cc670c592c4ef061468e28731", "0x7d42e5038444fbfa0b9d9d8c15eff1e27dc5bec6", BigNumber, "20170902"]
			
		3. React Native : // 실험중
				console.log(result[0]);
				console.log(result[1]);
				console.log(result[2].c[0]);
        console.log(result[3]);
		4. 알게된 점 : smart contract function의 파라미터가 커지면, EVM에서 동작할때 파라미터를 복사하는데 사용되는 gas도 증가한다. 
								gas량을 알맞게 추가해 주지 않으면 EVM는 state를 변화시키지 않는다.
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
        // if(isTableEmpty()){ // 유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
            pushInitialTx(sellerAddr, buyerAddr, totalPrice, date);
        // }else if(!pushTxOnPreviousTx(sellerAddr, buyerAddr, totalPrice, date)){  //  true는 이전거래 삽입이 끝난 상태이다.
        //     pushTxForNewDistributionChannel(sellerAddr, buyerAddr, totalPrice, date);
        // }
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

    // //  이전거래인지 검증한다.
    // function pushTxOnPreviousTx(address sellerAddr, address buyerAddr, uint totalPrice, string date) returns (bool) {
    //     uint arrayCounter;
    //     uint stackCounter;
    //     bool result = false;

    //     while(arrayCounter < getMappingLength() ){
    //         while(stackCounter < distributionChannelTable[arrayCounter].length){
    //             if(sellerAddr == distributionChannelTable[arrayCounter][stackCounter]._buyerAddr){
    //                 distributionChannelTable[arrayCounter].push(currentTx(
    //                     // txIndex,
    //                     sellerAddr,
    //                     buyerAddr,
    //                     // itemName,
    //                     // volum,
    //                     totalPrice,
    //                     date
    //                 ));
    //                 result = true;
    //             }
    //             stackCounter++;
    //         }
    //         stackCounter = 0;
    //         arrayCounter++;
    //     }
    //     return result;
    // }   

    // //  이 코드위치는 유통 경로 테이블에 값이 있고 이전거래가 없는 상태이다.
    // //  즉 테이블에 값이 있고 이전거래가 없어서 새로운 유통 경로를 생성하는 것이다.
    // function pushTxForNewDistributionChannel(address sellerAddr, address buyerAddr, uint totalPrice, string date){
    //     distributionChannelTable[getMappingLength()].push(currentTx(
    //         // txIndex,
    //         sellerAddr,
    //         buyerAddr,
    //         // itemName,
    //         // volum,
    //         totalPrice,
    //         date
    //     )); 
    // }
	
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








