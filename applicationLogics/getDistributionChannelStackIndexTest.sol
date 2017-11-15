	/* 
		1. 테스트 명 : React Native에서 getDistributionChannelStackIndex 테스트
			
		2. debugger-ui : 
			
		3. React Native : 
				console.log(result[0]);
				console.log(result[1]);
				console.log(result[2].c[0]);
        console.log(result[3]);
		4. 알게된 점 : 
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
    
    struct getDistributionChannelStackInfo{
        bool _doesHaveTx;
        uint _mappingCounter;
        uint _selectedMappingLength;
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

	/* Android 디바이스에서 smart contract에 소매업자 account와 소매업자의 품목이 존재하는 유통 경로를 반환한다.
		1. 소매업자 account와 품목이 존재하는 유통 경로를 찾는다.
		2. 해당 유통 경로를 최초 거래에서 마지막 거래까지 순차적으로 반환한다.
		3. 두번쨰 uint는 mapping에서 스택의 위치를 알려주고, 세번째 uint는 stack의 반복횟수를 알려준다.
		4. Android에서 getDistributionChannelStackIndex()를 getMappingLength()만큼 호출해서 이름이 distributionChannels 인자가 (r_stackIndex, r_stackLength)인 동적 배열을 만들고
			stack 1개의 모든 값을 돌려주는 function을 distributionChannels의 인자수 만큼 호출해서 모든 유통 값을 받는다.
	*/
    function getDistributionChannelStackIndex(address retailTraderAddress, string itemName)  public returns(bool, uint, uint){
        getDistributionChannelStackInfo[] channelsInfo;
        uint maxMappingLength = getMappingLength();
        
        uint mappingCounter=0;  //  mapping 에서의 위치
        uint selectedMappingLength; //  소매상의 거래가 존재하는 mapping의 배열길이

        uint i;
        
        while(mappingCounter < maxMappingLength){
            i=0;
            selectedMappingLength = distributionChannelTable[mappingCounter].length;
            while(i < selectedMappingLength){
                if(retailTraderAddress == distributionChannelTable[mappingCounter][i]._buyerAddr){
                    channelsInfo.push(getDistributionChannelStackInfo(
                        true,
                        mappingCounter,
                        selectedMappingLength
                    ));
                }
                i++;
            }
            mappingCounter++;
        }
        if(channelsInfo.length != 0){
            return (true, channelsInfo[0]._mappingCounter, channelsInfo[0]._selectedMappingLength);
        }else{
            return (false, 0, 0);
        }
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






