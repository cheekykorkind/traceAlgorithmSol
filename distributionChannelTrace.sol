contract DistributionChannelTrace {
/*	이제 모든 경우의 수 검증만 남은듯하다.
    
*/
    struct currentTx {  //  현 시점에서 일어난 도매업자간의 거래를 의미하는 자료구조이다.
        string _txIndex;
        address _sellerAddr;
        address _buyerAddr;
        string _itemName;
        uint _volum;
        uint _totalPrice;
        string _date;
    }
	
	//  유통 경로 1개당 stack 1개를 만들면서 유통 경로 추적을 가능하게 하는 자료구조이다. 배열 순회때문에 uint로 바꺼야할듯
    mapping(uint => currentTx[]) distributionChannelTable;

    /*
		유통 경로 테이블을 전부 검사해서 현재 Tx와 겹치는 Tx가 있는지 검사한다.
		유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
		유통 경로 테이블에 값이 있다.
				이전거래인지 검증한다.
				이전 거래이면 그 위에 push한다.
				이전 거래가 아니다.
					이 코드위치는 유통 경로 테이블에 값이 있고 이전거래가 없는 상태이다.
					stack을 만들면서 currentTx를 삽입한다.
	*/
    function sendCurrentTx(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volum, uint totalPrice, string date) public returns(uint) {
        if(isTableEmpty()){ // 유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
            pushIntialTx(txIndex, sellerAddr, buyerAddr, itemName, volum, totalPrice, date);
            return 1;
        }else if(pushTxOnPreviousTx(txIndex, sellerAddr, buyerAddr, itemName, volum, totalPrice, date)){  //  이전거래이다.
            // true는 이전거래가 있다는 것이고, false는 이전거래가 없다는 뜻이다.
            return 2;
        }
        pushTxForNewDistributionChannel(txIndex, sellerAddr, buyerAddr, itemName, volum, totalPrice, date);
        return 3;
    }
        
    function pushTxForNewDistributionChannel(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volum, uint totalPrice, string date){
        distributionChannelTable[getMappingLength()].push(currentTx(
            txIndex,
            sellerAddr,
            buyerAddr,
            itemName,
            volum,
            totalPrice,
            date
        )); 
    }
        
    //  이전거래인지 검증한다.
    function pushTxOnPreviousTx(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volum, uint totalPrice, string date) public returns (bool) {
        uint arrayCounter;
        uint stackCounter;
        bool result = false;

        while(arrayCounter < getMappingLength() ){
            while(stackCounter < distributionChannelTable[arrayCounter].length){
                if(sellerAddr == distributionChannelTable[arrayCounter][stackCounter]._buyerAddr){
                    distributionChannelTable[arrayCounter].push(currentTx(
                        txIndex,
                        sellerAddr,
                        buyerAddr,
                        itemName,
                        volum,
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
    
    // mapping의 최대 길이를 구한다.
	function getMappingLength() public returns (uint){
        uint mappingLength;
	    while(distributionChannelTable[mappingLength].length != 0 ){ //  스택의 길이가 0이기 전까지가 mapping의 최대 길이이다.
            mappingLength++;
        }
        return mappingLength;
	}

    // 유통 경로 테이블이 비었는가?
	function isTableEmpty() public returns (bool){
        if(distributionChannelTable[0].length == 0){
            return true;    //  비었다.
        }else{
            return false;   //  Tx가 있다.
        }
	}


    // 유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
    function pushIntialTx(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volum, uint totalPrice, string date) public {
        distributionChannelTable[0].push(currentTx(
            txIndex,
            sellerAddr,
            buyerAddr,
            itemName,
            volum,
            totalPrice,
            date
        ));            
    }
    // 디버깅용. tx내용 확인하기
// 	function getTx(string txIndex, uint arrayIndex) public returns(string, address, address, string, uint, uint, string){
// 		currentTx a = distributionChannelTable[txIndex][arrayIndex];
// 		return (
// 		    a._txIndex,
// 		    a._sellerAddr,
// 		    a._buyerAddr,
// 		    a._itemName,
// 		    a._volum,
// 		    a._totalPrice,
// 		    a._date
// 		);
// 	}
    
    // 저장된 array의 길이를 각각 체크한다. 디버깅용
//     function getStackLength() public returns(uint stack1Length, uint stack2Length){
//         // r_txAddress = distributionChannelTable[_a][_b].txAddress;
//         // r_addressIndex = distributionChannelTable[_a][_b].addressIndex;
//         stack1Length = distributionChannelTable[0xd5ff82c1ec6f6f834ec5b3ce9a039fa6fe86f40d].length;
//         stack2Length = distributionChannelTable[0x960f751f23be02a2e5c31dbb4ff3ca47437e9611].length;
//     }
		
// 		// return이 0이면 존재하지 않는다고 간주한다.
// 	function isTableEmpty(address _a) public returns (uint _length){
// 		_length = distributionChannelTable[_a].length;
// 	}		
}
