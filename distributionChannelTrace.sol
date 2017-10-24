contract DistributionChannelTrace {
/*	Android 디바이스에서 smart contract로 값을 push하는 3가지 경우 테스트 완료
	테이블이 빈 경우 push, 이전거래가 위에 push, 테이블에 값이 있는데 이전거래가 아닌경우 push
  테스트 데이터는 아래와 같다.(결과는 1, 3, 2)
	"0xaabb", "0xb1cd96427c550b2cc670c592c4ef061468e28731", "0xf4d8e706cfb25c0decbbdd4d2e2cc10c66376a3f", "rice", 10, 10000, "20170902"
	"0xffcc", "0x960f751f23be02a2e5c31dbb4ff3ca47437e9611", "0x7d42e5038444fbfa0b9d9d8c15eff1e27dc5bec6", "rice", 50, 50000, "20170903"
	"0xbbcc", "0xf4d8e706cfb25c0decbbdd4d2e2cc10c66376a3f", "0x7d42e5038444fbfa0b9d9d8c15eff1e27dc5bec6", "rice", 5, 5000, "20170904"
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
    //  이 코드위치는 유통 경로 테이블에 값이 있고 이전거래가 없는 상태이다.
    //  즉 테이블에 값이 있고 이전거래가 없어서 새로운 유통 경로를 생성하는 것이다.
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
	
    // 디버깅용. tx내용 확인하기
	function getTx(uint arrayIndex, uint stackIndex) public returns(string, address, address, string, uint, uint, string){
		currentTx a = distributionChannelTable[arrayIndex][stackIndex];
		return (
		    a._txIndex,
		    a._sellerAddr,
		    a._buyerAddr,
		    a._itemName,
		    a._volum,
		    a._totalPrice,
		    a._date
		);
	}
}
