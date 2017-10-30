	// 어떤 형태의 function이 React Native에서 값을 받을수 있는지 테스트한다.
	// 테스트 명 : getTest2.sol에서 external, public, internal, private는 전부에러. getTest3.sol에서는 constant까지 테스트한다.
	// debugger-ui : constant는 BigNumber {s: 1, e: 1, c: Array(1)}을 return 
	// React Native : getTest1.sol과 동일
	
contract Simple {
    uint storedData;

    function set(uint x) {
        storedData = x;
    }

    function get_external() external returns (uint) {	//	Error: invalid address
        return storedData;
    }
		function get_public() public returns (uint) {	//	Error: invalid address
        return storedData;
    }
		function get_internal() internal returns (uint) {	// TypeError: (0 , _simpleStorage.getContractInstance)(...).get_internal is not a function
        return storedData;
    }
		function get_private() private returns (uint) {	// TypeError: (0 , _simpleStorage.getContractInstance)(...).get_private is not a function
        return storedData;
    }
		function get_constant() constant returns (uint) { // BigNumber {s: 1, e: 1, c: Array(1)}
        return storedData;
    }		
}

