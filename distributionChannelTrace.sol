contract DistributionChannelTrace {
/*	doesHavePreviousTx 테스트이다.
    아래 3 데이터를 순서대로 실행하면 유통 경로 테이블이 빈 경우, 이전 거래인 경우, 그 외의 경우인 것을 확인할수있다.
    sendCurrentTx() "0x333dc52494bbbb14aa442ff73838581172bf934614ab2070f5d6d07d6765d03c", "0x960f751f23be02a2e5c31dbb4ff3ca47437e9611", "0xd5ff82c1ec6f6f834ec5b3ce9a039fa6fe86f40d", "rice", 11, 10000, "20170903"
    sendCurrentTx() "0x333dc52494bbbb14aa442ff73838581172bf934614ab2070f5d6d07d6765d03c", "0xd5ff82c1ec6f6f834ec5b3ce9a039fa6fe86f40d", "0x960f751f23be02a2e5c31dbb4ff3ca47437e9611", "rice", 10, 10000, "20170902"
    sendCurrentTx() "0x333dc52494bbbb14aa442ff73838581172bf934614ab2070f5d6d07d6765d03c", "0xd5ff82c1ec6f6f834", "0x960f751f23be02a2e5c31dbb4ff3ca47437e9611", "rice", 10, 10000, "20170902"
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
	
	//  유통 경로 1개당 stack 1개를 만들면서 유통 경로 추적을 가능하게 하는 자료구조이다.
    mapping(string => currentTx[]) distributionChannelTable;

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
        if(!doesHaveCurrentTx(txIndex)){    //  유통 경로 테이블을 전부 검사해서 현재 Tx와 겹치는 Tx가 있는지 검사한다.
        // 유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
            pushTx(txIndex, sellerAddr, buyerAddr, itemName, volum, totalPrice, date);
            return 1;
        }else if(doesHavePreviousTx(txIndex, sellerAddr)){  //  이전거래이다.
            return 2;
        }
        return 3;
    }
        
    //  이전거래인지 검증한다.
    function doesHavePreviousTx(string txIndex, address currentSeller) public returns (bool) {
        uint i;
        while(i < distributionChannelTable[txIndex].length){
            if(currentSeller == distributionChannelTable[txIndex][i]._buyerAddr){  //  이전거래이다.
                return true;
            }
            i++;
        }
		return false;	//	이전거래가 없다.
    }
    
    // 유통 경로 테이블을 전부 검사해서 현재 Tx와 겹치는 Tx가 있는지 검사한다.
	function doesHaveCurrentTx(string txIndex) public returns (bool){
	    if(distributionChannelTable[txIndex].length != 0){
	        return true;
	    }else{
	        return false;
	    }
	}
	
	function testDoesHaveCurrentTx(string txIndex) public returns (bool){
        if(doesHaveCurrentTx(txIndex)){
            return true;
        }else{
            return false;
        }		    
	}

    // 유통 경로 테이블에 currentTx를 push한다.
    function pushTx(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volum, uint totalPrice, string date) public {
        distributionChannelTable[txIndex].push(currentTx(
            txIndex,
            sellerAddr,
            buyerAddr,
            itemName,
            volum,
            totalPrice,
            date
        ));
    }
}
