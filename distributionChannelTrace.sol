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
pragma solidity ^0.4.0;
contract DistributionChannelTrace {
    struct currentTx {  //  현 시점에서 일어난 도매업자간의 거래를 의미하는 자료구조이다.
        string _txIndex;
        address _sellerAddr;
        address _buyerAddr;
        string _itemName;
        uint _volume;
        uint _totalPrice;
        string _date;
    }
    
    mapping(uint => currentTx[]) public distributionChannelTable;

    function sendCurrentTx(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volume, uint totalPrice, string date) public {
        if(isTableEmpty()){ // 유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
            pushInitialTx(txIndex, sellerAddr, buyerAddr, itemName, volume, totalPrice, date);
        }else if(!pushTxOnPreviousTx(txIndex, sellerAddr, buyerAddr, itemName, volume, totalPrice, date)){  //  true는 이전거래 삽입이 끝난 상태이다.
            pushTxForNewDistributionChannel(txIndex, sellerAddr, buyerAddr, itemName, volume, totalPrice, date);
        }
    }

    // 유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
    // function pushInitialTx(address sellerAddr, address buyerAddr, uint totalPrice, string date) public {
    function pushInitialTx(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volume, uint totalPrice, string date) public {
        distributionChannelTable[0].push(currentTx(
            txIndex,
            sellerAddr,
            buyerAddr,
            itemName,
            volume,
            totalPrice,
            date
        ));
    }

	/* Android 디바이스에서 smart contract에 소매업자 account와 소매업자의 품목이 존재하는 유통 경로를 반환한다.
		1. 소매업자 account와 품목이 존재하는 유통 경로를 찾는다.
		2. 해당 유통 경로를 최초 거래에서 마지막 거래까지 순차적으로 반환한다.
		3. 두번쨰 uint는 mapping에서 스택의 위치를 알려주고, 세번째 uint는 stack의 반복횟수를 알려준다.
		4. Android에서 getDistributionChannelStackIndex()를 getMappingLength()만큼 호출해서 이름이 distributionChannels 인자가 (r_stackIndex, r_stackLength)인 동적 배열을 만들고
			stack 1개의 모든 값을 돌려주는 function을 distributionChannels의 인자수 만큼 호출해서 모든 유통 값을 받는다.
		별도1. android device는 getMappingLength()횟수만큼 loop를 진행하는데, mappingCounter가 loopcounter가 들어간다.
		즉, getMappingLength()만큼 getDistributionChannelStackIndex()를 호출한다.
		별도2. true인 데이터셋을 모아서 getTx()를 호출한다.
	*/
    function getDistributionChannelStackIndex(address retailTraderAddress, string itemName, uint mappingCounter) constant returns(bool, uint, uint){
        uint selectedMappingLength = distributionChannelTable[mappingCounter].length;
        uint i;
        while(i < selectedMappingLength){
            if((retailTraderAddress == distributionChannelTable[mappingCounter][i]._buyerAddr) &&
                stringsEqual(distributionChannelTable[mappingCounter][i]._itemName, itemName)){
                return (true, mappingCounter, selectedMappingLength);
            }
            i++;
        }
        return (false, mappingCounter, selectedMappingLength);
    }

    // tx 1개 get
	function getTx(uint arrayIndex, uint stackIndex) public constant returns(string, address, address, string, uint, uint, string){
		currentTx storage a = distributionChannelTable[arrayIndex][stackIndex];
		return (
		    a._txIndex,
		    a._sellerAddr,
		    a._buyerAddr,
		    a._itemName,
		    a._volume,
		    a._totalPrice,
		    a._date
		);
	}

    //  이전거래인지 검증한다.
    function pushTxOnPreviousTx(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volume, uint totalPrice, string date) returns (bool) {
        uint arrayCounter;
        uint stackCounter;
        bool result = false;

        while(arrayCounter < getMappingLength() ){
            while(stackCounter < distributionChannelTable[arrayCounter].length){
                if(sellerAddr == distributionChannelTable[arrayCounter][stackCounter]._buyerAddr &&
                stringsEqual(distributionChannelTable[arrayCounter][stackCounter]._itemName, itemName)){
                    distributionChannelTable[arrayCounter].push(currentTx(
                        txIndex,
                        sellerAddr,
                        buyerAddr,
                        itemName,
                        volume,
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
    function pushTxForNewDistributionChannel(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volume, uint totalPrice, string date){
        distributionChannelTable[getMappingLength()].push(currentTx(
            txIndex,
            sellerAddr,
            buyerAddr,
            itemName,
            volume,
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
	
    function stringsEqual(string storage _a, string memory _b) internal returns (bool) {
        bytes storage a = bytes(_a);
        bytes memory b = bytes(_b);
        if (a.length != b.length){
            return false;
        }
            
        for (uint i = 0; i < a.length; i ++){
            if (a[i] != b[i])
                return false;            
        }
        return true;
    }	
}
