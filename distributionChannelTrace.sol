contract DistributionChannelTrace {
/*	getMappingLength(), getDistributionChannelStackIndex(), getTx()로 원하는 유통 경로들 받아오기
		1. getMappingLength()의 결과를 mappingLength에 저장한다.
    2. getDistributionChannelStackIndex()를 mappingLength 만큼
			 Android 디바이스에서 파라미터를 바꿔가면서 loop를 실행한다.
			예) getDistributionChannelStackIndex("0x7d42e5038444fbfa0b9d9d8c15eff1e27dc5bec6", "rice", 0)
			   getDistributionChannelStackIndex("0x7d42e5038444fbfa0b9d9d8c15eff1e27dc5bec6", "rice", 1)...
		3. getDistributionChannelStackIndex()의 결과로 원하는 유통 경로가 존재하는 mapping index와 해당 index에
			존재하는 stack의 길이(=거래 갯수)를 저장한 동적배열 distributionChannels[]가 생성된다.
		4. distributionChannels[]의 length만큼 getTx()를 실행한다.
			예) getTx(0,1) getTx(1,1) ...
		5. getTx()들의 결과를 저장한 동적배열 selectedDistributionChannels[]가 생성된다.
		6. selectedDistributionChannels[]의 인자를 Android의 그래프나 애니메이션에 적용한다. 
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

	/* Android 디바이스에서 smart contract에 소매업자 account와 소매업자의 품목이 존재하는 유통 경로를 반환한다.
		1. 소매업자 account와 품목이 존재하는 유통 경로를 찾는다.
		2. 해당 유통 경로를 최초 거래에서 마지막 거래까지 순차적으로 반환한다.
		3. r_stackIndex는 mapping에서 스택의 위치를 알려주고, r_stackLength는 stack의 반복횟수를 알려준다.
		4. Android에서 getDistributionChannelStackIndex()를 여러번 호출해서 이름이 distributionChannels 인자가 (r_stackIndex, r_stackLength)인 동적 배열을 만들고
			stack 1개의 모든 값을 돌려주는 function을 distributionChannels의 인자수 만큼 호출해서 모든 유통 값을 받는다.
	*/
    function getDistributionChannelStackIndex(address retailTraderAddress, string itemName, uint mappingCounter)  public returns(int, int){
        uint selectedMappingLength = distributionChannelTable[mappingCounter].length;
        uint i;
        while(i < selectedMappingLength){
            if(retailTraderAddress == distributionChannelTable[mappingCounter][i]._buyerAddr){
                
                return (int(mappingCounter), int(selectedMappingLength));
            }
            i++;
        }
        return (int(-1), int(-1));
    }
    
    // tx 1개 get
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
}
