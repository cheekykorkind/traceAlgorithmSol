contract DistributionChannelTrace {
    /* 함수 파라미터 유의할점. 
			1. address 타입에 Ethereum TxHash를 입력하면 길이가 길어서 맞지 않는다.
			2. Ethereum TxHash는 string 으로 선언하면 사용 가능하다.
		*/ 
    struct currentTx1 {
        string _txIndex;
        address _sellerAddr;
        address _buyerAddr;
        string _itemName;
        uint _volum;
        uint _totalPrice;
        string _date;
    }
    struct currentTx2 {
        string _txIndex;
        address _sellerAddr;
        address _buyerAddr;
        string _itemName;
        uint _volum;
        uint _totalPrice;
    }
    struct currentTx3 {
        string _txIndex;
        address _sellerAddr;
        address _buyerAddr;
        string _itemName;
        uint _volum;
    }
    struct currentTx4 {
        string _txIndex;
        address _sellerAddr;
        address _buyerAddr;
        string _itemName;
    }
    struct currentTx5 {
        string _txIndex;
        address _sellerAddr;
        address _buyerAddr;
    }
    struct currentTx6 {
        string _txIndex;
        address _sellerAddr;
    }
    struct currentTx7 {
        string _txIndex;
    }    
	//  유통 경로 1개당 stack 1개를 만들면서 유통 경로 추적을 가능하게 하는 자료구조이다.
    mapping(address => currentTx1[]) distributionChannelTable1;
    mapping(string => currentTx2[]) distributionChannelTable2;
    mapping(string => currentTx3[]) distributionChannelTable3;
    mapping(string => currentTx4[]) distributionChannelTable4;
    mapping(string => currentTx5[]) distributionChannelTable5;
    mapping(string => currentTx6[]) distributionChannelTable6;
    mapping(string => currentTx7[]) distributionChannelTable7;
		
    function pushTx1(address txIndex, address sellerAddr, address buyerAddr, string itemName, uint volum, uint totalPrice, string date) public {
        distributionChannelTable1[txIndex].push(currentTx1(
            txIndex,
            sellerAddr,
            buyerAddr,
            itemName,
            volum,
            totalPrice,
            date
        ));
    }
    function pushTx2(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volum, uint totalPrice) public {
        distributionChannelTable2[txIndex].push(currentTx2(
            txIndex,
            sellerAddr,
            buyerAddr,
            itemName,
            volum,
            totalPrice
        ));
    }
    function pushTx3(string txIndex, address sellerAddr, address buyerAddr, string itemName, uint volum) public {
        distributionChannelTable3[txIndex].push(currentTx3(
            txIndex,
            sellerAddr,
            buyerAddr,
            itemName,
            volum
        ));
    }
    function pushTx4(string txIndex, address sellerAddr, address buyerAddr, string itemName) public {
        distributionChannelTable4[txIndex].push(currentTx4(
            txIndex,
            sellerAddr,
            buyerAddr,
            itemName
        ));
    }
    function pushTx5(string txIndex, address sellerAddr, address buyerAddr) public {
        distributionChannelTable5[txIndex].push(currentTx5(
            txIndex,
            sellerAddr,
            buyerAddr
        ));
    }
    function pushTx6(string txIndex, address sellerAddr) public {
        distributionChannelTable6[txIndex].push(currentTx6(
            txIndex,
            sellerAddr
        ));
    }
    function pushTx7(string txIndex) public {
        distributionChannelTable7[txIndex].push(currentTx7(
            txIndex
        ));
    }
}
