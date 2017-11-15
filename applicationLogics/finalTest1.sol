	/* 
		1. 테스트 명 : React Native에서 getTx를 Promise.all()로 값 받아오기 테스트
			sendCurrentTx()를 6번 보냄.
			getTx()를 Promise.all로 3번 호출함.
		2. debugger-ui : // 한개만 leaf까지 접근한 것을 적음.
			(4) [Array(3), Array(3), Array(3), Array(3)]
			0: (3) [true, BigNumber, BigNumber]
				0: true
				1: BigNumber {s: 1, e: 0, c: Array(1)}
					c:[0]
				2: BigNumber {s: 1, e: 0, c: Array(1)}
					c:[3]
			1: (3) [true, BigNumber, BigNumber]
			2: (3) [false, BigNumber, BigNumber]
			3: (3) [true, BigNumber, BigNumber]
			
		3. React Native : 

		4. 알게된 점 : React Native에서 Promise.all을 사용하면 for()를 사용한 효과를 낼수있다.
	*/

pragma solidity ^0.4.0;
contract DistributionChannelTrace {
    struct currentTx {  //  현 시점에서 일어난 도매업자간의 거래를 의미하는 자료구조이다.
        string _txIndex;
        address _sellerAddr;
        address _buyerAddr;
        string _itemName;
        uint _volum;
        uint _totalPrice;
        string _date;
    }
    
    // struct getDistributionChannelStackInfo{
    //     bool _doesHaveTx;
    //     uint _mappingCounter;
    //     uint _selectedMappingLength;
    // }

    mapping(uint => currentTx[]) public distributionChannelTable;

    function sendCurrentTx(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volum, uint totalPrice, string date) public {
        if(isTableEmpty()){ // 유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
            pushInitialTx(txIndex, sellerAddr, buyerAddr, itemName, volum, totalPrice, date);
        }else if(!pushTxOnPreviousTx(txIndex, sellerAddr, buyerAddr, itemName, volum, totalPrice, date)){  //  true는 이전거래 삽입이 끝난 상태이다.
            pushTxForNewDistributionChannel(txIndex, sellerAddr, buyerAddr, itemName, volum, totalPrice, date);
        }
    }

    // 유통 경로 테이블이 비었다. stack을 만들면서 currentTx를 삽입한다.
    // function pushInitialTx(address sellerAddr, address buyerAddr, uint totalPrice, string date) public {
    function pushInitialTx(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volum, uint totalPrice, string date) public {
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
            if(retailTraderAddress == distributionChannelTable[mappingCounter][i]._buyerAddr){
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
		    a._volum,
		    a._totalPrice,
		    a._date
		);
	}

    //  이전거래인지 검증한다.
    function pushTxOnPreviousTx(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volum, uint totalPrice, string date) returns (bool) {
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